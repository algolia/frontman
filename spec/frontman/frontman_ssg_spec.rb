# frozen_string_literal: true

require './spec/spec_setup'
require './lib/frontman'

describe Frontman do
  it 'should output Hello World' do
    expect { Frontman.hi }.to output('Hello world!').to_stdout
  end
end
