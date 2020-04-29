# typed: true
# frozen_string_literal: true

require './spec/spec_setup'
require 'lib/frontman/renderers/markdown_renderer'

describe Frontman::MarkdownRenderer do
  it 'should render Markdown correctly' do
    compiled = Frontman::MarkdownRenderer.instance.compile('# Hello!')
    expect(Frontman::MarkdownRenderer.instance.render_content(compiled, nil, nil, {})).to eq "<h1 id=\"hello\">Hello!</h1>\n"
  end
end
