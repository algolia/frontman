# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'frontman/custom_struct'

describe CustomStruct do
  context 'hash to ostruct' do
    subject do
      { merge: 'merge', test: 'test', test1: ['test1', { test2: 'test2' }] }.to_ostruct
    end

    it 'should allow access with method syntax' do
      expect(subject.test).to eq 'test'
      expect(subject.test1.class).to eq Array
      expect(subject.test1[1].class).to eq described_class
      expect(subject.test1[1].test2).to eq 'test2'
    end

    it 'should allow hash syntax ' do
      expect(subject[:test]).to eq 'test'
      expect(subject['test1'].class).to eq Array
    end

    it 'should allow hash syntax in combination with method syntax' do
      expect(subject['test1'][1].class).to eq described_class
      expect(subject['test1'][1].test2).to eq 'test2'
    end

    it 'should disallow keys named like hash methods' do
      expect(subject.merge).not_to eq 'merge'
    end

    it 'should forward hash methods' do
      expect(subject.size).to eq 3
    end
  end

  context 'array to ostruct' do
    subject { ['a_test', { test: 'test', test1: ['test1', { test2: 'test2' }] }].to_ostruct }

    it 'should allow method syntax' do
      expect(subject[0]).to eq 'a_test'

      expect(subject[1].test).to eq 'test'
      expect(subject[1].test1.class).to be Array
      expect(subject[1].test1[1].class).to eq described_class
      expect(subject[1].test1[1].test2).to eq 'test2'
    end
  end
end
