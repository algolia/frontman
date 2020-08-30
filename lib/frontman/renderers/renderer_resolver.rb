# typed: true
# frozen_string_literal: true

require 'frontman/renderers/erb_renderer'
require 'frontman/renderers/haml_renderer'
require 'frontman/renderers/markdown_renderer'
require 'singleton'
require 'sorbet-runtime'

begin
  require "slim"
  require 'frontman/renderers/slim_renderer'
rescue
  raise "asd"
  # Do nothing
end

module Frontman
  class RendererResolver
    extend T::Sig
    include Singleton

    sig { params(extension: String).returns(T.nilable(Frontman::Renderer)) }
    def get_renderer(extension)
      renderers = {
        'erb': Frontman::ErbRenderer.instance,
        'md': Frontman::MarkdownRenderer.instance,
        'haml': Frontman::HamlRenderer.instance,
      }

      if defined?(Slim)
        renderers['slim'] = Frontman::SlimRenderer.instance
      end

      renderers[extension.to_sym]
    end
  end
end
