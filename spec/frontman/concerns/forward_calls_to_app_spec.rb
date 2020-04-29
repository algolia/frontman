# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'frontman/app'
require 'frontman/concerns/forward_calls_to_app'

describe Frontman::ForwardCallsToApp do
  let(:subject) do
    Class.new do
      include Frontman::ForwardCallsToApp
    end.new
  end

  it 'should forward missing method calls to App' do
    app = Frontman::App.instance
    expect(app).to receive(:non_existent_method)

    subject.non_existent_method
  end
end
