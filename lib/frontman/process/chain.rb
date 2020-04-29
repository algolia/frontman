# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'

module Frontman
  module Process
    class Chain
      extend T::Sig

      sig do
        params(
          processors: T::Array[Frontman::Process::Processor]
        ).returns(T.self_type)
      end
      def initialize(processors = [])
        @processors = []

        add_processors(processors)
      end

      sig do
        params(
          processors: T.any(
            Frontman::Process::Processor,
            T::Array[Frontman::Process::Processor]
          )
        ).returns(T.self_type)
      end
      def add_processors(processors)
        @processors.push(*Array(processors))
        self
      end

      sig { params(arguments: T.untyped).returns(T::Array[T.untyped]) }
      def process(*arguments)
        @processors.map do |processor|
          processor.process(*arguments)
        end
      end
    end
  end
end
