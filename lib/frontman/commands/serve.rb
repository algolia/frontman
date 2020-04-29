# frozen_string_literal: false

require 'thor'
require 'sinatra/base'
require 'better_errors'
require 'listen'
require 'frontman/app'
require 'frontman/config'
require 'frontman/resource'

module Frontman
  class CLI < Thor
    desc 'serve', 'Serve your application'
    def serve
      Frontman::Config.set(:mode, 'serve')
      listen_to_dirs = Frontman::Config.get(:observe_dirs, fallback: ['source'])
      Frontman::App.instance.app_data.set_auto_reload_files(true)

      listener = Listen.to(*listen_to_dirs) do |modified, added|
        (added + modified).each do |m|
          resource_path = m.sub("#{Dir.pwd}/", '')
          if resource_path.start_with?('source', 'views')
            r = Frontman::Resource.from_path(resource_path)

            r&.parse_resource(true)
          elsif resource_path.start_with?('helpers')
            helper_name = resource_path.gsub(%r{helpers/(.*?)\.rb}, '\1')
            Frontman::App.instance.register_helpers(
              [{ path: File.join(Dir.pwd, resource_path), name: helper_name }]
            )
          elsif resource_path.start_with?('lib')
            load("./#{resource_path}")
          end
        end
      end

      listener.start

      FrontManServer.run! do
        print "== View your site at \"http://localhost:4568/\"\n"
      end
    end
  end
end

class FrontManServer < Sinatra::Base
  set :public_folder, '.tmp/dist'
  set :port, 4568
  set :server_settings,
      # Avoid having webrick displaying logs for every requests to the serve
      AccessLog: [],
      # Remove logger for WebRick, we have the one of sinatra already
      Logger: Rack::NullLogger.new(self)

  use BetterErrors::Middleware
  BetterErrors.application_root = Dir.pwd

  get '*' do |path|
    if Frontman::App.instance.redirects.key?("#{path}index.html")
      target = Frontman::App.instance.redirects["#{path}index.html"]
      return redirect to(target), 302
    end

    tree = Frontman::App.instance.sitemap_tree.from_url(path)
    if tree&.resource
      tree.resource.render
    else
      halt 404
    end
  end
end
