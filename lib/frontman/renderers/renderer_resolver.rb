# typed: true
# frozen_string_literal: true

require 'frontman/renderers/renderer'
require 'frontman/renderers/erb_renderer'
require 'frontman/renderers/haml_renderer'
require 'frontman/renderers/markdown_renderer'
require 'singleton'
require 'sorbet-runtime'

if (require("slim") rescue nil)
  require 'frontman/renderers/slim_renderer'
end

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
      }

      if VALID_EXTENSIONS.include?("slim")
        renderers[:slim] = Frontman::SlimRenderer.instance
      end

      renderers[extension.to_sym]
    end

    VALID_EXTENSIONS = %w[erb html haml md txt]

    if defined?(Slim)
      VALID_EXTENSIONS << "slim"
    end

  end
end
