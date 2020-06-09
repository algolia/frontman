# frozen_string_literal: false

require './lib/frontman/version'

Gem::Specification.new do |s|
  s.name                  = 'frontman-ssg'
  s.version               = Frontman::VERSION
  s.date                  = '2019-06-06'
  s.summary               = 'A static site generator built for speed'
  s.description           = 'A flexible static site generator built for speed'
  s.authors               = [
    'Maxime Locqueville', 'Sarah Dayan', 'Devin Beeuwkes'
  ]
  s.email                 = 'devin@algolia.com'
  s.homepage              = 'https://rubygems.org/gems/frontman-ssg'
  s.license               = 'MIT'
  s.required_ruby_version = '~> 2.6.0'
  s.files                 = `git ls-files`.split("\n")
  s.require_path          = 'lib'
  s.executables           = ['frontman']
  s.add_development_dependency 'rake',       '~> 0'
  s.add_development_dependency 'rspec', '~> 3.8'
  s.add_development_dependency 'rubocop', '~> 0.71.0'
  s.add_development_dependency 'rubocop-performance', '~> 1.3.0'
  s.add_development_dependency 'simplecov', '~> 0.16.1'
  s.add_development_dependency 'sorbet'

  s.add_runtime_dependency 'better_errors', '~> 2.6.0'
  s.add_runtime_dependency 'binding_of_caller', '0.8.0'
  s.add_runtime_dependency 'bundler'
  s.add_runtime_dependency 'dotenv', '~> 2.7.5'
  s.add_runtime_dependency 'erubis', '~> 2.7.0'
  s.add_runtime_dependency 'haml', '5.0.4'
  s.add_runtime_dependency 'htmlentities', '~> 4.3.4'
  s.add_runtime_dependency 'kramdown', '~> 2.1.0'
  s.add_runtime_dependency 'kramdown-parser-gfm', '~> 1.1.0'
  s.add_runtime_dependency 'listen', '~> 3.0'
  s.add_runtime_dependency 'nokogiri', '~> 1.10.9'
  s.add_runtime_dependency 'parallel', '~> 1.17.0'
  s.add_runtime_dependency 'rouge', '~> 3.16.0'
  s.add_runtime_dependency 'sinatra', '~> 2.0'
  s.add_runtime_dependency 'sorbet-runtime', '~> 0.5'
  s.add_runtime_dependency 'thor', '~> 0.20.3'
  s.add_runtime_dependency 'yaml-front-matter', '0.0.1'
end
