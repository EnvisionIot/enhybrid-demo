#!/usr/bin/env node

module.exports = function(ctx) {
  var shell = require('shelljs');
  var path = require('path');
  var fs = require('fs-extra');
  var ConfigParser = ctx.requireCordovaModule('cordova-common').ConfigParser,  
      config = new ConfigParser(path.join(ctx.opts.projectRoot, "config.xml")), 
      packageName = config.android_packageName() || config.packageName();

  try {
    var sourceFilesToEditor = path.join(ctx.opts.projectRoot, '/plugins/mobile-plugin-web-container/src/android/com/envisioncn/cordova/webContainer');
    var files = shell.find(sourceFilesToEditor)
    for (var i = 0; i < files.length; i++) {
      var file = files[i];
      if(file.indexOf(".java") != -1) {
        writeSourceFileSync(fs, file, packageName);
      }
    } 
    var valueResDir = path.join(ctx.opts.projectRoot, '/platforms/android/app/src/main/res/values');
    var stringResFile = path.join(ctx.opts.projectRoot, '/platforms/android/app/src/main/res/values/strings.xml');
    if(!fs.existsSync(stringResFile)){
      shell.cp('-R', path.join(ctx.opts.projectRoot, '/plugins/mobile-plugin-web-container/src/android/res/values/strings.xml'), valueResDir);
    }
    var attrsResFile = path.join(ctx.opts.projectRoot, '/platforms/android/app/src/main/res/values/attrs.xml');
    if(!fs.existsSync(attrsResFile)){
      shell.cp('-R', path.join(ctx.opts.projectRoot, '/plugins/mobile-plugin-web-container/src/android/res/values/attrs.xml'), valueResDir);
    }
    var colorsResFile = path.join(ctx.opts.projectRoot, '/platforms/android/app/src/main/res/values/colors.xml');
    if(!fs.existsSync(colorsResFile)){
      shell.cp('-R', path.join(ctx.opts.projectRoot, '/plugins/mobile-plugin-web-container/src/android/res/values/colors.xml'), valueResDir);
    }
    var dimensResFile = path.join(ctx.opts.projectRoot, '/platforms/android/app/src/main/res/values/dimens.xml');
    if(!fs.existsSync(dimensResFile)){
      shell.cp('-R', path.join(ctx.opts.projectRoot, '/plugins/mobile-plugin-web-container/src/android/res/values/dimens.xml'), valueResDir);
    }
    var stylesResFile = path.join(ctx.opts.projectRoot, '/platforms/android/app/src/main/res/values/styles.xml');
    if(!fs.existsSync(stylesResFile)){
      shell.cp('-R', path.join(ctx.opts.projectRoot, '/plugins/mobile-plugin-web-container/src/android/res/values/styles.xml'), valueResDir);
    }
  } catch (err) {
  }
}

function writeSourceFileSync(fs, file, packageName){
  var data = fs.readFileSync(file, {encoding: 'utf-8'}); 
  data = data.replace(/\${PACKAGE_NAME}/m, packageName);  
  fs.writeFileSync(file, data);
}
