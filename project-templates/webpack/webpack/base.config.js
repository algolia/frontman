const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CopyPlugin = require('copy-webpack-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

const dist = 'assets'

module.exports = {
  entry: {
    index: path.resolve(__dirname, '../assets/js/index.js'),
    style: path.resolve(__dirname, '../assets/css/style.css'),
    code: path.resolve(__dirname, '../assets/css/code.css'),
  },
  output: {
    path: path.resolve(__dirname, '../.tmp'),
    filename: `${dist}/js/[name].js`
  },
  module: {
    rules: [
      {
        test: /\.m?js$/,
        exclude: /(node_modules)/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env']
          }
        }
      },
      {
        test: /\.css$/i,
        use: [MiniCssExtractPlugin.loader, 'css-loader'],
      },
    ]
  },
  plugins: [
    new CleanWebpackPlugin(),
    new MiniCssExtractPlugin({
      filename: `${dist}/css/[name].css`,
      chunkFilename: `${dist}/css/[name].css`
    }),
    new CopyPlugin({
      patterns: [
          {
            from: path.resolve(__dirname, '../assets/images/'),
            to: 'assets/images'
          }
      ],
    }),
  ],
};
