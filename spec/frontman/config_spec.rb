# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'frontman/config'

describe Frontman::Config do
  before(:each) do
    Frontman::Config.all.keys.each do |key|
      Frontman::Config.delete(key)
    end
  end

  it 'should hold the correct value' do
    Frontman::Config.set(:foo, 'bar')

    expect(Frontman::Config.get('foo')).to eq 'bar'
  end

  it 'should not return the default if the set value is falsy' do
    Frontman::Config.set(:foo, nil)

    expect(Frontman::Config.get('foo', fallback: 'baz')).to eq nil
  end

  it 'should return the default value if the key is not set' do
    expect(Frontman::Config.get('foo', fallback: 'baz')).to eq 'baz'
  end

  it 'should indicate whether the key exists' do
    Frontman::Config.set(:foo, nil)

    expect(Frontman::Config.has?('foo')).to eq true
    expect(Frontman::Config.has?('bar')).to eq false
  end

  it 'should delete the config' do
    expect(Frontman::Config.has?('foo')).to eq false
    Frontman::Config.set(:foo, nil)
    expect(Frontman::Config.has?('foo')).to eq true
    Frontman::Config.delete(:foo)
    expect(Frontman::Config.has?('foo')).to eq false
  end

  it 'should return all the config values' do
    Frontman::Config.set(:foo, nil)
    Frontman::Config.set('bar', 'baz')
    expected = {
      foo: nil,
      bar: 'baz'
    }
    expect(Frontman::Config.all).to eq expected
  end
end
