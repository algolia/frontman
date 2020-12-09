# typed: false
# frozen_string_literal: true

require 'parallel'

module Frontman
  class Iterator
    class << self
      def map(collection, *options, &block)
        forward(:map, collection, *options, &block)
      end

      def each(collection, *options, &block)
        forward(:each, collection, *options, &block)
      end

      def map_with_index(collection, *options, &block)
        forward(:map_with_index, collection, *options, &block)
      end

      def each_with_index(collection, *options, &block)
        forward(:each_with_index, collection, *options, &block)
      end

      def processor_count
        return Parallel.processor_count if parallel?

        Frontman::Config.get(:processor_count, fallback: 1)
      end

      private

      def parallel?
        Frontman::Config.get(:parallel, fallback: true)
      end

      def forward(method, collection, *options, &block)
        return ::Parallel.public_send(method, collection, *options, &block) if parallel?

        collection.public_send(method, &block)
      end
    end
  end
end
