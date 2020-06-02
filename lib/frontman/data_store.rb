# typed: true
# frozen_string_literal: false

require 'pathname'
require 'frontman/data_store_file'
require 'sorbet-runtime'

module Frontman
  class DataStore
    extend T::Sig

    attr_reader :base_file_name, :path, :parent

    sig do
      params(
        path: String,
        base_file_name: T.nilable(String),
        parent: T.nilable(DataStore)
      ).void
    end
    def initialize(path, base_file_name = nil, parent = nil)
      @path = path
      @cache = {}
      @parent = parent
      @base_file_name = base_file_name

      load_files
    end

    sig { returns(Array) }
    def flatten
      elements = []

      @cache.sort_by { |_k, v| v.path }.each do |_k, v|
        if v.instance_of?(Frontman::DataStoreFile)
          v.refresh
          elements.push(v)
        else
          elements.push(*v.flatten)
        end
      end

      elements
    end

    def method_missing(method_id, *arguments, &block)
      method_name = method_id

      # Make sure we are able to access data files with an array syntax
      method_name = arguments[0].to_sym if method_id == :[]

      if @cache.key?(method_name.to_s)
        cached = @cache[method_name.to_s]

        if Frontman::App.instance.refresh_data_files
          cached.refresh if cached.is_a?(Frontman::DataStoreFile)
        end

        return cached
      end

      # Make sure we forward the access to the data
      if @cache.respond_to?(method_name)
        return @cache.public_send(method_name, &block)
      end

      nil
    end

    def respond_to_missing?(method_name, _)
      @cache.key?(method_name.to_s) || @cache.respond_to?(method_name)
    end

    sig { returns(String) }
    def to_s
      "<DataStore #{@cache.keys.join(', ')} >"
    end

    private

    sig { void }
    def load_files
      Dir.entries(@path).sort.each do |file|
        next if (file == '.') || (file == '..')

        file_path = @path + '/' + file

        # remove numbers and first '-' from the filename so we can
        # - generate nice urls
        # - omit the number when accessing the object
        base_file_name = file.gsub(/[0-9]*+-?(.+)/, '\1')

        if File.file?(file_path) && (File.extname(file) == '.yml')
          method_name = File.basename(base_file_name, File.extname(file))
          @cache[method_name.to_s] = Frontman::DataStoreFile.new(
            file_path, file, method_name, self
          )
        elsif File.directory?(file_path)
          @cache[base_file_name] = DataStore.new(
            file_path, base_file_name, self
          )
        end
      end
    end
  end
end
