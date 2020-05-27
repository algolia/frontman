# frozen_string_literal: true

module Frontman
  module Helpers
    class UrlHelper
      class << self
        def format_url(url)
          formatted = url.gsub('index.html', '')
                         .delete_prefix('/')
                         .delete_suffix('/')

          "/#{formatted}/".gsub('//', '/')
        end
      end
    end
  end
end
