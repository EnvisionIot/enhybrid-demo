#!/usr/bin/env node

module.exports = function(ctx) {
  var path = require('path');
  var xml = require('cordova-common').xmlHelpers;
  var fs = require('fs-extra');
  try {
    var xmlDoc1 = xml.parseElementtreeSync(path.join(ctx.opts.projectRoot, '/platforms/android/app/src/main/AndroidManifest.xml'));
    var xmlDoc2 = xml.parseElementtreeSync(path.join(ctx.opts.projectRoot, '/plugins/mobile-plugin-web-container/src/android/res/manifest.xml'));
    var children = xmlDoc2.find('children').getchildren();
    xml.graftXML(xmlDoc1, children, 'application');
    fs.writeFileSync(path.join(ctx.opts.projectRoot, '/platforms/android/app/src/main/AndroidManifest.xml'), xmlDoc1.write({ indent: 4 }));
  } catch (err) {
    console.log(err);
  }
}
