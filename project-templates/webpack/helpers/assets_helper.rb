# frozen_string_literal: true

require 'frontman/app'

module AssetsHelper
  def asset_url(path)
    Frontman::App.instance.assets_manifest[path.sub(%r{^/}, '')] || path
  end

  def vendor_scripts_by_chunk(chunk, scripts)
    if chunk == 'vendors'
      raise ChunkNameError, '"vendors" is an invalid chunk name'
    end

    pattern = /.*~#{chunk}.*|.*#{chunk}~.*$/

    scripts.select { |file_name| pattern.match?(file_name) }.sort do |asset|
      asset.start_with?('vendors~') ? -1 : 1
    end
  end

  class ChunkNameError < ArgumentError
  end
end
