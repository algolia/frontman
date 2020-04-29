# frozen_string_literal: false

require 'thor'
require 'frontman/builder/builder'
require 'frontman/builder/mapping'
require 'frontman/builder/statistics_collector'
require 'frontman/toolbox/timer'

module Frontman
  class CLI < Thor
    option :sync, type: :boolean
    option :verbose, type: :boolean
    desc 'build', 'Generate the HTML for your website'
    def build
      enable_parallel = !options[:sync]

      Frontman::Config.set(:mode, 'build')
      Frontman::Config.set(:parallel, enable_parallel)

      timer = Frontman::Toolbox::Timer.start

      current_build_files = Dir.glob(Dir.pwd + '/build/**/*').reject do |f|
        File.directory? f
      end
      assets_to_build = Dir.glob('.tmp/dist/**/*').reject do |f|
        File.directory? f
      end

      mapping_path = Dir.pwd + '/_build.json'
      mapping = Frontman::Builder::Mapping.new(mapping_path)
      mapping.delete_file

      build_directory = Dir.pwd + '/build/'
      builder = Frontman::Builder::Builder.new
      builder.build_directory = build_directory
      builder.current_build_files = current_build_files

      builder.on('created, updated, deleted, unchanged', lambda { |build_file|
        mapping.add_from_build_file(build_file)
      })

      assets = builder.build_assets(assets_to_build)
      redirects = builder.build_redirects

      resources_paths = builder.build_from_resources(
        Frontman::SitemapTree.resources
      )

      new_files = assets + redirects + resources_paths

      builder.delete_files(current_build_files - new_files)
      mapping.save_file

      Builder::StatisticsCollector.output(builder, mapping, timer, new_files)
    end
  end
end
