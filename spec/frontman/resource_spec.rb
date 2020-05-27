# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'lib/frontman/resource'

describe Frontman::Resource do
  it 'should throw an error when creating a Frontman::Resource from a non-existing file' do
    expect { Frontman::Resource.from_path('non-existing-file') }.to raise_error RuntimeError
  end

  it 'should load the Frontman::Resource' do
    expect(Frontman::Resource.from_path('spec/frontman/mocks/html_file.html').class.name).to eq 'Frontman::Resource'
  end

  it 'should cache the Frontman::Resource' do
    Frontman::Resource.from_path('spec/frontman/mocks/html_file.html')
    expect(Frontman::Resource.resources['spec/frontman/mocks/html_file.html'.gsub(%r{^/}, '')].class.name).to eq 'Frontman::Resource'
  end

  it 'should generate Frontman::Resources with different destinations and the same source file' do
    Frontman::Resource.from_path('spec/frontman/mocks/html_file.html')
    Frontman::Resource.from_path('spec/frontman/mocks/html_file.html', 'testing/bar.html')
    expect(Frontman::Resource.resources['spec/frontman/mocks/html_file.html'.gsub(%r{^/}, '')].class.name).to eq 'Frontman::Resource'
    expect(Frontman::Resource.resources['testing/bar.html'.gsub(%r{^/}, '')].class.name).to eq 'Frontman::Resource'
  end

  subject { Frontman::Resource.from_path('spec/frontman/mocks/html_file.md.html') }
  context 'parse_resource' do
    it 'should reset the view data' do
      subject.data = { foo: 'bar' }.to_ostruct
      expect(subject.data.length).to eq 1
      subject.parse_resource
      expect(subject.data.length).to eq 0
    end

    it 'should append passed data' do
      subject.data = { foo: 'bar' }.to_ostruct
      expect(subject.data.length).to eq 1
      subject.parse_resource(false, foo: 'bar')
      expect(subject.data.length).to eq 1
    end

    it 'should mark the Frontman::Resource as indexable when not set' do
      expect(subject.indexable?).to eq true
    end

    it 'should mark the Frontman::Resource as not indexable when set to false' do
      subject.data = { indexable: false }.to_ostruct

      expect(subject.indexable?).to eq false
    end

    it 'should mark the Frontman::Resource as indexable when explicitly set to true' do
      subject.data = { indexable: true }.to_ostruct

      expect(subject.indexable?).to eq true
    end

    it 'should compile the view when it has just one renderer' do
      subject.parse_resource
      expect(subject.renderers.length).to eq 1
      expect(subject.compiled.class.name).to eq 'Kramdown::Document'
    end

    let(:multiRenderer) { Frontman::Resource.from_path('spec/frontman/mocks/html_file.html.md.erb') }

    it 'should not compile when it has multiple renderers' do
      multiRenderer.parse_resource
      expect(multiRenderer.renderers.length).to eq 2
      expect(multiRenderer.compiled.class.name).to eq 'NilClass'
    end
  end

  it 'should find the correct layout' do
    Frontman::App.instance.register_layout('spec/frontman/*', 'correct_layout')
    expect(subject.layout).to eq 'correct_layout'
  end

  it 'should split extensions correctly' do
    expect(subject.strip_extensions('testing/file.foo.bar.baz')).to eq ['testing/file', %w[foo bar baz]]
  end

  it 'should parse an existing snippet file' do
    resource = Frontman::Resource.from_path('spec/frontman/mocks/snippet/html_file.html')
    resource.parse_data_file
    expect(resource.data.guide_snippet.length).to eq 2
  end

  it 'should have a modified-time' do
    expect(subject.mtime).to be > Time.new(2019, 0o1, 0o1)
  end

  context 'Strip Extensions' do
    it 'should properly strip extensions from paths with no extensions' do
      path, extensions = subject.strip_extensions('fake/file/path')
      expect(path).to eq 'fake/file/path'
      expect(extensions.length).to eq 0
    end

    it 'should properly strip extensions from paths with one extension' do
      path, extensions = subject.strip_extensions('fake/file/path.mock')
      expect(path).to eq 'fake/file/path'
      expect(extensions).to eq %w[mock]
    end

    it 'should properly strip extensions from paths with multiple extensions' do
      path, extensions = subject.strip_extensions('fake/file/path.mock.foo.bar')
      expect(path).to eq 'fake/file/path'
      expect(extensions).to eq %w[mock foo bar]
    end

    it 'should not strip the extension if part of the path has a dot in it' do
      path, extensions = subject.strip_extensions('fake/file/dot.net/path.mock.foo.bar')
      expect(path).to eq 'fake/file/dot.net/path'
      expect(extensions).to eq %w[mock foo bar]
    end
  end

  context 'Setup Destination' do
    it 'should set the right destination extension' do
      subject.destination_path = 'path/to/file.html.md.erb'
      subject.setup_destination
      expect(subject.extension).to eq 'html'
    end

    it 'should find the right destination path for HTML files' do
      subject.destination_path = 'path/to/file.html.md.erb'
      subject.setup_destination
      expect(subject.destination_path).to eq 'path/to/file/index.html'
    end

    it 'should find the right destination path for non-HTML files' do
      subject.destination_path = 'path/to/file.md.erb'
      subject.setup_destination
      expect(subject.destination_path).to eq 'path/to/file.md'
    end

    it 'should find the right destination path without extension' do
      subject.destination_path = 'path/to/file'
      subject.setup_destination
      expect(subject.destination_path).to eq 'path/to/file/index.html'
    end

    it 'should find the right destination path without extension' do
      subject.destination_path = 'file.html.haml'
      subject.setup_destination
      expect(subject.destination_path).to eq 'file/index.html'
    end
  end
end
