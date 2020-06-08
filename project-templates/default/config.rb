# frozen_string_literal: true

register_data_dirs(['app_data'])
register_layout '*', 'main.haml'

Frontman::Bootstrapper.resources_from_dir(
  'source/'
).each do |resource|
  sitemap_tree.add(resource)
end
