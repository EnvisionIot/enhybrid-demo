/* eslint-disable */

const fs = require('fs');
const path = require('path');
const spawn = require('child_process').spawn;
const process = require('process');

const androidWebappDir = path.join(__dirname, './platforms/android/app/src/main/assets/webapp');
const iosWebappDir = path.join(__dirname, './platforms/ios/webapp');

/**
 * 复制编译后的问文件到原生项目
 * distDir
 *  模块编译文件路径
 * moduleName
 *  模块名
 */
module.exports.copyToWebapps = function (distDir, moduleName){
  cleanFolderSync(`${androidWebappDir}/${moduleName}`, ['.DS_Store']);
  cleanFolderSync(`${iosWebappDir}/${moduleName}`, ['.DS_Store']);
  copyFolderRecursiveSync(distDir, `${androidWebappDir}/${moduleName}`, ['.DS_Store']);
  copyFolderRecursiveSync(distDir, `${iosWebappDir}/${moduleName}`, ['.DS_Store']);
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
        copyFolderRecursiveSync(curSource, targetFolder + '/' + file);
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
