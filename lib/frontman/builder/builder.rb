# typed: true
# frozen_string_literal: true

require 'frontman/builder/file'
require 'frontman/concerns/dispatch_events'
require 'frontman/iterator'
require 'sorbet-runtime'

module Frontman
  module Builder
    class Builder
      extend T::Sig
      include Frontman::DispatchEvents

      attr_accessor :build_directory, :current_build_files

      sig { void }
      def initialize
        @emit_events = true
        @build_directory = Dir.pwd + '/build/'
        @current_build_files = []
      end

      sig do
        params(resource: Frontman::Resource).returns(Frontman::Builder::File)
      end
      def build_resource(resource)
        build_from_content(create_path_from_resource(resource), resource.render)
      end

      sig do
        params(resources: T::Array[Frontman::Resource])
          .returns(T::Array[String])
      end
      def build_from_resources(resources)
        # Disable emitting of events, this causes problems when done in parallel
        @emit_events = false
        opts = { in_processes: (Frontman::Iterator.processor_count / 2).ceil }
        resources = Frontman::Iterator.map(resources, opts) do |resource|
          build_resource(resource)
        end

        # After the resources are built, we emit all events synchronously
        @emit_events = true
        resources.map do |build_file|
          fire_build_event(build_file)
          build_file.path
        end
      end

      sig do
        params(assets_to_build: T::Array[String]).returns(T::Array[String])
      end
      def build_assets(assets_to_build)
        # We need to go through ERB files at the end so assets_manifest filled
        assets_to_build.sort_by! { |f| f.end_with?('.erb') ? 1 : 0 }
        assets_to_build.map do |path|
          if path.end_with?('.erb')
            build_file = build_from_erb(
              path,
              path.sub('.tmp/dist/', '').gsub('.erb', '')
            )
          else
            build_file = build_from_asset(
              path,
              path.sub('.tmp/dist/', '')
            )
          end

          build_file.path
        end
      end

      sig do
        params(path: String, manifest_path: String)
          .returns(Frontman::Builder::File)
      end
      def build_from_asset(path, manifest_path)
        path_with_digest = add_asset_to_manifest(manifest_path, path)
        target_path = create_target_path(path_with_digest)

        build_from_content(target_path, ::File.read(path))
      end

      sig do
        params(path: String, manifest_path: String)
          .returns(Frontman::Builder::File)
      end
      def build_from_erb(path, manifest_path)
        path_with_digest = add_asset_to_manifest(manifest_path, path)
        build_resource(Resource.from_path(path, path_with_digest))
      end

      sig { returns(T::Array[String]) }
      def build_redirects
        Frontman::App.instance.redirects.map do |from, to|
          build_file = build_redirect(from, to)
          build_file.path
        end
      end

      sig { params(files_to_delete: T::Array[String]).void }
      def delete_files(files_to_delete)
        files_to_delete.each do |path|
          delete_from_path(path)
        end
      end

      private

      sig do
        params(destination_path: String, redirect_to: String)
          .returns(Frontman::Builder::File)
      end
      def build_redirect(destination_path, redirect_to)
        content = <<~REDIRECT
          <!DOCTYPE html>
              <link rel="canonical" href="#{redirect_to}" />
              <meta http-equiv=refresh content="0; url=#{redirect_to}" />
              <meta name="robots" content="noindex,follow" />
              <meta http-equiv="cache-control" content="no-cache" />
          </html>
        REDIRECT

        build_from_content(create_target_path(destination_path), content)
      end

      sig do
        params(build_file: Frontman::Builder::File)
          .returns(Frontman::Builder::File)
      end
      def fire_build_event(build_file)
        emit(build_file.status, build_file) if @emit_events
        build_file
      end

      sig { params(path: String).returns(Frontman::Builder::File) }
      def delete_from_path(path)
        FileUtils.rm_f(path)
        fire_build_event(File.deleted(path))
      end

      sig { params(file_path: String, content: String).returns(T::Boolean) }
      def content_changed?(file_path, content)
        ::File.read(file_path) != content
      end

      sig { params(file_path: String).returns(T::Boolean) }
      def exists_in_current_build?(file_path)
        current_build_files.include?(file_path)
      end

      sig do
        params(file_path: String, content: String)
          .returns(Frontman::Builder::File)
      end
      def build_from_content(file_path, content)
        file_exists = exists_in_current_build?(file_path)

        if file_exists && !content_changed?(file_path, content)
          return fire_build_event(File.unchanged(file_path))
        end

        ::File.write(file_path, content)

        fire_build_event(
          file_exists ? File.updated(file_path) : File.created(file_path)
        )
      end

      sig { params(destination_path: String).returns(String) }
      def create_target_path(destination_path)
        # dir = destination_path.split('/')[0..-2].join('/')
        dir = ::File.dirname(destination_path)
        destination = build_directory + dir
        FileUtils.mkdir_p(destination)

        build_directory + destination_path.sub(%r{^/}, '')
      end

      sig { params(resource: Frontman::Resource).returns(String) }
      def create_path_from_resource(resource)
        create_target_path(resource.destination_path)
      end

      sig { params(path: String).returns(String) }
      def digest(path)
        ::Digest::SHA1.file(path).hexdigest[0..7]
      end

      sig do
        params(manifest_path: String, file_path: String)
          .returns(String)
      end
      def add_asset_to_manifest(manifest_path, file_path)
        path_with_digest = manifest_path.sub(/\.(\w+)$/) do |ext|
          "-#{digest(file_path)}#{ext}"
        end

        Frontman::App.instance.add_to_manifest(manifest_path, path_with_digest)
        path_with_digest
      end
    end
  end
end
