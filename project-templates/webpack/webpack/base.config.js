const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

const dist = 'assets'

module.exports = {
  entry: {
    index: path.resolve(__dirname, '../assets/index.js'),
    style: path.resolve(__dirname, '../assets/style.css'),
  },
  output: {
    path: path.resolve(__dirname, '../.tmp'),
    filename: `${dist}/[name].js`
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
      filename: `${dist}/[name].css`,
      chunkFilename: `${dist}/[name].css`
    }),
  ],
};
