const merge = require('webpack-merge')
const baseConfig = require('./base.config.js')

const env = process.env.NODE_ENV || 'development'

module.exports = merge(baseConfig, { mode: env })
