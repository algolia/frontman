# frozen_string_literal: true

# typed: true

require 'yaml/front-matter'
require 'frontman/renderers/renderer_resolver'
require 'frontman/custom_struct'
require 'frontman/context'
require 'frontman/app'
require 'frontman/sitemap_tree'

module Frontman
  class Resource
    attr_reader :dir, :file, :extension
    attr_accessor :destination_path, :data, :renderers, :compiled, :file_path

    def self.from_path(file_path, destination_path = nil, is_page = true)
      destination_path ||= file_path
      file_path = file_path.gsub(%r{^/}, '')
      destination_path = destination_path.gsub(%r{^/}, '')
                                         .gsub(%r{/[0-9]+?-}, '/')
                                         .delete_prefix('source/')

      # We cache the newly created resource so we avoid loosing the cache
      # if from_path is called again with the same file
      # This is especially important for perfs in case of layouts and templates
      @@resources ||= {}
      @@resources[destination_path] ||= new(
        file_path, destination_path, is_page
      )
    end

    def self.resources
      @@resources ||= {}
    end

    def strip_extensions(path)
      split = path.split('/')
      without_extension = split.last.split('.')[0]
      path_without_extensions = split.first(split.length - 1)
                                     .append(without_extension)
                                     .join('/')
      extensions = split.last.split('.')[1..-1]
      [path_without_extensions, extensions]
    end

    def setup_extension_renderers
      @file_path_without_extension, rendering_extensions = strip_extensions(
        @file_path
      )
      rendering_extensions.reverse!
      @renderers = rendering_extensions.map do |ext|
        Frontman::RendererResolver.instance.get_renderer(ext)
      end.compact
    end

    def setup_destination
      destination_without_extension, dest_file_extensions = strip_extensions(
        @destination_path
      )
      is_index_page = destination_without_extension.end_with?('index')
      @extension = dest_file_extensions.first

      if (@extension == 'html' || extension.nil?) && !is_index_page
        @destination_path = destination_without_extension + '/index.html'
      else
        @destination_path = destination_without_extension + '.' + @extension
      end
    end

    def parse_snippet_file
      # TODO: this is docs specific...
      snippet_file = @file_path_without_extension + '.yml'
      return unless File.exist?(snippet_file)

      begin
        snippet_data = YAML.safe_load(File.read(snippet_file)).to_ostruct
      rescue Psych::SyntaxError => e
        raise("#{e} - #{snippet_file}")
      end
      @data[:guide_snippet] = snippet_data
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
      parse_snippet_file if @is_page
    end

    def render(content_for_layout = nil, extra_data = {})
      view_data = data.to_h.merge(extra_data).to_ostruct
      layout_path = layout
      layout_from_extra_data = false

      if extra_data.key? 'layout'
        layout_path = "views/layouts/#{view_data[:layout]}"
        layout_from_extra_data = extra_data[:layout]
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

    def layout
      return nil unless @is_page

      Frontman::App.instance.layouts.each do |(glob, layout)|
        return layout if File.fnmatch(glob, @destination_path)
      end

      nil
    end

    def content_blocks
      @content_blocks ||= {}
    end

    def mtime
      @mtime ||= File.mtime(@file_path)
    end

    def inspect
      "Resource: #{@file_path}"
    end

    def indexable?
      data.key?(:indexable) ? data[:indexable] : true
    end

    def generate_pages_for_languages?
      return false if data[:language]

      !languages.empty? && !destination_path.include?('/api-client/methods/')
    end

    def languages
      data[:languages] || []
    end

    def destination_path_for_language(lang)
      target = destination_path
      path = if target.end_with?('index.html')
               target.gsub(%r{/index\.html}, "/#{lang}/index.html")
             else
               target.gsub(/(.+?)\.(.+?)/, "\\1/#{lang}.\\2")
             end

      "/#{path}"
    end

    private

    def initialize(file_path, destination_path, is_page)
      raise "File does not exists: #{file_path}" unless File.exist?(file_path)

      @file_path = file_path
      @destination_path = destination_path
      @is_page = is_page

      setup_extension_renderers
      setup_destination

      parse_resource
    end
  end
end
