# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'frontman/builder/builder'
require 'frontman/resource'

describe Frontman::Builder::Builder do
  subject { Frontman::Builder::Builder.new }

  context 'build directory' do
    it 'should default to build folder in root' do
      expect(subject.build_directory).to eq Dir.pwd + '/build/'
    end

    it 'should override the build directory' do
      directory = Dir.pwd + '/fake-build/'
      expect(subject.build_directory).to eq Dir.pwd + '/build/'
      subject.build_directory = directory
      expect(subject.build_directory).to eq directory
    end
  end

  context 'building' do
    subject do
      builder = Frontman::Builder::Builder.new
      builder.build_directory = Dir.pwd + '/spec/frontman/build/'
      builder
    end

    it 'should properly build a redirect' do
      # TODO
    end

    it 'should build from an ERB file' do
      subject.build_from_erb('spec/frontman/mocks/html_file.html.md.erb', 'spec/frontman/mocks/html_file.html.md.erb')
      path = subject.build_directory + '/spec/frontman/mocks/html_file/index.html'

      expect(File.exist?(path)).to eq true
      expect(File.read(path).include?('testing erb')).to eq true # This text will be rendered by ERB
    end

    it 'should build from an asset' do
      subject.build_from_asset('spec/frontman/mocks/asset.css', 'spec/frontman/mocks/asset.css')
      path = subject.build_directory + '/spec/frontman/mocks/asset.css'

      expect(File.exist?(path)).to eq true
    end

    it 'should not rebuild an existing file' do
      file_path = subject.build_directory + 'spec/frontman/mocks/asset.css'
      current_mtime = File.mtime(file_path)
      subject.current_build_files = Dir.glob(Dir.pwd + '/spec/frontman/build/**/*').reject { |f| File.directory? f }
      subject.build_from_asset('spec/frontman/mocks/asset.css', 'spec/frontman/mocks/asset.css')

      expect(File.mtime(file_path)).to eq current_mtime
    end

    it 'should build from resource' do
      subject.build_resource(Frontman::Resource.from_path('spec/frontman/mocks/test.html'))
      path = subject.build_directory + '/spec/frontman/mocks/test/index.html'
      expect(File.exist?(path)).to eq true
    end

    it 'should skip rebuilding from resource' do
      resource = Frontman::Resource.from_path('spec/frontman/mocks/test.html')
      path = subject.build_directory + 'spec/frontman/mocks/test/index.html'
      subject.current_build_files = [path]

      current_mtime = File.mtime(path)
      subject.build_resource(resource)
      expect(File.mtime(path)).to eq current_mtime
    end

    it 'should delete files properly' do
      # TODO
    end
  end
end
