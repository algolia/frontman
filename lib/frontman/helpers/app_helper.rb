# typed: true
# frozen_string_literal: false

require 'frontman/config'

module AppHelper
  extend T::Sig

  sig { returns(T::Boolean) }
  def build?
    Frontman::Config.get(:mode) == 'build'
  end

  sig { returns(T::Boolean) }
  def serve?
    !build?
  end
end
