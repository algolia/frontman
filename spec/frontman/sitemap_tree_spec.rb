# typed: true
# frozen_string_literal: true

require './spec/spec_setup'
require 'lib/frontman/sitemap_tree'

describe Frontman::SitemapTree do
  context 'building SitemapTree' do
    before(:each) do
      Frontman::SitemapTree.class_variable_set :@@urls, {}
      @sitemap_tree = Frontman::SitemapTree.new(nil)
    end

    it 'should add resources to the tree' do
      @sitemap_tree.add({ destination_path: 'doc/test/test1.html' }.to_ostruct)
      @sitemap_tree.add({ destination_path: 'doc/test/test2/test22.html' }.to_ostruct)
      @sitemap_tree.add({ destination_path: 'doc/test/test2/test13.html' }.to_ostruct)

      expect(@sitemap_tree.flatten.size).to eq 3
    end

    it 'should not add js and css resources' do
      @sitemap_tree.add({ destination_path: 'doc/test/test1.js' }.to_ostruct)
      @sitemap_tree.add({ destination_path: 'doc/test/test2/test22.css' }.to_ostruct)

      expect(@sitemap_tree.flatten.size).to eq 0
    end

    it 'should find dir' do
      @sitemap_tree.add({ destination_path: 'doc/test/test1.html' }.to_ostruct)
      @sitemap_tree.add({ destination_path: 'doc/test/test2/test22.html' }.to_ostruct)
      @sitemap_tree.add({ destination_path: 'doc/test/test2/test13.html' }.to_ostruct)

      expect(@sitemap_tree.find(['doc']).class).to eq Frontman::SitemapTree
      expect(@sitemap_tree.find(%w[doc test test2]).class).to eq Frontman::SitemapTree
    end

    it 'should load @sitemap_tree from url, partial urls and resource' do
      @sitemap_tree.add({ destination_path: 'doc/test/test1.html' }.to_ostruct)
      @sitemap_tree.add({ destination_path: 'doc/test/test2/test22.html' }.to_ostruct)
      @sitemap_tree.add({ destination_path: 'doc/test/test2/test13.html' }.to_ostruct)

      expect(@sitemap_tree.from_url('doc/test').class).to eq described_class
      expect(@sitemap_tree.from_url('doc/test/test1').class).to eq described_class
      expect(@sitemap_tree.from_resource({ destination_path: 'doc/test/test1.html' }.to_ostruct).class).to eq described_class
    end

    it 'should access parent, children, sibling, ancestors' do
      @sitemap_tree.add({ destination_path: 'doc/test/test1.html' }.to_ostruct)
      @sitemap_tree.add({ destination_path: 'doc/test/test2/test22.html' }.to_ostruct)
      @sitemap_tree.add({ destination_path: 'doc/test/test2/test13.html' }.to_ostruct)

      tree = @sitemap_tree.from_url('doc/test/test2')

      expect(tree.parent.parent.url_part).to eq 'doc'
      expect(tree.children.size).to eq 2
      expect(tree.children[0].siblings.size).to eq 2
      expect(tree.children[0].siblings[0].url_part).to eq 'test22'
      expect(tree.ancestor('doc').url_part).to eq 'doc'
      expect(tree.ancestor('doc', 1).url_part).to eq 'test'
    end

    it 'should get the final url with a / at the beginning and end' do
      @sitemap_tree.add({ destination_path: 'doc/test/test1.html' }.to_ostruct)

      tree = @sitemap_tree.from_url('doc/test/test1')

      expect(tree.final_url).to eq '/doc/test/test1/'
    end

    it 'should proxy resources to a given url' do
      @sitemap_tree.add({ destination_path: 'doc/test/test1.html' }.to_ostruct)
      @sitemap_tree.add_proxy('foo/bar.html', 'spec/frontman/mocks/html_file.html')
      tree = @sitemap_tree.from_url('/foo/bar')
      expect(tree.class).to eq described_class
      expect(tree.resource).to be_a Frontman::Resource
    end

    it 'should get all the pages both nested and not nested' do
      @sitemap_tree.add({ destination_path: 'doc/test/test1.html' }.to_ostruct)
      @sitemap_tree.add({ destination_path: 'doc/test/test2/test22.html' }.to_ostruct)
      @sitemap_tree.add({ destination_path: 'doc/test/test2/test13.html' }.to_ostruct)

      expect(@sitemap_tree.get_all_pages.flatten.length).to eq 3

      tree = @sitemap_tree.from_url('doc/test/test2')
      expect(tree.get_all_pages.flatten.length).to eq 2
    end

    it 'should properly set and get the value' do
      value = 'testing'
      @sitemap_tree.resource = value

      expect(@sitemap_tree.resource).to eq value
    end

    it 'should identify folders' do
      @sitemap_tree.add({ destination_path: 'doc/test/test2/test22.html' }.to_ostruct)
      @sitemap_tree.add({ destination_path: 'doc/test/test2/test13.html' }.to_ostruct)

      tree = @sitemap_tree.from_url('doc/test/test2')
      expect(tree.folder?).to eq true
    end

    it 'should select all the pages from a folder' do
      @sitemap_tree.add({ destination_path: 'doc/test/test2/test22.html' }.to_ostruct)
      @sitemap_tree.add({ destination_path: 'doc/test/test2/test13.html' }.to_ostruct)

      tree = @sitemap_tree.from_url('doc/test/test2')
      expect(tree.pages.length).to eq 2
      tree.pages.each do |page|
        expect(page.is_a?(Frontman::SitemapTree)).to eq true
      end
    end

    it 'should identify non-folders' do
      @sitemap_tree.add({ destination_path: 'doc/test/test2/test13.html' }.to_ostruct)

      item = @sitemap_tree.from_url('doc/test/test2/test13')
      expect(item.folder?).to eq false
    end

    it 'should raise an error when adding duplicate URLs' do
      @sitemap_tree.add({ destination_path: 'doc/test/tutorials/test13.html' }.to_ostruct)
      expect { @sitemap_tree.add({ destination_path: 'doc/test/tutorials/test13.html' }.to_ostruct) }.to raise_error Frontman::DuplicateResourceError
    end
  end
end
