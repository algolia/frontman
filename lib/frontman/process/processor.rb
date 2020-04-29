# frozen_string_literal: true

module Frontman
  module Process
    class Processor
      def process(*_args)
        # TODO: custom error (InheritanceError ?)
        raise NoMethodError 'process method is not implemented'
      end
    end
  end
end
