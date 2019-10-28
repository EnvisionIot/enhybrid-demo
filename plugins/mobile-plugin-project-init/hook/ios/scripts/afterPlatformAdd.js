#!/usr/bin/env node

module.exports = function(ctx) {
  var shell = require('shelljs');
  var path = require('path');
  var fs = require('fs-extra');
  var xcode = require('xcode');

  try {
    var configPath = path.join(ctx.opts.projectRoot, '/config.xml');
    var configData = fs.readFileSync(configPath, 'utf8');
    var projectName = configData.match(/<name>(.*)<\/name>/)[1];

    var AppDelegateFileH = path.join(ctx.opts.projectRoot, '/plugins/mobile-plugin-project-init/src/ios/class/AppDelegate.h');
    var AppDelegateFileM = path.join(ctx.opts.projectRoot, '/plugins/mobile-plugin-project-init/src/ios/class/AppDelegate.m');
    var classPath = path.join(ctx.opts.projectRoot, `/platforms/ios/${projectName}/Classes`);
    shell.cp('-Rf', AppDelegateFileH, classPath);
    shell.cp('-Rf', AppDelegateFileM, classPath);
    shell.rm('-Rf', path.join(ctx.opts.projectRoot, `/platforms/ios/${projectName}/Classes/MainViewController.h`));
    shell.rm('-Rf', path.join(ctx.opts.projectRoot, `/platforms/ios/${projectName}/Classes/MainViewController.m`));
    shell.rm('-Rf', path.join(ctx.opts.projectRoot, `/platforms/ios/${projectName}/Classes/MainViewController.xib`));
    shell.mkdir(path.join(ctx.opts.projectRoot, `/platforms/ios/webapp`));

    var xcproject = path.join(ctx.opts.projectRoot, `/platforms/ios/${projectName}.xcodeproj/project.pbxproj`);
    var xcodeproj = xcode.project(xcproject);
    xcodeproj.parseSync();
    var groupKey = xcodeproj.findPBXGroupKey({name: 'Classes'});
    var groupKey2 = xcodeproj.findPBXGroupKey({name: 'CustomTemplate'});
    xcodeproj.removeHeaderFile('MainViewController.h', null, groupKey);
    xcodeproj.removeSourceFile('MainViewController.m', null, groupKey);
    xcodeproj.removeResourceFile('MainViewController.xib', null, groupKey);
    xcodeproj.addResourceFile('webapp', {'lastKnownFileType':'folder'}, groupKey2);
    fs.writeFileSync(xcproject, xcodeproj.writeSync(), 'utf8');
  } catch (err) {
    console.log(err);
  }
}

