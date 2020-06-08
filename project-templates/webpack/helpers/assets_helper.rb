module AssetsHelper
  def asset_url(path)
    Frontman::App.instance.assets_manifest[path.sub(%r{^/}, '')] || path
  end

  def vendor_scripts_by_chunk(chunk, scripts)
    raise ChunkNameError.new('"vendors" is an invalid chunk name') if chunk == 'vendors'

    pattern = /.*~#{chunk}.*|.*#{chunk}~.*$/

    scripts.select { |file_name| pattern.match?(file_name) }.sort { |a| a.start_with?('vendors~') ? -1 : 1 }
  end

  class ChunkNameError < ArgumentError
  end
end
