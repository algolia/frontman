# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'frontman/builder/file'

describe Frontman::Builder::File do
  subject { Frontman::Builder::File.new('fake/path', :created) }

  it 'should return the correct path' do
    expect(subject.path).to eq 'fake/path'
  end

  context 'updated' do
    subject { Frontman::Builder::File.updated('fake/path') }

    it 'should initialize with the right status' do
      expect(subject.status).to eq :updated
    end
  end

  context 'created' do
    subject { Frontman::Builder::File.created('fake/path') }

    it 'should initialize with the right status' do
      expect(subject.status).to eq :created
    end
  end

  context 'deleted' do
    subject { Frontman::Builder::File.deleted('fake/path') }

    it 'should initialize with the right status' do
      expect(subject.status).to eq :deleted
    end
  end

  context 'unchanged' do
    subject { Frontman::Builder::File.unchanged('fake/path') }

    it 'should initialize with the right status' do
      expect(subject.status).to eq :unchanged
    end
  end
end
