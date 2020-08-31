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
      key = 'unknown content'

      expect(subject.content_for?(key)).to eq false
    end

    it 'should react to known content' do
      Frontman::App.instance.current_page = resource
      key = 'my-key'
      subject.content_for(key, 'myvalue')
      expect(subject.content_for?(key)).to eq true
    end

    it 'should return content when it\'s set' do
      Frontman::App.instance.current_page = resource
      key = 'my-key'

      subject.content_for(key, 'myvalue')
      expect(subject.yield_content(key)).to eq 'myvalue'

      subject.append_content(key, ',othervalue')
      expect(subject.yield_content(key)).to eq 'myvalue,othervalue'

      key = 'new-key'
      subject.append_content(key, 'test')
      expect(subject.yield_content(key)).to eq 'test'
    end

    it 'should accept a block' do
      Frontman::App.instance.current_page = resource
      key = 'my-key'

      subject.content_for(key) do
        'myvalue'
      end

      subject.append_content(key) do
        ',othervalue'
      end

      subject.content_for(key, '')

      subject.content_for(key, 'foobar') do
        'myvalue'
      end

      subject.append_content(key, ',foobar') do
        ',othervalue'
      end
    end

    it 'should render correctly' do
      expect(Frontman::Resource.from_path('spec/frontman/mocks/context.haml').render).to eq "<h1>123\n</h1>\n<p>456\n</p>\n"
    end

    it 'should wrap the layout properly' do
      Frontman::Config.set(:layout_dir, 'spec/frontman/mocks/layouts')
      expect(Frontman::Resource.from_path('spec/frontman/mocks/wrap.haml').render).to eq "<h1>This is a test!</h1>\n\n"
    end
  end
end
