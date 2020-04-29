# typed: true
# frozen_string_literal: false

require 'singleton'
require 'htmlentities'
require 'frontman/sitemap_tree'
require 'frontman/data_store'

module Frontman
  class App
    include Singleton

    attr_accessor :current_page, :current_tree, :view_data
    attr_reader :layouts, :ignores, :redirects, :assets_manifest, :commands

    def initialize
      @current_page = nil
      @current_tree = nil
      @view_data = []
      @layouts = []
      @ignores = []
      @redirects = {}
      @commands = {}
      @assets_manifest = {}
    end

    def sitemap_tree
      @sitemap_tree ||= Frontman::SitemapTree.new(nil)
    end

    def app_data
      @app_data ||= Frontman::DataStore.new
    end

    def app
      self
    end

    def run(config)
      instance_eval config
    end

    def register_layout(glob, layout_name)
      layout = glob, layout_name
      @layouts.push(layout)
    end

    def register_helpers(helpers)
      helpers.each do |helper|
        require helper[:path]
        singleton_class.send(:include, Object.const_get(helper[:name].to_sym))
      end
    end

    def register_commands(commands)
      commands.each do |command|
        @commands[File.basename(command, '.rb').to_sym] = command
      end
    end

    def get_command(command)
      @commands[command.to_sym]
    end

    def add_redirect(from, to)
      @redirects[from] = to
    end

    def add_to_manifest(key, value)
      @assets_manifest[key] = '/' + value.sub(%r{^/}, '')
    end

    def method_missing(method_id, *_)
      from_view_data = get_from_view_data(method_id)
      return from_view_data unless from_view_data.nil?

      from_current_page = get_from_current_page(method_id)
      return from_current_page unless from_current_page.nil?

      return true if method_id == :render_toc

      super
    end

    def respond_to_missing?(method_name, include_private = false)
      public_send(method_name)
      true
    rescue StandardError
      super
    end

    # TODO: move this to helper
    def generate_id(str, salt = '')
      id = slugify(str)

      @ids ||= {}
      @ids[salt.to_s + id] ||= 0
      @ids[salt.to_s + id] += 1
      @ids[salt.to_s + id] == 1 ? id : "#{id}-#{@ids[salt.to_s + id]}"
    end

    def reset_ids_generation
      @ids = {}
    end

    def slugify(string)
      HTMLEntities.new
                  .decode(string || '')
                  .gsub(%r{</?[^>]*>}, '')
                  .gsub(/\s/, '-')
                  .gsub(%r{[\[\]()/",`'&<>\.*]}, '')
                  .downcase
    end
    # if moved, require 'htmlentities' is not needed
    # END TODO

    private

    def get_from_current_page(key)
      return unless current_page && current_page.data.respond_to?(key)

      current_page.data[key]
    end

    def get_from_view_data(key)
      return if @view_data.empty? || @view_data.last.nil?

      return @view_data.last[key] unless @view_data.last[key].nil?

      local_data = @view_data.last[:locals]
      local_data[key] unless local_data.nil?
    end
  end
end
