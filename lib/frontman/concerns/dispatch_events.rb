# typed: true
# frozen_string_literal: true

module Frontman
  module DispatchEvents
    def listeners
      @listeners ||= {}
    end

    def on(events, callback)
      list(events).each do |event_name|
        listeners[event_name.to_sym] = listeners[event_name.to_sym] || []
        listeners[event_name.to_sym].push(callback)
      end

      self
    end

    def emit(events, *arguments)
      list(events).each do |event_name|
        event_listeners = listeners[event_name.to_sym] || []
        event_listeners.each do |listener|
          listener.call(*arguments)
        end
      end

      self
    end

    def off(events)
      list(events).each do |event_name|
        listeners[event_name.to_sym] = []
      end

      self
    end

    private

    def list(events)
      events.to_s.split(',').map(&:strip)
    end
  end
end
