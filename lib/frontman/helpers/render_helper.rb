# frozen_string_literal: true
# typed: false

require 'frontman/context'
require 'frontman/renderers/markdown_renderer'
require 'frontman/renderers/erb_renderer'

module RenderHelper
  def render_markdown(content)
    compiled = Frontman::MarkdownRenderer.instance.compile(content)
    Frontman::MarkdownRenderer.instance.render(
      compiled, nil, Frontman::Context.new, {}
    )
  end

  def render_erb(str, template_data = nil)
    return '' if str.nil?

    context = Frontman::Context.new

    if !template_data.nil? && template_data
      template_data.each do |key, value|
        context.singleton_class.send(:define_method, key) { value }
      end
    end

    compiled = Frontman::ErbRenderer.instance.compile(str)
    Frontman::ErbRenderer.instance.render(compiled, nil, context, {})
  end
end