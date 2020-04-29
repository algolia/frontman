# typed: true
# frozen_string_literal: true

require './spec/spec_setup'
require 'lib/frontman/renderers/renderer'

describe Frontman::Renderer do
  it 'should raise an error when we try to compile' do
    expect { Frontman::Renderer.instance.compile('fakelayout') }.to raise_error RuntimeError
  end

  it 'should raise an error when we try to render content' do
    mock = 'fake'
    expect { Frontman::Renderer.instance.render_content(mock, mock, mock, mock) }.to raise_error RuntimeError
  end
end
