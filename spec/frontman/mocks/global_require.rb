# frozen_string_literal: true

Frontman::App.class_eval do
  def app_method
    'foo'
  end
end

class Foo
  def self.bar
    'foobar'
  end
end
