# typed: true
# frozen_string_literal: true

require './spec/spec_setup'
require 'lib/frontman/data_store'

describe Frontman::DataStore do
  subject { Frontman::DataStore.new("#{__dir__}/mocks") }

  it 'should ignore non-processable files' do
    expect(subject.asset).to eq nil
  end

  it 'should flatten' do
    expect(subject.flatten.size).to eq 4
    expect(subject.nested.flatten.size).to eq 2
  end

  it 'should access data correctly' do
    expect(subject.info.name).to eq 'test'
    expect(subject.info.types).to be_a Array
  end

  it 'should return nil when accessing nonexistent files' do
    expect(subject.non_existant).to eq nil
  end

  it 'should access parent folder' do
    expect(subject.nested.more_data.parent.base_file_name).to eq 'nested'
  end

  it 'should have name and path' do
    expect(subject.nested.base_file_name).to eq 'nested'
    expect(subject.nested.current_path).to eq "#{__dir__}/mocks/nested"
  end
end
