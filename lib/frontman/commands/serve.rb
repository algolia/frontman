# frozen_string_literal: false

require 'thor'
require 'sinatra/base'
require 'better_errors'
require 'listen'
require 'frontman/app'
require 'frontman/bootstrapper'
require 'frontman/builder/asset_pipeline'
require 'frontman/config'
require 'frontman/resource'

module Frontman
  class CLI < Thor
    desc 'serve', 'Serve your application'
    def serve

      Frontman::Config.set(:mode, 'serve')
      Frontman::Bootstrapper.bootstrap_app(Frontman::App.instance)

      assets_pipeline = Frontman::Builder::AssetPipeline.new(
        Frontman::App.instance
          .asset_pipelines
          .filter { |p| %i[all serve].include?(p[:mode]) }
      )
      processes = assets_pipeline.run_in_background!(:before)

      helpers_dir = Frontman::Config.get(:helpers_dir, fallback: 'helpers')
      listen_to_dirs = Frontman::Config.get(:observe_dirs, fallback:
        [
          Frontman::Config.get(:layout_dir, fallback: 'views/layouts'),
          Frontman::Config.get(:partials_dir, fallback: 'views/partials'),
          Frontman::Config.get(:content_dir, fallback: 'source/'),
          helpers_dir
        ])
      Frontman::App.instance.refresh_data_files = true

      listener = Listen.to(*listen_to_dirs) do |modified, added|
        (added + modified).each do |m|
          resource_path = m.sub("#{Dir.pwd}/", '')
          if resource_path.start_with?(helpers_dir)
            helper_name = File.basename(resource_path).gsub('.rb', '')
            Frontman::App.instance.register_helpers(
              [{ path: File.join(Dir.pwd, resource_path), name: helper_name }]
            )
          elsif resource_path.start_with?(*listen_to_dirs)
            r = Frontman::Resource.from_path(resource_path)
            r&.parse_resource(true)
          elsif resource_path.end_with?('.rb')
            load("./#{resource_path}")
          end
        end
      end

      listener.start

      FrontManServer.set :public_folder, Frontman::Config.get(
        :public_folder, fallback: 'public'
      )
      FrontManServer.run! do
        host = "http://localhost:#{FrontManServer.settings.port}"
        print "== View your site at \"#{host}/\"\n"
        processes += assets_pipeline.run_in_background!(:after)
        at_exit { processes.each { |pid| Process.kill(0, pid) } }
      end
    end
  end
end

class FrontManServer < Sinatra::Base
  set :port, 4568
  set :server_settings,
      # Avoid having webrick displaying logs for every requests to the serve
      AccessLog: [],
      # Remove logger for WebRick, we have the one of sinatra already
      Logger: Rack::NullLogger.new(self)

  use BetterErrors::Middleware
  BetterErrors.application_root = Dir.pwd

  get '*' do |path|
    app = Frontman::App.instance
    return redirect to app.get_redirect(path), 302 if app.get_redirect(path)

    tree = app.sitemap_tree.from_url(path)
    if tree&.resource
      tree.resource.render
    else
      halt 404
    end
  end
end
