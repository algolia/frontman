# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'frontman/version'
require 'rake'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new(:rubocop)

task default: [:spec, :rubocop]

namespace :frontman do
  GEM_VERSION_FILE = File.join(Dir.pwd, 'lib/frontman/version.rb')
  GIT_TAG_URL      = 'https://github.com/algolia/frontman/releases/tag/'

  def last_commit_date
    `git log -1 --date=short --format=%cd`.chomp
  end

  def latest_tag
    `git describe --tags --abbrev=0`.chomp
  end

  def changelog(git_start = latest_tag, git_end = 'HEAD', format = '%s')
    `git log --no-decorate --no-merges --pretty=format:#{format} #{git_start}..#{git_end}`
  end

  desc 'Write latest changes to CHANGELOG.md'
  task :changelog, [:version] do |t, args|
    # Filters-out commits containing some keywords and adds header
    exceptions_regexp = Regexp.union(['README'])
    title = "## [#{args[:version]}] (#{GIT_TAG_URL}#{args[:version]}) (#{last_commit_date})\n\n"
    changes = changelog.each_line
                       .map { |line| exceptions_regexp === line ? nil : "* #{line.capitalize}" }
                       .unshift(title)
                       .push("\n\n")
                       .join

    puts changes
    puts "\n\e[31mDo you want to update the CHANGELOG.md with the text above? [y/N]\e[0m"
    exit if STDIN.gets.chomp.downcase != 'y'

    # Rewrite CHANGELOG.md
    old_changes = File.readlines('CHANGELOG.md', 'r').join
    File.open('CHANGELOG.md', 'w') { |file| file.write(changes, old_changes) }

    puts 'CHANGELOG.md successfully updated'
  end

  desc 'Bump gem version'
  task :semver, [:version] do |t, args|

    File.open(GEM_VERSION_FILE, 'w') do |file|
      file.write <<~SEMVER
        module Frontman
          VERSION = "#{args[:version]}"
        end
      SEMVER
    end

    # This force to reload the file with the newest version.
    # Hence, `gemspec.version` invoked by Bundler later on will be correct.
    load GEM_VERSION_FILE

    puts "Bumped gem version from #{latest_tag} to #{args[:version]}"
  end

  desc 'Release a new version of this gem'
  task :release, [:version] => %i[changelog semver] do |t, args|
    `git add #{File.expand_path('../lib/frontman/version.rb', __FILE__)} CHANGELOG.md`
    `git commit -m "Bump to version #{args[:version]}"`

    # Invoke Bundler :release task
    # https://github.com/bundler/bundler/blob/master/lib/bundler/gem_helper.rb
    #
    # Rake::Task[:release].invoke
  end
end

module Bundler
  class GemHelper
    def version_tag
      version.to_s
    end
  end
end
