# frozen_string_literal: true

require 'rspec'
require 'simplecov'
require 'bundler'

SimpleCov.start do
  add_filter '/spec'
end

# encoding: utf-8
$LOAD_PATH << File.expand_path('..', __dir__)

# Pull in all of the gems including those in the `test` group
Bundler.require :default, :test, :development, :debug
