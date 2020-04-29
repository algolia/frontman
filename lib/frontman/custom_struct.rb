# typed: true
# frozen_string_literal: false

require 'ostruct'

class CustomStruct < OpenStruct
  def respond_to_missing?(method_id, *_arguments)
    to_h.respond_to?(method_id) || super(method_id)
  end

  def method_missing(method_id, *arguments, &block)
    if to_h.respond_to?(method_id)
      to_h.public_send(method_id, *arguments, &block)
    else
      super(method_id, *arguments)
    end
  end
end

class Hash
  def to_ostruct
    arr = map do |k, v|
      if v.is_a? Array
        [k, v.map { |el| el.respond_to?(:to_ostruct) ? el.to_ostruct : el }]
      else
        [k, v.respond_to?(:to_ostruct) ? v.to_ostruct : v]
      end
    end

    CustomStruct.new(Hash[arr])
  end
end

class Array
  def to_ostruct
    map do |item|
      item.respond_to?(:to_ostruct) ? item.to_ostruct : item
    end
  end
end
