#!/usr/bin/env node

module.exports = function(ctx) {
    var shell = require('shelljs');
    var path = require('path');
    var fs = require('fs-extra');
    var ConfigParser = ctx.requireCordovaModule('cordova-common').ConfigParser,  
        config = new ConfigParser(path.join(ctx.opts.projectRoot, "config.xml")), 
        packageName = config.android_packageName() || config.packageName();
  
    try {       
        var arr = packageName.split(".");
        var packageDir = '';
        for (var i = 0; i < arr.length; i++) {
            packageDir += arr[i];
            if(i != arr.length - 1){
                packageDir += '/';
            }
        }
        var androidManifestFileFileToCP = path.join(ctx.opts.projectRoot, '/preset_plugins/mobile-plugin-project-init/src/android/app/AndroidManifest.xml');
        var androidManifestFile = path.join(ctx.opts.projectRoot, '/platforms/android/app/src/main/AndroidManifest.xml');
        var mainActivityFileToDelete = path.join(ctx.opts.projectRoot, '/platforms/android/app/src/main/java/' + packageDir + '/MainActivity.java');
        var buildFileToDelete = path.join(ctx.opts.projectRoot, '/platforms/android/app/build.gradle');
        var buildFileToCP = path.join(ctx.opts.projectRoot, '/preset_plugins/mobile-plugin-project-init/src/android/app/build.gradle');
        var buildFileDir = path.join(ctx.opts.projectRoot, '/platforms/android/app/');
        var buildExtresFileToCP = path.join(ctx.opts.projectRoot, '/preset_plugins/mobile-plugin-project-init/src/android/app/build-extras.gradle');
        var buildExtresFileDir = path.join(ctx.opts.projectRoot, '/platforms/android/app/');
  
        var buildFileToDelete2 = path.join(ctx.opts.projectRoot, '/platforms/android/build.gradle');
        var buildFileToCP2 = path.join(ctx.opts.projectRoot, '/preset_plugins/mobile-plugin-project-init/src/android/build.gradle');
        var buildFileDir2 = path.join(ctx.opts.projectRoot, '/platforms/android/');

        var webappDir = path.join(ctx.opts.projectRoot, '/platforms/android/app/src/main/assets/webapp');

        shell.mkdir(webappDir);
        shell.rm(buildFileToDelete);
        shell.rm(buildFileToDelete2);
        shell.rm(mainActivityFileToDelete);
        shell.cp('-R', buildFileToCP, buildFileDir);
        shell.cp('-R', buildFileToCP2, buildFileDir2);
        shell.cp('-R', buildExtresFileToCP, buildExtresFileDir);
        var data = fs.readFileSync(androidManifestFileFileToCP, {encoding: 'utf-8'});
        data = data.replace(/package=\"(.*?)\"/m, 'package=\"' + packageName + '\"');  
        data = data.replace(/\${MyApplication}/m, packageName + '.MyApplication');  
        fs.writeFileSync(androidManifestFile, data);
        var applicationFileToCP = path.join(ctx.opts.projectRoot, '/preset_plugins/mobile-plugin-project-init/src/android/java/MyApplication.java');
        var applicationFileDir = path.join(ctx.opts.projectRoot, '/platforms/android/app/src/main/java/' + packageDir);
        shell.cp('-R', applicationFileToCP, applicationFileDir);
        var applicationFileToEditor = path.join(ctx.opts.projectRoot, '/platforms/android/app/src/main/java/' + packageDir + '/MyApplication.java');
        data = fs.readFileSync(applicationFileToEditor, {encoding: 'utf-8'});   
        data = data.replace(/\${package}/m, 'package ' + packageName + ';');  
        fs.writeFileSync(applicationFileToEditor, data);

        var splashFileToCP = path.join(ctx.opts.projectRoot, '/preset_plugins/mobile-plugin-project-init/src/android/java/SplashActivity.java');
        var splashFileDir = path.join(ctx.opts.projectRoot, '/platforms/android/app/src/main/java/' + packageDir);
        shell.cp('-R', splashFileToCP, splashFileDir);
        var splashFileToEditor = path.join(ctx.opts.projectRoot, '/platforms/android/app/src/main/java/' + packageDir + '/SplashActivity.java');
        data = fs.readFileSync(splashFileToEditor, {encoding: 'utf-8'});   
        data = data.replace(/\${package}/m, 'package ' + packageName + ';');  
        fs.writeFileSync(splashFileToEditor, data);
    } catch (err) {
    }
  }