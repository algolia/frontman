# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'lib/frontman/app'
require 'lib/frontman/sitemap_tree'

describe Frontman::App do
  subject { Frontman::App.instance }

  context 'Helpers' do
    it 'should register helpers correctly' do
      # TODO: make test
    end

    it 'should throw an error when registering a missing helpers' do
      expect do
        subject.register_helpers(
          [
            { path: File.join(Dir.pwd, 'helpers/MissingHelper.rb'), name: 'MissingHelper' }
          ]
        )
      end.to raise_error LoadError
    end
  end

  context 'Redirects' do
    it 'should store redirects' do
      subject.add_redirect('/foo', '/bar')
      expect(subject.redirects['/foo']).to eq '/bar'
    end
  end

  context 'manifest' do
    it 'should prepend with a slash if needed' do
      expect(subject.add_to_manifest('key', 'foo/bar')).to eq '/foo/bar'
      expect(subject.add_to_manifest('key', '/bar/foo')).to eq '/bar/foo'
    end
  end

  it 'should return a sitemap_tree' do
    expect(subject.sitemap_tree.is_a?(Frontman::SitemapTree)).to eq true
  end

  it 'should return itself when calling app' do
    expect(subject.app).to eq subject
  end
end
