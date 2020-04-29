# frozen_string_literal: false

require 'singleton'

module Frontman
  class Renderer
    include Singleton

    def compile(_layout)
      raise('Should be implemented in child classes')
    end

    def render(compiled, content, scope, data)
      Frontman::App.instance.view_data.push(data)
      content = render_content(compiled, content, scope, data)
      Frontman::App.instance.view_data.pop

      content
    end

    def render_content(_compiled, _content, _scope, _data)
      raise('Should be implemented in child classes')
    end
  end
end
