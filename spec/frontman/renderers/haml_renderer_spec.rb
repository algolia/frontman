# typed: true
# frozen_string_literal: true

require './spec/spec_setup'
require 'lib/frontman/renderers/haml_renderer'

describe Frontman::HamlRenderer do
  it 'should render HAML correctly' do
    compiled = Frontman::HamlRenderer.instance.compile('%h1#hello Hello!')
    expect(Frontman::HamlRenderer.instance.render_content(compiled, nil, Frontman::Context.new, {})).to eq "<h1 id='hello'>Hello!</h1>\n"
  end
end
