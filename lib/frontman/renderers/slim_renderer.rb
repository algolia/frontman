# typed: false
# frozen_string_literal: true

#require 'slim'
require 'frontman/renderers/renderer'

module Frontman
  class SlimRenderer < Renderer
    def initialize
      Slim::Engine.disable_option_validator!
      Slim::Engine.set_options(
        buffer: '@_slim_buffer',
        use_html_safe: true,
        #generator: ::Temple::Generators::RailsOutputBuffer,
        disable_escape: true
      )

      super
    end

    def compile(layout)
      Slim::Template.new(layout)
    end

    def render_content(compiled, content, scope, _data)
      compiled.render(scope) { content }
    end
  end
end
