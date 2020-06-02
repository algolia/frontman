# frozen_string_literal: true

module UrlHelper
  def format_url(url)
    formatted = url.gsub('index.html', '')
                   .delete_prefix('/')
                   .delete_suffix('/')

    "/#{formatted}/".gsub('//', '/')
  end
end
