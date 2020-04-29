# frozen_string_literal: false

require 'erubis'
require 'singleton'
require 'frontman/renderers/renderer'

module Frontman
  class ErbRenderer < Frontman::Renderer
    def compile(layout)
      Erubis::Eruby.new(layout, bufvar: '@_erbout')
    end

    def render_content(compiled, content, scope, data)
      data.each do |key, value|
        scope.singleton_class.send(:define_method, key) { value }
      end

      compiled.result(scope.get_binding { content })
    end
  end
end
