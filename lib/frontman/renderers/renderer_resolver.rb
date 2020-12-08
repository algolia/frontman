# typed: true
# frozen_string_literal: true

require 'frontman/renderers/renderer'
require 'frontman/renderers/erb_renderer'
require 'frontman/renderers/haml_renderer'
require 'frontman/renderers/null_renderer'
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
      all_renderers[extension.to_sym]
    end

    sig { returns(T::Hash[Symbol, Frontman::Renderer]) }
    def all_renderers
      @all_renderers ||= {
        erb: Frontman::ErbRenderer.instance,
        md: Frontman::MarkdownRenderer.instance,
        haml: Frontman::HamlRenderer.instance,
        slim: Frontman::SlimRenderer.instance,
        html: Frontman::NullRenderer.instance,
        txt: Frontman::NullRenderer.instance
      }
    end

    sig { params(extension: String).returns(T::Boolean) }
    def valid_extension?(extension)
      all_renderers.keys.include?(extension.to_sym)
    end

  end
end
