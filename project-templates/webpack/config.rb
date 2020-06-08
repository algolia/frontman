# frozen_string_literal: true

register_data_dirs(['app_data'])
register_helpers(Frontman::Bootstrapper.find_helpers_in('./helpers/'))
register_layout '*', 'main.haml'

add_asset_pipeline(
  name: 'Webpack server',
  command: 'yarn run start',
  timing: :before,
  mode: :serve
)

add_asset_pipeline(
  name: 'Webpack build',
  command: 'yarn run build',
  timing: :before,
  mode: :build
)

Frontman::Config.set :public_dir, '.tmp/'

Frontman::Bootstrapper.resources_from_dir(
  'source/'
).each do |resource|
  sitemap_tree.add(resource)
end
