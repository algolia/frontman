# frozen_string_literal: false

require 'find'
require 'frontman/app'
require 'frontman/link_checker'
require 'frontman/toolbox/timer'
require 'frontman/iterator'
require 'nokogiri'
require 'thor'

module Frontman
  class CLI < Thor
    desc 'links', 'Check if your website contains any broken internal links'
    def links
      timer = Frontman::Toolbox::Timer.start

      link_checker = Frontman::LinkChecker.new
      link_checker.check('build')

      timer.stop
      timer.output

      exit(1) if link_checker.failed?
    end
  end
end