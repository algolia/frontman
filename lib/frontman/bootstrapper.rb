# frozen_string_literal: true
# typed: ignore

require 'sorbet-runtime'
require 'frontman/app'
require 'frontman/resource'

module Frontman
  class Bootstrapper
    class << self
      extend T::Sig

      sig { params(path: String).returns(T::Array[T::Hash[Symbol, String]]) }
      def find_helpers_in(path)
        Dir.entries(path).map do |file|
          next unless file.end_with?('Helper.rb')

          {
            path: File.join(path, file),
            name: file.gsub('.rb', '')
          }
        end.compact
      end

      sig { params(app: Frontman::App).returns(Frontman::App) }
      def bootstrap_app(app)
        unless bootstrapped?
          register_default_helpers(app)

          config_path = Frontman::Config.get(
            :config_path,
            fallback: './config.rb'
          )
          if File.exist?(config_path)
            app.run(File.read(config_path))
          end

          @@bootstrapped = true
        end

        app
      end

      sig { params(content_root: String).returns(T::Array[Frontman::Resource]) }
      def resources_from_dir(content_root)
        files = Dir.glob(
          File.join(content_root, '**/*')
        )

        files.reject! { |f| File.directory?(f) || File.fnmatch('**.yml', f) }
        files.sort! { |a, b| a <=> b || 0 }
        files.map do |path|
          Frontman::Resource.from_path(path, path.delete_prefix(content_root))
        end
      end

      def bootstrapped?
        @@bootstrapped ||= false
      end

      private

      sig { params(app: Frontman::App).void }
      def register_default_helpers(app)
        app.register_helpers(
          find_helpers_in(File.join(__dir__, 'helpers'))
        )
      end
    end
  end
end
