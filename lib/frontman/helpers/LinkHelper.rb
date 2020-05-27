# typed: true
# frozen_string_literal: false

require 'htmlentities'
require 'singleton'
require 'sorbet-runtime'

module LinkHelper
  extend T::Sig

  sig { params(str: String, salt: String).returns(String) }
  def generate_id(str, salt = '')
    id = slugify(str)

    @ids ||= {}
    @ids[salt.to_s + id] ||= 0
    @ids[salt.to_s + id] += 1
    @ids[salt.to_s + id] == 1 ? id : "#{id}-#{@ids[salt.to_s + id]}"
  end

  sig { void }
  def reset_ids_generation
    @ids = {}
  end

  sig { params(string: String).returns(String) }
  def slugify(string)
    HTMLEntities.new
      .decode(string)
      .gsub(%r{</?[^>]*>}, '')
      .gsub(/\s/, '-')
      .gsub(%r{[\[\]()/",`'&<>\.*]}, '')
      .downcase
  end
end