# typed: true
# frozen_string_literal: false

require 'pathname'
require 'yaml'

module Frontman
  class DataStoreFile
    attr_accessor :path, :file_name, :base_file_name, :parent,
                  :position, :data

    def initialize(path, file_name, base_file_name, parent)
      @path = path
      @file_name = file_name
      @base_file_name = base_file_name
      @parent = parent
      @data = (YAML.load_file(@path) || {}).to_ostruct

      @@i ||= 0
      @position = @@i
      @@i += 1
    end

    def method_missing(method_id, *arguments, &block)
      @data.public_send(method_id, *arguments, &block)
    end

    def respond_to_missing?(method_id, _)
      @data.respond_to? method_id
    end

    def current_path
      @path
    end

    def refresh
      return unless @parent.auto_reload_files

      data = YAML.load_file(@path) || {}
      @data = data.to_ostruct
    end

    def to_s
      "<DataStoreFile #{@data.keys.join(', ')} >"
    end
  end
end
