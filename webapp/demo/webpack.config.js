/* eslint-disable import/no-unresolved */
/* eslint import/no-extraneous-dependencies: ["off"] */

const path = require('path');
const webpack = require('webpack');
const fs = require('fs');
const HtmlWebpackPlugin = require('html-webpack-plugin');

const context = path.resolve('./src/');

const option = {
  devtool: 'eval',
  entry: {
    app: ['webpack-hot-middleware/client']
  },
  output: {
    path: path.join(__dirname, 'dist'),
    filename: '[name].bundle.js',
    chunkFilename: '[name].[id].chunk.js',
    publicPath: ''
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoEmitOnErrorsPlugin(),
    new webpack.NamedModulesPlugin(),
    new webpack.DefinePlugin({
      __DEBUG__: JSON.stringify(JSON.parse(process.env.DEBUG || 'false'))
    })
  ],
  node: {
    net: 'empty',
    tls: 'empty',
    dns: 'empty'
  },
  module: {
    rules: [{
      test: /\.jsx?$/,
      loader: 'babel-loader',
      exclude: /node_modules/
    }, {
      test: /\.(ttf|eot|svg|woff)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
      loader: 'file-loader'
    }, {
      test: /\.less/,
      loader: 'style-loader!css-loader!less-loader'
    }, {
      test: /\.css$/,
      loader: 'style-loader!css-loader'
    }, {
      test: /\.(png|jpg)$/,
      loader: 'url-loader?limit=8192'
    }, {
      test: /\.json$/,
      loader: 'json-loader'
    }]
  }
};

fs.readdirSync(context)
  .filter(entry => fs.statSync(path.join(context, entry)).isDirectory())
  .filter(entry => ['.svn', '.git', 'container', 'component', 'utils', 'layout', 'assets'].indexOf(entry) < 0)
  .forEach((entry) => {
    option.entry[entry] = [`${context}/${entry}`];
    option.plugins.push(new HtmlWebpackPlugin({
      template: 'index.html',
      filename: `${entry}.html`,
      chunks: ['common', entry],
      title: 'EnvHybrid Demo'
    }));
  });

module.exports = option;
