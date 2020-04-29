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
  end
end
