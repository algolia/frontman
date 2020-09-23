# typed: false
# frozen_string_literal: false

require 'slim'
require 'frontman/renderers/renderer'

module Frontman
  class SlimRenderer < Renderer
    def initialize
      Slim::Engine.set_options(
        pretty: true,
        buffer: '@_slim_buffer',
        sort_attrs: false,
        disable_escape: true,
      )

      super
    end

    def compile(layout)
      Slim::Template.new do
        layout
      end
    end

    def render_content(compiled, content, scope, _data)
      compiled.render(scope) { content }
    end

    def save_buffers(context)
      slim_buffer = context.instance_variable_get(:@_slim_buffer)

      return unless slim_buffer

      @buffer = slim_buffer
      context.instance_variable_set(:@_slim_buffer, '')
    end

    def restore_buffer(context)
      context.instance_variable_set(:@_slim_buffer, @buffer) if @buffer
      @buffer = nil
    end

    def load_buffer(context)
      context.instance_variable_get(:@_slim_buffer)
    end
  end
end
