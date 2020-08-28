# frozen_string_literal: true

register_data_dirs(['data'])
register_helper_dir('helpers')

register_layout 'sitemap.xml', nil
register_layout '*', 'main.erb'
# Or use 'main.haml' if you prefer using HAML:
# register_layout '*', 'main.haml'

add_asset_pipeline(
  name: 'Webpack pipeline',
  command: build? ? 'npm run build' : 'npm run start',
  timing: :before
)

Frontman::Config.set :public_dir, '.tmp/'
Frontman::Config.set :domain, 'https://example.com'
Frontman::Config.set :fingerprint_assets, true

Frontman::Bootstrapper.resources_from_dir(
  'source/'
).each do |resource|
  sitemap_tree.add(resource)
end
