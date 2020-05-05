register_layout('*', 'views/layouts/main.haml')

Frontman::Bootstrapper.resources_from_dir(
  'source/'
).each do |resource|
  sitemap_tree.add(resource)
end

