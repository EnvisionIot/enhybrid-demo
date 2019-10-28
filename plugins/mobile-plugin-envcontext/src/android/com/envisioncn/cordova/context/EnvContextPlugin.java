package com.envisioncn.cordova.context;

import android.net.Uri;
import android.util.Log;

import org.apache.cordova.CordovaPlugin;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.Charset;

/**
 * Created by chao.xu on 16/6/21.
 */
public class EnvContextPlugin extends CordovaPlugin {
    private static final String TAG = "EnvContextPlugin";

    //临时 js文件的uri
    private Uri tempScriptUri = null;

    /**
     * Html中请求的脚本路径
     */
    public static final String EnvContextScript = "envcontext.js";

    public static final String cordovaScript = "cordova.js";
    public static final String cordovaPluginScript = "cordova_plugins.js";
    public static final String pluginsPrefix = "plugins/";
    public static final String assetPathPrefix = "file:///android_asset/www/";

    @Override
    protected void pluginInitialize() {
        // 写入一个临时文件,作为envcontext.js的内容传回
        try {
            File outputDir = cordova.getActivity().getCacheDir();
            File outputFile = File.createTempFile("temp_envcontext", ".js", outputDir);
            FileOutputStream fos = new FileOutputStream(outputFile, false);
            byte[] content = contextScript().getBytes(Charset.forName("UTF-8"));
            fos.write(content, 0, content.length);
            fos.close();
            tempScriptUri = Uri.fromFile(outputFile);
            content = null;
        }catch (IOException e){
            e.printStackTrace();
            Log.w(TAG, "初始化envcontext 失败");
        }
    }

    /**
     *
     * @return 提供要写入envcontext.js的内容
     */
    private String contextScript(){
        return "window.navigator.serverAddress = '//to do';";
    }

    @Override
    public Uri remapUri(Uri uri) {
        String uriStr = uri.toString();

        if(uriStr.contains(EnvContextScript) ){
            return tempScriptUri;
        }else if(uriStr.contains(cordovaScript)) {
            return Uri.parse(assetPathPrefix + cordovaScript);
        }else if(uriStr.contains(cordovaPluginScript)) {
            return Uri.parse(assetPathPrefix + cordovaPluginScript);
        }else if(uriStr.contains(pluginsPrefix)) {
            String pluginPath = uriStr.substring(uriStr.indexOf(pluginsPrefix));
            return Uri.parse(assetPathPrefix + pluginPath);
        }
        return null;
    }
}
