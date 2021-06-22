# frozen_string_literal: true

require 'rspec'
require 'simplecov'
require 'bundler'
require 'frontman/bootstrapper'
require 'frontman/app'

SimpleCov.start do
  add_filter '/spec'
end

# encoding: utf-8
$LOAD_PATH << File.expand_path('..', __dir__)

# Pull in all of the gems including those in the `test` group
Bundler.require :default, :test, :development, :debug

Frontman::Bootstrapper.bootstrap_app(Frontman::App.instance)
