# typed: true
# frozen_string_literal: true

module Frontman
  module Builder
    class File
      attr_accessor :path, :status

      def initialize(path, status)
        unless valid_status?(status)
          # TODO: custom error
          raise "#{status} is not a valid file status!"
        end

        @path = path
        @status = status.to_sym
      end

      def valid_status?(status)
        %i[updated deleted created unchanged].include?(status.to_sym)
      end

      def self.unchanged(path)
        new(path, :unchanged)
      end

      def self.deleted(path)
        new(path, :deleted)
      end

      def self.created(path)
        new(path, :created)
      end

      def self.updated(path)
        new(path, :updated)
      end
    end
  end
end
