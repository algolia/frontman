const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const merge = require('webpack-merge')
const baseConfig = require('./base.config.js')

const env = 'production'

module.exports = merge(baseConfig, {
  mode: env,
  plugins: [
    new OptimizeCssAssetsPlugin({
      filename: '[name].css',
      chunkFilename: '[id].css',
      cssProcessorPluginOptions: {
        preset: [
          'default',
          {
            discardComments: {
              removeAll: true
            }
          }
        ]
      }
    })
  ],
  optimization: {
    splitChunks: {
      chunks: 'all'
    }
  }
})
