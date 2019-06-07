# frozen_string_literal: true

require 'singleton'

module Frontman
  class Config
    include Singleton

    def initialize
      @config = {}
    end

    def set(key, value)
      @config[key.to_sym] = value
    end

    def has?(key)
      @config.key?(key.to_sym)
    end

    def get(key, default = nil)
      has?(key.to_sym) ? @config[key.to_sym] : default
    end

    def all
      @config
    end

    def respond_to_missing?(method_name, _include_private = false)
      has?(method_name.to_sym)
    end

    def method_missing(method_id, *arguments)
      get(method_id.to_sym(*arguments))
    end
  end
end
