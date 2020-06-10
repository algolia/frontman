# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'lib/frontman/helpers/link_helper'

describe LinkHelper do
  subject do
    Class.new do
      include LinkHelper
    end.new
  end

  before(:each) do
    subject.reset_ids_generation
  end

  it 'should properly slugify a string' do
    expect(subject.slugify('Hello world')).to eq 'hello-world'
  end

  it 'should generate an id' do
    expect(subject.generate_id('Hello world')).to eq 'hello-world'
  end

  it 'should append numbers if an id is created multiple times' do
    expect(subject.generate_id('Hello world')).to eq 'hello-world'
    expect(subject.generate_id('Hello world')).to eq 'hello-world-2'
  end

  it 'should reset appended numbers' do
    expect(subject.generate_id('Hello world')).to eq 'hello-world'
    expect(subject.generate_id('Hello world')).to eq 'hello-world-2'
    subject.reset_ids_generation
    expect(subject.generate_id('Hello world')).to eq 'hello-world'
  end

end
