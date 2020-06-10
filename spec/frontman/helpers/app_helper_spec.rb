# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'lib/frontman/helpers/app_helper'
require 'lib/frontman/config'

describe AppHelper do
  subject do
    Class.new do
      include AppHelper
    end.new
  end

  it 'should be in build mode if :mode config is set to build' do
    Frontman::Config.set(:mode, 'build')
    expect(subject.build?).to eq true
  end

  it 'should be in serve mode if :mode config by default' do
    Frontman::Config.set(:mode, nil)
    expect(subject.serve?).to eq true
  end
end
