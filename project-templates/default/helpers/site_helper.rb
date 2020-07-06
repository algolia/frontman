# frozen_string_literal: true

module SiteHelper
  def page_title(current_page)
    current_page.data.title || data.site.title
  end
end
