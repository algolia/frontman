# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'frontman/app'
require 'frontman/bootstrapper'
require 'frontman/config'

describe Frontman::Bootstrapper do
  context 'helpers' do
    it 'should find all helpers in a given folder' do
      result = Frontman::Bootstrapper.find_helpers_in(
        'spec/frontman/mocks/helpers/'
      )
      expect(result.size).to eq 3
    end
  end

  context 'bootstrap app' do
    it 'should only bootstrap the app once' do
      Frontman::Config.set(:config_path, 'spec/frontman/mocks/config.rb')
      app = Frontman::App.instance
      expect(app).to receive(:run).once

      Frontman::Bootstrapper.bootstrap_app(app)
      Frontman::Bootstrapper.bootstrap_app(app)
    end
  end

  context 'resources' do
    it 'should find all resources in a given folder' do
      resources = Frontman::Bootstrapper.resources_from_dir('spec/frontman/mocks')

      expect(resources.size).to eq 14 # Number of non-YAML files in this folder
    end
  end
end
