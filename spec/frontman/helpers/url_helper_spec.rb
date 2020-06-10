# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'lib/frontman/helpers/url_helper'

describe UrlHelper do
  subject do
    Class.new do
      include UrlHelper
    end.new
  end


  it 'should properly format a URL' do
    improperly_formatted = %w(hello-world/index.html /hello-world/index.html /hello-world hello-world/)

    improperly_formatted.each do |url|
      expect(subject.format_url(url)).to eq '/hello-world/'
    end
  end

end
