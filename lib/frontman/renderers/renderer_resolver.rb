# frozen_string_literal: false

require 'singleton'
require 'frontman/renderers/erb_renderer'
require 'frontman/renderers/haml_renderer'
require 'frontman/renderers/markdown_renderer'

module Frontman
  class RendererResolver
    include Singleton

    def get_renderer(extension)
      renderers = {
        'erb': Frontman::ErbRenderer.instance,
        'md': Frontman::MarkdownRenderer.instance,
        'haml': Frontman::HamlRenderer.instance
      }

      renderers[extension.to_sym]
    end
  end
end
