# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'lib/frontman/renderers/slim_renderer'

describe Frontman::SlimRenderer do
  it 'should render Slim correctly' do
    compiled = Frontman::SlimRenderer.instance.compile('h1#hello Hello!')
    expect(Frontman::SlimRenderer.instance.render_content(compiled, nil, Frontman::Context.new, {})).to eq "<h1 id=\"hello\">\n  Hello!\n</h1>"
  end
end
