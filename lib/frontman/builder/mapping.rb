# frozen_string_literal: true

# typed: true
require 'fileutils'
require 'json'

module Frontman
  module Builder
    class Mapping
      def initialize(output_path)
        @output_path = output_path
        @mapping = {
          updated: [],
          created: [],
          unchanged: [],
          deleted: []
        }
      end

      def all
        @mapping
      end

      def add_from_build_file(build_file)
        add(build_file.status, build_file.path)
      end

      def add(status, path)
        @mapping[status.to_sym].push(path)
      end

      def save_file
        ::File.open(output_path, 'w') do |f|
          f.write(JSON.pretty_generate(@mapping))
        end
      end

      def delete_file
        FileUtils.rm_f(output_path)
      end

      attr_reader :output_path
    end
  end
end
