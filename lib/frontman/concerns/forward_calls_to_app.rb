# typed: true
# frozen_string_literal: true

module Frontman
  module ForwardCallsToApp
    def self.included(klass)
      klass.extend Frontman::ForwardCallsToApp::ClassMethods
    end

    def method_missing(method_id, *arguments, &block)
      Frontman::App.instance.public_send(method_id, *arguments, &block)
    end

    def respond_to_missing?(method_name)
      Frontman::App.instance.respond_to?(method_name)
    end

    module ClassMethods
      def method_missing(method_id, *arguments, &block)
        Frontman::App.instance.public_send(method_id, *arguments, &block)
      end

      def respond_to_missing?(method_name)
        Frontman::App.instance.respond_to?(method_name)
      end
    end
  end
end
