# typed: false
# frozen_string_literal: true

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
  end
end
