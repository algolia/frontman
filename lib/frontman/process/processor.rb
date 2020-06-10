# frozen_string_literal: true

module Frontman
  module Process
    class Processor
      def process(*_args)
        raise NoMethodError 'process method is not implemented'
      end
    end
  end
end
