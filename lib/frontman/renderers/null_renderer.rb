# typed: false
# frozen_string_literal: true

require 'frontman/renderers/renderer'

module Frontman
  class NullRenderer < Frontman::Renderer
    def compile(layout)
      layout
    end

    def render_content(compiled, _content, _scope, _data)
      compiled
    end
  end
end
