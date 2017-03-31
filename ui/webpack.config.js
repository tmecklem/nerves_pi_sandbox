// webpack.config.js

var webpack = require('webpack');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: [
    './web/static/js/app.js',
    './web/static/css/app.scss',
  ],
  devtool: 'source-map',
  output: {
    path: './priv/static',
    filename: 'js/app.js'
  },
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        query: {
          presets: ['stage-1', 'react']
        }
      },
      {
        test: /\.scss$/,
        loader: ExtractTextPlugin.extract({fallback: "style-loader", use: "css-loader!sass-loader"})
      },
      {
        test: /\.(png|woff|woff2)$/,
        loader: 'url-loader?limit=100000'
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: "file-loader"
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin('css/app.css'),
    new CopyWebpackPlugin([{ from: './web/static/assets' }]),
    new webpack.ProvidePlugin({
      '$': 'jquery',
      'jQuery': 'jquery',
      'window.jQuery': 'jquery'
    })
  ],
  resolve: {
    extensions: ['.js', '.jsx']
  }
};

