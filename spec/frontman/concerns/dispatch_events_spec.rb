# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'frontman/concerns/dispatch_events'

describe Frontman::DispatchEvents do
  let(:subject) do
    Class.new do
      include Frontman::DispatchEvents
    end.new
  end

  it 'should register events properly' do
    subject.on('test_event', lambda {
      'logic here'
    })

    expect(subject.listeners.length).to eq 1
    expect(subject.listeners['test_event'.to_sym].length).to eq 1
  end

  it 'should register multiple events properly' do
    subject.on('event1, event2', lambda {
      'logic here'
    })

    expect(subject.listeners.length).to eq 2
    expect(subject.listeners['event1'.to_sym].length).to eq 1
    expect(subject.listeners['event2'.to_sym].length).to eq 1
  end

  it 'should fire multiple events at once' do
    first = false
    second = false
    subject.on('event1', lambda {
      first = true
    }).on('event2', lambda {
      second = true
    })

    subject.emit 'event1, event2'

    expect(first).to eq true
    expect(second).to eq true
  end

  it 'should fire events properly and pass parameters when sending events' do
    value = false
    test_value = 'foo'
    subject.on('event', lambda { |parameter|
      value = parameter
    })

    subject.emit 'event', test_value

    expect(value).to eq test_value
  end

  it 'remove event listeners' do
    subject.on('test_event', lambda {
      'logic here'
    })

    subject.off('test_event')

    expect(subject.listeners.length).to eq 1
    expect(subject.listeners['test_event'.to_sym].length).to eq 0
  end
end
