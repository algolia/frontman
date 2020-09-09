# typed: true
# frozen_string_literal: true

require 'frontman/renderers/renderer'
require 'frontman/renderers/erb_renderer'
require 'frontman/renderers/haml_renderer'
require 'frontman/renderers/slim_renderer'
require 'frontman/renderers/markdown_renderer'
require 'singleton'
require 'sorbet-runtime'

module Frontman
  class RendererResolver
    extend T::Sig
    include Singleton

    sig { params(extension: String).returns(T.nilable(Frontman::Renderer)) }
    def get_renderer(extension)
      renderers = {
        :erb => Frontman::ErbRenderer.instance,
        :md => Frontman::MarkdownRenderer.instance,
        :haml => Frontman::HamlRenderer.instance,
        :slim =>Frontman::SlimRenderer.instance,
      }

      renderers[extension.to_sym]
    end

    VALID_EXTENSIONS = %w[erb html haml slim md txt]

  end
end
