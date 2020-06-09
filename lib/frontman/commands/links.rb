# frozen_string_literal: false

require 'find'
require 'frontman/app'
require 'frontman/bootstrapper'
require 'frontman/iterator'
require 'nokogiri'
require 'thor'

module Frontman
  class CLI < Thor
    desc 'links', 'Check if your website contains any broken internal links'
    def links
      @start = Time.now

      @build_files = []
      @html_files = []

      Find.find('build') do |path|
        @build_files << path unless File.directory?(path)
        @html_files << path if path =~ /.*\.html$/
      end

      $files = (Frontman::Iterator.map(
        @build_files,
        in_processes: (Frontman::Iterator.processor_count / 2).ceil
      ) do |page|
        content = File.read(page)
        if page =~ /.*\.html$/
          doc = Nokogiri::HTML(content)
          links = (doc / 'a, link, script, img').map do |link|
            is_link = %w[a link].include?(link.name)
            href = is_link ? link['href'] : link['src']
            { is_link: is_link, href: href }
          end

          ids = doc.search('*[@id]').map { |e| e.attribute('id').value }
          [page, { links: links, ids: ids }]
        else
          [page, true]
        end
      end).to_h

      counts = Frontman::Iterator.map(@html_files, in_processes: (Frontman::Iterator.processor_count / 2).ceil) do |page|
        links = get_links(page)

        count_links = 0
        count_anchors = 0

        links = links.uniq { |x| "#{x[:link]}#{x[:anchor]}" }

        links.each do |anchor|
          if $files[anchor[:link]].nil?
            broken_link = anchor[:link].to_s + anchor[:anchor].to_s
            count_links += 1
            output_error(broken_link, anchor[:from])
            next
          end

          next unless anchor[:anchor]

          begin
            matching_anchors = $files[anchor[:link]][:ids].include?(anchor[:anchor].gsub('#', ''))
          rescue Nokogiri::CSS::SyntaxError
            matching_anchors = false
          end

          unless matching_anchors
            count_anchors += 1
            output_error(anchor[:anchor], anchor[:from])
          end
        end

        [count_links, count_anchors]
      end

      bad_link_count = 0
      bad_anchor_count = 0

      counts.each do |count_links, count_anchors|
        bad_link_count += count_links
        bad_anchor_count += count_anchors
      end

      print "#{bad_link_count} bad link. #{bad_anchor_count} bad anchors\n"

      @end = Time.now

      puts "Time elapsed ~#{((@end - @start) * 1000).ceil} milliseconds\n"

      exit(1) if (bad_anchor_count + bad_link_count).positive?
    end
  end
end

def get_links(page)
  links = []

  $files[page][:links].each do |link|
    is_link = link[:is_link]
    href = link[:href]
    if is_link
      if href.nil?
        links.push(link: '__empty__', anchor: nil, from: page)
        next
      end
    elsif href.nil?
      next
    end

    href = href.gsub(%r{/$}, '')
               .gsub(%r{/#}, '#')

    skip = %w[javascript: http:// https:// mailto: //]
    next if href.start_with?(*skip) || (href == '#')

    if href.start_with?('#')
      links.push(link: page, anchor: href, from: page)
    else
      parts = href.split('#')
      extension = File.extname(parts[0])
      link = "build#{parts[0]}"
      linked = ['', '.html'].include?(extension) ? "#{link}/index.html" : link
      anchor = parts.size >= 2 ? "##{parts[1]}" : nil
      links.push(link: linked, anchor: nil, from: page)

      links.push(link: linked, anchor: anchor, from: page) unless anchor.nil?
    end
  end

  links
end

def format_url(path)
  path.delete_prefix('build').delete_suffix('index.html')
end

def output_error(link, page)
  page = format_url(page)
  print "[ERROR] Did not find #{link} included in page #{page}\n"
end
