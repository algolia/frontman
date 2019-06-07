# frozen_string_literal: true

require './spec/spec_setup'
require './lib/frontman/config'

describe Frontman::Config do
  subject { Frontman::Config.instance }

  it 'should hide the constructor for public use' do
    expect { Frontman::Config.new }. to raise_error NoMethodError
  end

  it 'should set configuration properly' do
    subject.set 'foo', 'bar'
    expect(subject.all.length).to eq 1
  end

  it 'should get configuration properly' do
    subject.set 'foo', 'bar'
    expect(subject.get('foo')).to eq 'bar'
  end

  it 'should return a default value if the provided key does not exist' do
    subject.set 'foo', 'bar'
    expect(subject.get('bar', 'default')).to eq 'default'
  end

  it 'should return nil when assigned to a certain key' do
    subject.set 'foo', nil
    expect(subject.get('foo', 'default')).to eq nil
  end

  it 'should respond to missing methods if the config key exists' do
    subject.set 'foo', 'bar'
    expect(subject.respond_to?('foo')).to eq true
    expect(subject.respond_to?('bar')).to eq false
  end

  it 'should forward missing method calls to get config values' do
    subject.set 'foo', 'bar'
    expect(subject.foo).to eq 'bar'
  end
end
