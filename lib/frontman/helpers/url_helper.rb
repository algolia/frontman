# frozen_string_literal: true

module UrlHelper
  def format_url(url)
    formatted = url.gsub('index.html', '')
                   .sub(/^\//, '')
                   .chomp('/')

    "/#{formatted}/".gsub('//', '/')
  end
end
