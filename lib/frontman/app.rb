# typed: true
# frozen_string_literal: false

require 'frontman/sitemap_tree'
require 'frontman/data_store'
require 'frontman/helpers/UrlHelper'
require 'singleton'
require 'sorbet-runtime'

module Frontman
  class App
    extend T::Sig
    include Singleton

    attr_accessor :current_page, :current_tree, :view_data
    attr_reader :layouts, :ignores, :redirects, :assets_manifest

    sig { void }
    def initialize
      @current_page = nil
      @current_tree = nil
      @view_data = []
      @layouts = []
      @ignores = []
      @redirects = {}
      @assets_manifest = {}
    end

    sig { returns(Frontman::SitemapTree) }
    def sitemap_tree
      @sitemap_tree ||= Frontman::SitemapTree.new(nil)
    end

    sig { returns(Frontman::DataStore) }
    def app_data
      @app_data ||= Frontman::DataStore.new
    end

    sig { returns(T.self_type) }
    def app
      self
    end

    sig { params(config: String).void }
    def run(config)
      instance_eval config
    end

    sig { params(glob: String, layout_name: String).void }
    def register_layout(glob, layout_name)
      layout = glob, layout_name
      @layouts.push(layout)
    end

    sig { params(helpers: T::Array[T::Hash[Symbol, String]]).void }
    def register_helpers(helpers)
      helpers.each do |helper|
        require T.must(helper[:path])
        singleton_class.send(:include, Object.const_get(T.must(helper[:name]).to_sym))
      end
    end

    sig { params(from: String, to: String).returns(String) }
    def add_redirect(from, to)
      from = format_url(from)

      @redirects[from] = to
    end

    sig { params(url: String).returns(T.nilable(String)) }
    def get_redirect(url)
      url = format_url(url)

      @redirects[url]
    end

    sig { params(key: String, value: String).returns(String) }
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

    private

    sig { params(key: T.any(String, Symbol)).returns(T.untyped) }
    def get_from_current_page(key)
      return unless current_page && current_page.data.respond_to?(key)

      current_page.data[key]
    end

    sig { params(key: T.any(String, Symbol)).returns(T.untyped) }
    def get_from_view_data(key)
      return if @view_data.empty? || @view_data.last.nil?

      return @view_data.last[key] unless @view_data.last[key].nil?

      local_data = @view_data.last[:locals]
      local_data[key] unless local_data.nil?
    end
  end
end
