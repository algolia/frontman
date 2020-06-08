const merge = require('webpack-merge')
const baseConfig = require('./base.config.js')

const env = 'development'

module.exports = merge(baseConfig, { mode: env })
