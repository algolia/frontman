# typed: true
# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'sorbet-runtime'

module Frontman
  module Builder
    class Mapping
      extend T::Sig

      attr_reader :output_path

      sig { params(output_path: String).void }
      def initialize(output_path)
        @output_path = output_path
        @mapping = {
          updated: [],
          created: [],
          unchanged: [],
          deleted: []
        }
      end

      sig { returns(T::Hash[T.any(String, Symbol), T::Array[String]]) }
      def all
        @mapping
      end

      sig { params(build_file: Frontman::Builder::File).void }
      def add_from_build_file(build_file)
        add(build_file.status, build_file.path)
      end

      sig { params(status: T.any(String, Symbol), path: String).void }
      def add(status, path)
        @mapping[status.to_sym].push(path)
      end

      sig { void }
      def save_file
        ::File.open(output_path, 'w') do |f|
          f.write(JSON.pretty_generate(@mapping))
        end
      end

      sig { void }
      def delete_file
        FileUtils.rm_f(output_path)
      end
    end
  end
end
