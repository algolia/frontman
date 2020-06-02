# frozen_string_literal: false

require 'thor'
require 'frontman/app'
require 'frontman/bootstrapper'
require 'frontman/builder/asset_pipeline'
require 'frontman/builder/builder'
require 'frontman/builder/mapping'
require 'frontman/builder/statistics_collector'
require 'frontman/config'
require 'frontman/toolbox/timer'
require 'frontman/sitemap_tree'

module Frontman
  class CLI < Thor
    option :sync, type: :boolean
    option :verbose, type: :boolean
    desc 'build', 'Generate the HTML for your website'
    def build

      Frontman::Config.set(:mode, 'build')
      Frontman::Bootstrapper.bootstrap_app(Frontman::App.instance)

      assets_pipeline = Frontman::Builder::AssetPipeline.new(
        Frontman::App.instance
          .asset_pipelines
          .filter { |p| %i[all build].include?(p[:mode]) }
      )

      assets_pipeline.run!(:before)

      enable_parallel = !options[:sync]

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

      assets_pipeline.run!(:after)

      Builder::StatisticsCollector.output(builder, mapping, timer, new_files)
    end
  end
end
