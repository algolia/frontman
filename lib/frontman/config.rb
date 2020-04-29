# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'

module Frontman
  class Config
    class << self
      extend T::Sig

      sig do
        params(
          key: T.any(String, Symbol), value: T.untyped
        ).returns(T.self_type)
      end
      def set(key, value)
        @@values ||= {}
        @@values[key.to_sym] = value
        self
      end

      sig do
        params(
          key: T.any(String, Symbol), fallback: T.untyped
        ).returns(T.untyped)
      end
      def get(key, fallback: nil)
        @@values ||= {}
        @@values.key?(key.to_sym) ? @@values[key.to_sym] : fallback
      end

      sig { params(key: T.any(String, Symbol)).returns(T.self_type) }
      def delete(key)
        @@values ||= {}
        @@values.delete(key)
        self
      end

      sig { params(key: T.any(String, Symbol)).returns(T::Boolean) }
      def has?(key)
        @@values ||= {}
        @@values.key?(key.to_sym)
      end

      sig { returns(Hash) }
      def all
        @@values ||= {}
        @@values
      end
    end
  end
end
