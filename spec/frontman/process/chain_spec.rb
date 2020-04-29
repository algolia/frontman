# typed: false
# frozen_string_literal: false

require './spec/spec_setup'
require 'frontman/process/chain'
require 'frontman/process/processor'

describe Frontman::Process::Chain do
  it 'should not manipulate data when there are no processors' do
    data = 'foobar'
    subject.process(data)

    expect(data).to eq 'foobar'
  end

  it 'should pass data through all processors' do
    subject.add_processors([processor_factory(lambda { |string|
      string << 'CASE'
    }), processor_factory(lambda { |string|
      string.downcase!
    })])

    data = 'down'
    subject.process(data)
    expect(data).to eq 'downcase'
  end

  it 'should map over all processors and return the proper result' do
    subject.add_processors(
      [
        processor_factory(->(_) { 'foo' }),
        processor_factory(->(_) { 'bar' })
      ]
    )

    expect(subject.process(nil)).to eq %w[foo bar]
  end
end

class Processor < Frontman::Process::Processor
  attr_accessor :callback

  def on_process(callback)
    @callback = callback
  end

  def process(data)
    @callback.call(data)
  end
end

def processor_factory(on_process)
  processor = Processor.new
  processor.on_process(on_process)
  processor
end
