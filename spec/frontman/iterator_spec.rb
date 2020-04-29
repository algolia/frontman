# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'parallel'
require 'frontman/config'
require 'frontman/iterator'

describe Frontman::Iterator do
  before(:each) do
    Frontman::Config.all.keys.each do |key|
      Frontman::Config.delete(key)
    end
  end

  it 'should run in parallel by default' do
    expect(Parallel).to receive(:map)

    Frontman::Iterator.map []
  end

  it 'should not run in parallel if config says so' do
    expect(Parallel).to_not receive(:map)
    Frontman::Config.set :parallel, false

    Frontman::Iterator.map []
  end

  context 'processor count' do
    it 'should take the config value if not running in parallel' do
      Frontman::Config.set :parallel, false
      Frontman::Config.set :processor_count, 2

      expect(Frontman::Iterator.processor_count).to eq 2
    end

    it 'should use Parallels method if running in parallel' do
      expect(Frontman::Iterator.processor_count).to eq Parallel.processor_count
    end

    it 'should default to 1 if not running in parallel and no config is provided' do
      Frontman::Config.set :parallel, false

      expect(Frontman::Iterator.processor_count).to eq 1
    end
  end
end
