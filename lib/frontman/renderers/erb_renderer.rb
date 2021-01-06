# typed: false
# frozen_string_literal: false

require 'erubis'
require 'frontman/renderers/renderer'

module Frontman
  class ErbRenderer < Frontman::Renderer
    def initialize
      @buffer = {}
      super
    end

    def compile(layout)
      Erubis::Eruby.new(layout, bufvar: '@_erbout')
    end

    def render_content(compiled, content, scope, data)
      data.each do |key, value|
        scope.singleton_class.send(:define_method, key) { value }
      end

      compiled.result(scope.get_binding { content })
    end

    def save_buffer(context)
      buffer = context.instance_variable_get(:@_erbout)

      return unless buffer

      @buffer[context.buffer_hash] = buffer
      context.instance_variable_set(:@_erbout, '')
    end

    def restore_buffer(context)
      return unless @buffer[context.buffer_hash]

      context.instance_variable_set(:@_erbout, @buffer[context.buffer_hash])
      @buffer.delete(context.buffer_hash)
    end

    def load_buffer(context)
      context.instance_variable_get(:@_erbout)
    end
  end
end
