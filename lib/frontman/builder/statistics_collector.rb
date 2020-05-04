# typed: true
# frozen_string_literal: true

require 'frontman/builder/builder'
require 'frontman/builder/mapping'
require 'frontman/toolbox/timer'
require 'sorbet-runtime'

module Frontman
  module Builder
    class StatisticsCollector
      extend T::Sig

      sig do
        params(
          builder: Frontman::Builder::Builder,
          mapping: Frontman::Builder::Mapping,
          timer: Frontman::Toolbox::Timer,
          new_files: T::Array[String]
        ).void
      end
      def self.output(builder, mapping, timer, new_files = [])
        puts JSON.pretty_generate(mapping.all)
        puts '================================================================='
        puts "Previous build size : #{builder.current_build_files.size} files"
        puts "Current build size  : #{new_files.size} files"

        %i[updated created deleted unchanged].each do |status|
          puts "#{status}    : #{Array(mapping.all[status]).length} files"
        end

        timer.stop
        puts timer.output
      end
    end
  end
end
