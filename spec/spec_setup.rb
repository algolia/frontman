# frozen_string_literal: true

require 'rspec'
require 'simplecov'
require 'frontman/bootstrapper'
require 'frontman/app'

SimpleCov.start do
  add_filter '/spec'
end

# encoding: utf-8
$LOAD_PATH << File.expand_path('..', __dir__)

Frontman::Bootstrapper.bootstrap_app(Frontman::App.instance)
