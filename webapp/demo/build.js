/* eslint-disable */

const fs = require('fs');
const path = require('path');
const spawn = require('child_process').spawn;
const process = require('process');

const moduleName = require('./package.json').name;
const androidWebappDir = '../../platforms/android/app/src/main/assets/webapp';
const iosWebappDir = '../../platforms/ios/webapp';

build(moduleName);

function build(moduleName, buildScript, outputDir) {
  if (!moduleName) {
    console.error('------- module name is empty, con not copy to mobile directory. -------');
    return;
  }

  const isWin = /^win/.test(process.platform);

  const script = buildScript || 'webpack --progress --config webpack.config.dist.js';
  const distDir = outputDir || 'dist';

  console.log('------- clear dist folder -------');
  cleanFolderSync(distDir, ['.DS_Store']);
  cleanFolderSync(`${androidWebappDir}/${moduleName}/bundles`, ['.DS_Store']);
  cleanFolderSync(`${iosWebappDir}/${moduleName}/bundles`, ['.DS_Store']);

  console.log('------- compile js start -------');
  // 编译JS
  let buildProcess = null;
  if (isWin) {
    buildProcess = spawn('cmd', ['/c', script]);
  } else {
    const cmd = script.split(/[ ]+/);
    console.log(cmd.slice(1));
    buildProcess = spawn(cmd[0], cmd.slice(1));
  }

  buildProcess.stdout.pipe(process.stdout);
  buildProcess.stderr.pipe(process.stderr);

  buildProcess.on('exit', function (code) {
    console.log(`Child exited with code ${code}`);
    if (code === 0) {
      console.log('------- compile js done -------');
      console.log('------- copy build results to platforms webapp folders -------');
      copyFolderRecursiveSync(distDir, `${androidWebappDir}/${moduleName}/bundles`, ['.DS_Store']);
      copyFolderRecursiveSync(distDir, `${iosWebappDir}/${moduleName}/bundles`, ['.DS_Store']);
      console.log('------- all completed -------');
    }
  });
}

function copyFileSync(source, target) {

  let targetFile = target;

  //if target is a directory a new file with the same name will be created
  if (fs.existsSync(target)) {
    if (fs.lstatSync(target).isDirectory()) {
      targetFile = path.join(target, path.basename(source));
    }
  }

  fs.writeFileSync(targetFile, fs.readFileSync(source));
}

function copyFolderRecursiveSync(source, target, ignores, integrated) {
  let files = [];

  //check if folder needs to be created or integrated
  let targetFolder = integrated ? path.join(target, path.basename(source)) : target;
  if (!fs.existsSync(targetFolder)) {
    //fs.mkdirSync( targetFolder );
    mkdirsSync(targetFolder);
  }

  //copy
  if (fs.lstatSync(source).isDirectory()) {
    files = fs.readdirSync(source);
    files.forEach(function (file) {
      const curSource = path.join(source, file);
      if (fs.lstatSync(curSource).isDirectory()) {
        copyFolderRecursiveSync(curSource, targetFolder);
      } else {
        if (ignores && ignores.indexOf(file) >= 0) {
          // ignore
        } else {
          copyFileSync(curSource, targetFolder);
        }
      }
    });
  }
}
//递归创建目录 同步方法
function mkdirsSync(directory) {
  if (fs.existsSync(directory)) {
    return true;
  } else {
    if (mkdirsSync(path.dirname(directory))) {
      fs.mkdirSync(directory);
      return true;
    }
  }
}

function cleanFolderSync(directory, ignores) {
  if (fs.existsSync(directory) && fs.lstatSync(directory).isDirectory()) {
    let files = fs.readdirSync(directory);
    files.forEach(function (file) {
      if (ignores && ignores.indexOf(file) >= 0) {
        //
      } else {
        const curSource = path.join(directory, file);
        if (fs.lstatSync(curSource).isDirectory()) {
          // dir 递归删除
          cleanFolderSync(curSource, ignores);
        } else {
          fs.unlinkSync(curSource);
        }
      }
    });
  }
}

/* eslint-enable */
