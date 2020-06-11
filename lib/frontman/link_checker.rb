# typed: false
# frozen_string_literal: false

require 'find'
require 'frontman/iterator'

module Frontman
  class LinkChecker
    attr_reader :path, :files, :html_files, :broken_link_count,
                :broken_anchor_count

    def initialize
      @files = []
      @html_files = []
      @broken_link_count = 0
      @broken_anchor_count = 0
    end

    def check(path)
      @path = path
      list_files
      extract_urls
      check_urls
    end

    def passes?
      !failed?
    end

    def failed?
      (@broken_anchor_count + @broken_link_count).positive?
    end

    private

    def check_urls
      counts = Frontman::Iterator.map(
        @html_files,
        in_processes: (Frontman::Iterator.processor_count / 2).ceil
      ) do |path|
        links = get_links(path).uniq { |x| "#{x[:link]}#{x[:anchor]}"}

        broken_links = 0
        broken_anchors = 0

        links.each do |anchor|
          if @files[anchor[:link]].nil?
            broken_link = anchor[:link].to_s + anchor[:anchor].to_s
            broken_links += 1
            output_error(broken_link, anchor[:from])
            next
          end

          next unless anchor[:anchor]

          begin
            matching_anchors = @files[anchor[:link]][:ids]
                                 .include?(anchor[:anchor].gsub('#', ''))
          rescue Nokogiri::CSS::SyntaxError
            matching_anchors = false
          end

          unless matching_anchors
            broken_anchors += 1
            output_error(anchor[:anchor], anchor[:from])
          end
        end

        [broken_links, broken_anchors]
      end



      @broken_link_count = 0
      @broken_anchor_count = 0

      counts.each do |links, anchors|
        @broken_link_count += links
        @broken_anchor_count += anchors
      end
    end

    def list_files
      Find.find(@path) do |path|
        @files << path unless File.directory?(path)
        @html_files << path if path.end_with?('.html')
      end
    end

    def extract_urls
      @files = (Frontman::Iterator.map(
        @files,
        in_processes: (Frontman::Iterator.processor_count / 2).ceil
      ) do |path|
        if path.end_with?('.html')
          [path, extract_links_from_html(Nokogiri::HTML(File.read(path)))]
        else
          [path, true]
        end
      end).to_h
    end

    def extract_links_from_html(html)
      links = (html / 'a, link, script, img').map do |link|
        is_link = %w[a link].include?(link.name)
        href = is_link ? link['href'] : link['src']
        { is_link: is_link, href: href }
      end

      ids = html.search('*[@id]').map { |e| e.attribute('id').value }

      { links: links, ids: ids }
    end

    def get_links(path)
      links = []
      @files[path][:links].each do |link|
        if link[:is_link] && link[:href].nil?
          links.push(link: '__empty__', anchor: nil, from: path)
        end

        next if link[:href].nil?

        href = link[:href].gsub(%r{/$}, '').gsub(%r{/#}, '#')
        format_link(href, path).each do |formatted|
          links.push(formatted)
        end
      end
      links
    end

    def format_link(href, file)
      return [] if skip_link?(href)
      return [{ link: file, anchor: href, from: file }] if href.start_with?('#')

      parts = href.split('#')
      extension = File.extname(parts[0])
      path = "build#{parts[0]}"
      link = ['', '.html'].include?(extension) ? "#{path}/index.html" : path
      formatted_links = [{ link: link, anchor: nil, from: file }]

      if parts.size >= 2
        formatted_links.push(link: link, anchor: "##{parts[1]}", from: file)
      end

      formatted_links
    end

    def skip_link?(href)
      skip = %w[javascript: http:// https:// mailto: //]
      href.start_with?(*skip) || (href == '#')
    end

    def format_url(path)
      path.delete_prefix('build').delete_suffix('index.html')
    end

    def output_error(link, page)
      page = format_url(page)
      link = format_url(link)
      print "[ERROR] Did not find #{link} included in page #{page}\n"
    end

  end
end