/* eslint-disable import/no-unresolved */
/* eslint import/no-extraneous-dependencies: ["off"] */

const path = require('path');
const webpack = require('webpack');
const fs = require('fs');
const prefixer = require('autoprefixer'); // 自动添加css前缀
const HtmlWebpackPlugin = require('html-webpack-plugin');

const context = path.resolve('./src/');

const option = {
  devtool: false,
  entry: {
    common: ['react', 'react-dom', 'react-router-dom']
  },
  output: {
    path: path.join(__dirname, 'dist'),
    filename: '[name].bundle.js',
    chunkFilename: '[name].[id].chunk.js'
  },
  stats: {
    colors: true,
    reasons: false
  },
  resolve: {
    extensions: ['.js', '.jsx', '.css', '.less']
  },
  node: {
    net: 'empty',
    tls: 'empty',
    dns: 'empty'
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify('production')
    }),
    new webpack.LoaderOptionsPlugin({
      debug: false,
      options: {
        postcss: [
          prefixer()
        ]
      }
    }),
    new webpack.optimize.UglifyJsPlugin({
      output: {
        comments: false
      },
      compress: {
        warnings: false, // 不输出警告信息
        sequences: true,
        dead_code: true,
        conditionals: true,
        booleans: true,
        unused: true,
        if_return: true,
        join_vars: true,
        drop_console: true
      }
    })
  ],
  module: {
    rules: [{
      test: /\.jsx?$/,
      loader: 'babel-loader',
      include: path.join(__dirname, 'src')
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
      loader: 'url-loader?limit=20'
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
