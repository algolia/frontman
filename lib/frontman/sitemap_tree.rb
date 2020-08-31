# typed: false
# frozen_string_literal: true

module Frontman
  class SitemapTree
    attr_reader :path, :children, :url_part
    attr_accessor :parent, :position, :resource, :url

    class << self
      def resources
        @@resources ||= []
      end

      def proxy_resources
        @@proxy_resources ||= {}
      end

      def proxy_resources_from_template(template)
        proxy_resources[format_url(template)] || []
      end

      def format_url(url)
        url.chomp('index.html').gsub('.html', '')
      end
    end

    def resources
      @@resources ||= []
    end

    def add(resource)
      return if resource.destination_path.end_with?('.js', '.css', '.yml')

      url = format_url(resource.destination_path)
      existing_resource = from_url(url)&.resource

      unless existing_resource.nil?
        raise DuplicateResourceError.create(resource, url, existing_resource)
      end

      if Frontman::App.instance.get_redirect(url)
        raise ExistingRedirectError.create(resource, url)
      end

      SitemapTree.resources.push(resource)
      parts = url.split('/')
      used_parts = []
      add_parts(parts, used_parts, resource)
    end

    def add_proxy(destination, template, data = {})
      resource = Resource.from_path(template, destination, true)
      resource.data = resource.data.to_h.merge(data.to_h).to_ostruct

      key = format_url(template)

      SitemapTree.proxy_resources[key] ||= []
      T.must(SitemapTree.proxy_resources[key]).push(resource)

      add(resource)
    end

    def initialize(url_part)
      @parent = nil
      @children = []
      @resource = nil
      @url_part = url_part
      @@urls ||= {}
      @position = nil
      @url = nil
    end

    def format_url(url)
      url.chomp('index.html').gsub('.html', '')
    end

    def final_url
      "/#{format_url(@url)}/"
    end

    def from_resource(resource)
      from_url(format_url(resource.destination_path))
    end

    def from_url(url)
      return self if url == '/'

      @@urls[url.gsub(%r{^/}, '').gsub(%r{/$}, '').to_sym]
    end

    def ancestor(part, level = 0)
      ancestors = [self]
      ancestor = self

      while !ancestor.nil? && (ancestor.url_part != part)
        ancestor = ancestor.parent
        ancestors.unshift(ancestor)
      end

      ancestors[level] if !ancestor.nil? && (ancestor.url_part == part)
    end

    def flatten(take = false)
      resources = []

      resources.push(self) if take && @resource && @children.empty?

      children.each do |child|
        resources += child.flatten(true)
      end

      resources
    end

    def get_all_pages(options = {})
      resources = []
      resources.push(self) if @resource

      @children.each do |child|
        resources.push(child) unless child.resource.nil?

        resources += child.get_all_pages(options)
      end

      resources.uniq
    end

    def add_parts(parts, used_parts, resource)
      if parts.length <= 0
        @resource = resource
        return
      end

      current_part = parts.shift
      used_parts.push(current_part)
      child = @children.select { |c| c.url_part == current_part }
      child = !child.empty? ? child[0] : nil

      if child.nil?
        child = SitemapTree.new(current_part)
        child.parent = self
        url = used_parts.join('/')
        child.url = url
        @@urls[url.to_sym] = child
        child.position = @children.length
        @children.push(child)
      end

      child.add_parts(parts, used_parts, resource)
    end

    def find(parts)
      return self if parts.length <= 0

      current_part = parts.shift
      child = @children.select { |c| c.url_part == current_part }

      child[0].find(parts) unless child.empty?
    end

    def siblings
      @parent.children
    end

    def pages
      children.select(&:resource)
    end

    def folder?
      !children.empty?
    end

    def languages
      children.select { |c| @@languages.include?(c.url_part) }
    end

    def pretty_print(space)
      spaces = space >= 0 ? ' ' * space : ''

      print(spaces + @url_part + "\n") if @url_part

      print(spaces + " -> r\n") if @resource

      @children.each do |child|
        child.pretty_print(space + 1)
      end
    end

    def all_urls
      @@urls
    end

    def inspect
      "SitemapTree: #{@resource ? @resource.destination_path : @url_part}"
    end
  end

end
