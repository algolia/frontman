# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'
require 'English'

module Frontman
  module Builder
    class AssetPipeline
      extend T::Sig

      attr_reader :pipelines

      sig { params(external_pipelines: T::Array[Hash]).void }
      def initialize(external_pipelines)
        @pipelines = external_pipelines
      end

      sig { params(timing: Symbol).returns(T::Array[Hash]) }
      def run!(timing)
        pipelines = get_by_timing(timing)

        pipelines.each do |pipeline|
          p "Running external asset pipeline: #{pipeline[:name]}"

          cmd_output = `#{pipeline[:command]}`
          puts cmd_output

          exit 1 unless $CHILD_STATUS.success?

          sleep(pipeline[:delay]) if pipeline[:delay]

          p "Finished: #{pipeline[:name]}"
        end

        pipelines
      end

      sig { params(timing: Symbol).returns(T::Array[T.nilable(Integer)]) }
      def run_in_background!(timing)
        pipelines = get_by_timing(timing)

        pipelines.map do |pipeline|
          p "Running external asset pipeline: #{pipeline[:name]}"
          pid = fork { exec(pipeline[:command]) }
          sleep(pipeline[:delay]) if pipeline[:delay]

          pid
        end
      end

      private

      sig { params(timing: Symbol).returns(T::Array[Hash]) }
      def get_by_timing(timing)
        @pipelines.filter { |pipeline| pipeline[:timing] == timing }
      end
    end
  end
end
