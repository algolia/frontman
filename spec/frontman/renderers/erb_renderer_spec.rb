# typed: true
# frozen_string_literal: true

require './spec/spec_setup'
require 'lib/frontman/renderers/erb_renderer'

describe Frontman::ErbRenderer do
  it 'should render ERB correctly' do
    compiled = Frontman::ErbRenderer.instance.compile("t<%= 'es' %>t")
    expect(Frontman::ErbRenderer.instance.render_content(compiled, nil, Frontman::Context.new, {})).to eq 'test'
  end

  it 'should throw an error with incorrect ERB syntax' do
    compiled = Frontman::ErbRenderer.instance.compile('t<%= |! %> t')
    expect { Frontman::ErbRenderer.instance.render_content(compiled, nil, Frontman::Context.new, {}) }.to raise_error SyntaxError
  end

  it 'should send the data to the view' do
    compiled = Frontman::ErbRenderer.instance.compile('t<%= string %>t')
    expect(Frontman::ErbRenderer.instance.render_content(compiled, nil, Frontman::Context.new, string: 'es')).to eq 'test'
  end
end
