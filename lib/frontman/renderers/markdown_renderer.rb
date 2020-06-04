# typed: false
# frozen_string_literal: true

require 'kramdown'
require 'frontman/renderers/renderer'

module Frontman
  class MarkdownRenderer < Frontman::Renderer
    def compile(layout)
      Kramdown::Document.new(
        layout,
        syntax_highlighter: 'rouge',
        parse_block_html: true,
        fenced_code_blocks: true,
        input: 'GFM',
        with_toc_data: true,
        smartypants: true,
        hard_wrap: false
      )
    end

    def render_content(compiled, _content, _scope, _data)
      compiled.to_html
    end
  end
end
