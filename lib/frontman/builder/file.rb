# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'

module Frontman
  module Builder
    class File
      extend T::Sig

      attr_accessor :path, :status

      sig { params(path: String, status: T.any(String, Symbol)).void }
      def initialize(path, status)
        raise "#{status} is not a valid file status!" unless valid_status?(status)

        @path = path
        @status = status.to_sym
      end

      class << self
        extend T::Sig

        sig { params(path: String).returns(Frontman::Builder::File) }
        def unchanged(path)
          new(path, :unchanged)
        end

        sig { params(path: String).returns(Frontman::Builder::File) }
        def deleted(path)
          new(path, :deleted)
        end

        sig { params(path: String).returns(Frontman::Builder::File) }
        def created(path)
          new(path, :created)
        end

        sig { params(path: String).returns(Frontman::Builder::File) }
        def updated(path)
          new(path, :updated)
        end
      end

      private

      sig { params(status: T.any(String, Symbol)).returns(T::Boolean) }
      def valid_status?(status)
        %i[updated deleted created unchanged].include?(status.to_sym)
      end
    end
  end
end
