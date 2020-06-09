# typed: true
# frozen_string_literal: true

require 'frontman/config'
require 'frontman/context'
require 'frontman/renderers/markdown_renderer'
require 'frontman/renderers/erb_renderer'
require 'frontman/resource'
require 'sorbet-runtime'

module RenderHelper
  extend T::Sig

  sig do
    params(template: String, data: T.any(Hash, CustomStruct))
      .returns(String)
  end
  def partial(template, data = {})
    partial_dir = Frontman::Config.get(
      :partial_dir, fallback: 'views/partials'
    )
    r = Frontman::Resource.from_path(
      File.join(partial_dir, template), nil, false
    )
    r.render(nil, data)
  end

  sig do
    params(
      page: Frontman::Resource, options: T.any(Hash, CustomStruct)
    ).returns(String)
  end
  def render_page(page, options = {})
    # We force not to render any layout
    options[:layout] = nil
    options[:ignore_page] = true

    # We don't need to cache here since it already done in the render function
    # of the resource
    page.render(nil, options)
  end

  sig do
    params(options: T.any(Hash, CustomStruct)).returns(String)
  end
  def render_current_page(options = {})
    render_page(Frontman::App.instance.current_page, options)
  end

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
