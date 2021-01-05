# typed: false
# frozen_string_literal: false

require 'haml'
require 'frontman/renderers/renderer'

module Frontman
  class HamlRenderer < Renderer
    def initialize
      Haml::Options.defaults[:format] = :html5
      super
    end

    def compile(layout)
      Haml::Engine.new(layout)
    end

    def render_content(compiled, content, scope, _data)
      compiled.render(scope.get_binding) { content }
    end

    def load_buffer(context)
      haml_locals = context.instance_variable_get(:@_haml_locals)

      haml_locals[:_hamlout].buffer if haml_locals
    end

    def save_buffer(context)
      @buffer = nil
      haml_locals = context.instance_variable_get(:@_haml_locals)

      return unless haml_locals

      @buffer = haml_locals[:_hamlout].buffer
      # empty the buffer so we can capture everything from the new render
      haml_locals[:_hamlout].buffer = ''
      context.instance_variable_set(:@_haml_locals, haml_locals)
    end

    def restore_buffer(context)
      haml_locals = context.instance_variable_get(:@_haml_locals)

      return unless haml_locals

      haml_locals[:_hamlout].buffer = @buffer
      context.instance_variable_set(:@_haml_locals, haml_locals)
      @buffer = nil
    end
  end
end
