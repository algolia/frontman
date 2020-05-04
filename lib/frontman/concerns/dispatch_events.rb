# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'

module Frontman
  module DispatchEvents
    extend T::Sig

    sig { returns(T::Hash[Symbol, T::Array[T.untyped]]) }
    def listeners
      @listeners ||= {}
    end

    sig do
      params(events: T.any(Symbol, String), callback: T.untyped)
        .returns(T.self_type)
    end
    def on(events, callback)
      list(events).each do |event_name|
        listeners[event_name.to_sym] ||= []
        T.must(listeners[event_name.to_sym]).push(callback)
      end

      self
    end

    # We don't annotate with sig because of bad support for splat arguments
    def emit(events, *arguments)
      list(events).each do |event_name|
        event_listeners = listeners[event_name.to_sym] || []
        event_listeners.each do |listener|
          listener.call(*arguments)
        end
      end

      self
    end

    sig { params(events: T.any(Symbol, String)).returns(T.self_type) }
    def off(events)
      list(events).each do |event_name|
        listeners[event_name.to_sym] = []
      end

      self
    end

    private

    sig { params(events: T.any(Symbol, String)).returns(T::Array[String]) }
    def list(events)
      events.to_s.split(',').map(&:strip)
    end
  end
end
