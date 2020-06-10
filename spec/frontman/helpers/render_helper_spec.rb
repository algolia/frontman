# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'lib/frontman/helpers/render_helper'
require 'lib/frontman/config'
require 'lib/frontman/resource'

describe RenderHelper do
  subject do
    Class.new do
      include RenderHelper
    end.new
  end

  context 'templating languages' do
    it 'should render markdown' do
      markdown = '# Hello world!'
      html = "<h1 id=\"hello-world\">Hello world!</h1>\n"
      expect(subject.render_markdown(markdown)).to eq html
    end

    it 'should render ERB' do
      erb = '<h1><%= "Hello" %> <%= "wor" + "ld" %>!</h1>'
      html = '<h1>Hello world!</h1>'
      expect(subject.render_erb(erb)).to eq html
    end
  end

  context 'partials' do
    it 'should throw an error for a non existing partial' do
      expect { subject.partial('fake_partial') }.to raise_error RuntimeError
    end

    it 'should render an existing partial' do
      Frontman::Config.set(:partial_dir, 'spec/frontman/mocks/partials')

      expect(subject.partial('paragraph.haml', text: 'Testing'))
        .to eq("<p>\nThe passed text: Testing\n</p>\n")
    end
  end

  context 'render page' do
    let(:resource) { Frontman::Resource.from_path('spec/frontman/mocks/html_file.html') }

    it 'should render the current page' do
      Frontman::App.instance.current_page = resource
      expect(subject.render_current_page).to eq resource.render(nil, layout: nil, ignore_page: nil)
    end

    it 'should render a page' do
      expect(subject.render_page(resource)).to eq resource.render(nil, layout: nil, ignore_page: nil)
    end
  end



end
