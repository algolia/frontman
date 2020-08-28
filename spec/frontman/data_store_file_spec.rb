# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'lib/frontman/data_store_file'
require 'lib/frontman/data_store'

describe Frontman::DataStoreFile do
  subject do
    data = Frontman::DataStore.new("#{__dir__}/mocks")
    data.info
  end

  describe '#to_ostruct' do
    it 'does not convert to custom struct' do
      expect(subject.to_ostruct.is_a?(Frontman::DataStoreFile)).to eq true
    end
  end
end
