# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'

module Frontman
  module Toolbox
    class Timer
      extend T::Sig

      sig { returns(Frontman::Toolbox::Timer) }
      def self.start
        timer = new
        timer.begin
        timer
      end

      sig { returns(Time) }
      def begin
        @start = Time.now
      end

      sig { returns(Time) }
      def stop
        @end = Time.now
      end

      sig { returns(Float) }
      def diff
        @end - @start
      end

      sig { returns(T.nilable(Time)) }
      def started_at
        @start
      end

      sig { returns(T.nilable(Time)) }
      def ended_at
        @end
      end

      sig { returns(String) }
      def output
        "Elapsed time: #{diff * 1000} milliseconds.\n"
      end
    end
  end
end
