# typed: true
# frozen_string_literal: true

require 'frontman/renderers/renderer_resolver'
require 'frontman/custom_struct'
require 'frontman/context'
require 'frontman/app'
require 'frontman/sitemap_tree'
require 'sorbet-runtime'
require 'yaml/front-matter'

module Frontman
  class Resource
    extend T::Sig

    attr_reader :dir, :file, :extension, :path
    attr_accessor :destination_path, :data, :renderers, :compiled, :file_path

    class << self
      extend T::Sig

      sig { returns(T::Hash[String, Resource]) }
      def resources
        @@resources || {}
      end

      sig do
        params(
          file_path: String,
          destination_path: T.nilable(String),
          is_page: T::Boolean
        ).returns(Resource)
      end
      def from_path(file_path, destination_path = nil, is_page = true)
        destination_path ||= file_path
        file_path = file_path.gsub(%r{^/}, '')
        destination_path = destination_path.gsub(%r{^/}, '')
                                           .gsub(%r{/[0-9]+?-}, '/')
                                           .sub(%r{^source/}, '')

        # We cache the newly created resource so we avoid loosing the cache
        # if from_path is called again with the same file
        # This is especially important for perf in case of layouts and templates
        @@resources ||= {}
        @@resources[destination_path] ||= new(
          file_path, destination_path, is_page
        )
      end
    end

    sig { params(path: String).returns(Array) }
    def strip_extensions(path)
      split = path.split('/')
      without_extension = T.must(split.last).split('.')[0]
      path_without_extensions = split.first(split.length - 1)
                                     .push(T.must(without_extension))
                                     .join('/')
      extensions = T.must(split.last).split('.')[1..-1]
      [path_without_extensions, extensions]
    end

    sig { void }
    def setup_destination
      destination_without_extension, dest_file_extensions = strip_extensions(
        @destination_path
      )

      if destination_without_extension == 'index'
        destination_without_extension = ''
      end

      is_index_page = destination_without_extension.end_with?('/index')
      @extension = dest_file_extensions.first

      if (@extension == 'html' || extension.nil?) && !is_index_page
        @destination_path = destination_without_extension + '/index.html'
      else
        @destination_path = destination_without_extension + '.' + @extension
      end
      @path = "/#{@destination_path.chomp('index.html')}"
              .gsub('//', '/')
    end

    sig { void }
    def parse_data_file
      data_file = @file_path_without_extension + '.yml'
      return unless File.exist?(data_file)

      begin
        data = YAML.safe_load(File.read(data_file)).to_ostruct
      rescue Psych::SyntaxError => e
        raise("#{e} - #{data_file}")
      end
      @data[:yml] = data
    end

    sig do
      params(
        parse_parent: T::Boolean,
        data: T.any(NilClass, Hash, CustomStruct, OpenStruct)
      ).void
    end
    def parse_resource(parse_parent = false, data = nil)
      @rendered_content = nil

      @content = File.read(@file_path)
      @data = {}.to_ostruct

      if %w[erb html haml md txt].include?(@extension)
        @data, @content = YAML::FrontMatter.extract(@content).to_ostruct
      end

      @data = @data.to_h.merge(data.to_h).to_ostruct unless data.nil?

      @compiled = nil

      # If there is only one renderer we can precompile the file because there
      # is no dependency. This is critical to get good performances, especially
      # for templates and layouts that we also considered as Resources
      if @renderers.size == 1
        @renderer = @renderers[0]
        @compiled = @renderer.compile(@content)
      end

      if parse_parent
        proxy_files = Frontman::SitemapTree.proxy_resources_from_template(
          @file_path
        )

        if proxy_files.length
          proxy_files.each do |r|
            r.parse_resource(false, r.data) unless r == self
          end
        end
      end

      # We need to do that after parsing the resource so @data exists
      parse_data_file if @is_page
    end

    sig do
      params(
        content_for_layout: T.nilable(String),
        extra_data: T.any(Hash, CustomStruct)
      ).returns(String)
    end
    def render(content_for_layout = nil, extra_data = {})
      view_data = data.to_h.merge(extra_data).to_ostruct
      layout_path = layout
      layout_from_extra_data = false

      layout_from_extra_data = extra_data[:layout] if extra_data.key?(:layout)
      if view_data.layout
        layout_path = File.join(
          Frontman::Config.get(:layout_dir, fallback: 'views/layouts'),
          view_data.layout
        )
      end

      if @is_page && !view_data[:ignore_page]
        # We store that in App so it can be accessed from any view
        Frontman::App.instance.current_page = self
        Frontman::App.instance.reset_ids_generation

        sitemap_tree = Frontman::App.instance.sitemap_tree.from_resource(self)
        Frontman::App.instance.current_tree = sitemap_tree
      end

      # If we have no layout to render and already cache the rendered content
      # we can return it directly
      if layout_from_extra_data.nil? && !@rendered_content.nil?
        return @rendered_content
      end

      content = @content

      # We create a new context for each file getting rendered
      context = Frontman::Context.new

      if @compiled
        # If we manage to compile the template (only 1 renderer)
        # we render from the compiled template
        content = @renderer.render(
          @compiled, content_for_layout, context, view_data
        )
      else
        # We loop over each renderer (infered from extensions of the file)
        # and render. The result of the 1st rendered is passed as a argument of
        # the second renderer and so on until we have the final content
        @renderers.each do |renderer|
          compiled = renderer.compile(content)
          content = renderer.render(
            compiled, content_for_layout, context, view_data
          )
        end
      end

      # Cache the rendered content to avoid non necessary processing
      # We do this before rendering the layout because it's usually
      # what's common to every rendering
      @rendered_content = content

      # If a layout is specified we take the rendered content a inject it
      # inside the layout.
      # If layout:nil was specified when triggering the render we don't
      # render the layout and override the layout that can be set in
      # frontmatter or config.rb
      if layout_path && !layout_from_extra_data.nil?
        content = Resource.from_path(layout_path, nil, false).render(content)
      end

      content
    end

    sig { returns(T.nilable(String)) }
    def layout
      return nil unless @is_page

      Frontman::App.instance.layouts.each do |(glob, layout)|
        return layout if File.fnmatch(glob, @destination_path)
      end

      nil
    end

    sig { returns(Hash) }
    def content_blocks
      @content_blocks ||= {}
    end

    sig { returns(Time) }
    def mtime
      @mtime ||= File.mtime(@file_path)
    end

    sig { returns(String) }
    def inspect
      "Resource: #{@file_path}"
    end

    sig { returns(T::Boolean) }
    def indexable?
      data.key?(:indexable) ? data[:indexable] : true
    end

    private

    sig do
      params(
        file_path: String,
        destination_path: String,
        is_page: T::Boolean
      ).void
    end
    def initialize(file_path, destination_path, is_page)
      raise "File does not exists: #{file_path}" unless File.exist?(file_path)

      @file_path = file_path
      @destination_path = destination_path
      @is_page = is_page

      setup_extension_renderers
      setup_destination

      parse_resource
    end

    sig { void }
    def setup_extension_renderers
      @file_path_without_extension, rendering_extensions = strip_extensions(
        @file_path
      )
      rendering_extensions.reverse!
      @renderers = rendering_extensions.map do |ext|
        Frontman::RendererResolver.instance.get_renderer(ext)
      end.compact
    end
  end
end
