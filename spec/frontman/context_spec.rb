# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'frontman/context'
require 'frontman/resource'

describe Frontman::Context do
  subject { Frontman::Context.new }
  let(:resource) { Frontman::Resource.from_path('spec/frontman/mocks/html_file.html') }

  it 'should correctly handle attached methods' do
    subject.singleton_class.send(:define_method, 'testing') { 'value' }
    expect(subject.testing).to eq 'value'
  end

  it 'should correctly respond to attached methods' do
    subject.singleton_class.send(:define_method, 'testing') { 'value' }
    expect(subject.respond_to?('testing')).to eq true
  end

  context 'content' do
    it 'should return nil for unknown content' do
      expect(subject.yield_content('unknown content')).to eq nil
    end

    it 'should return not react to unknown content' do
      expect(subject.content_for?('unknown content')).to eq false
    end

    it 'should return content when it\'s set' do
      Frontman::App.instance.current_page = resource
      subject.content_for('my-key', 'myvalue')
      expect(subject.yield_content('my-key')).to eq 'myvalue'
    end

    it 'should react to known content' do
      Frontman::App.instance.current_page = resource
      subject.content_for('my-key', 'myvalue')
      expect(subject.content_for?('my-key')).to eq true
    end

    it 'should wrap the layout properly' do
      Frontman::Config.set(:layout_dir, 'spec/frontman/mocks/layouts')
      expect(Frontman::Resource.from_path('spec/frontman/mocks/wrap.haml').render).to eq "<h1>This is a test!</h1>\n\n"
    end
  end
end
