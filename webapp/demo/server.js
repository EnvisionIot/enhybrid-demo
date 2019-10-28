/* eslint-disable import/no-unresolved */
const path = require('path');
const express = require('express');
const webpack = require('webpack');
const proxyMiddleware = require('http-proxy-middleware');
const url = require('url');
const config = require('./webpack.config');
const packageInfo = require('./package.json');

const moduleName = packageInfo.name;
const port = 3000;

const app = express();
const compiler = webpack(config);

app.use(require('webpack-dev-middleware')(compiler, {
  noInfo: true,
  publicPath: config.output.publicPath
}));

app.use(require('webpack-hot-middleware')(compiler));

app.use(proxyMiddleware('/demo/', {
  target: `http://localhost:${port}`,
  pathRewrite: {
    '^/demo/': '/'
  }
}));

function onMockData(req, res) {
  let reqUrl = req.url;
  if (reqUrl && reqUrl.indexOf('?') > 0) {
    reqUrl = reqUrl.substring(0, reqUrl.indexOf('?'));
  }
  setTimeout(() => {
    if (reqUrl.length > 0 && reqUrl.charAt(0) === '/') {
      let filePath = reqUrl.replace(/\/[0-9]+$/g, '/0');
      filePath = filePath.replace('/mockdata/', '');
      filePath = `${req.method.toLowerCase()}_${filePath}`;
      filePath = filePath.replace(/\//g, '_');
      filePath = filePath.replace(/\?.*/, '');
      filePath = `mockdata/${filePath}.json`;
      try {
        res.sendFile(path.join(__dirname, filePath));
      } catch (e) {
        res.sendFile(path.json(__dirname, '404.json'));
        res.end();
      }
    } else {
      res.status(404);
      res.end();
    }
  }, 500);
}

app.get('*', (req, res) => {
  let platform = 'desktop';
  if (/iPhone|iPad|iPod/i.test(req.headers['user-agent'])) {
    platform = 'ios';
  } else if (/Android/i.test(req.headers['user-agent'])) {
    platform = 'android';
  }
  if (req.url.indexOf('cordova.js') >= 0 || req.url.indexOf('cordova_plugins.js') >= 0) {
    if (platform === 'ios' || platform === 'android') {
      res.sendFile(path.join(__dirname, `../platforms/${platform}/platform_www${req.url}`));
    } else {
      res.write('');
      res.end();
    }
  } else if (req.url.indexOf('/plugins/') >= 0) {
    if (platform === 'ios' || platform === 'android') {
      res.sendFile(path.join(__dirname, `../platforms/${platform}/platform_www${req.url}`));
    } else {
      res.write('');
      res.end();
    }
  } else if (req.url.indexOf('envcontext.js') >= 0) {
    res.write('');
    res.end();
  } else if (req.url.indexOf('raven.min.js') >= 0) {
    res.sendFile(path.join(__dirname, 'raven.min.js'));
  } else if (req.url.indexOf('/mockdata') >= 0) {
    onMockData(req, res);
  } else if (req.accepts('html')) {
    res.end();
    // `http://localhost:${port}/${req.url.substr(startIndex + 1, endIndex)}`;
  } else {
    res.status(404);
    res.end();
  }
});

app.post('*', (req, res) => {
  if (req.url.indexOf('/mockdata') >= 0) {
    onMockData(req, res);
  } else {
    res.status(404);
    res.end();
  }
});

app.listen(port, '0.0.0.0', (err) => {
  if (err) {
    console.error(err);
  }
});

