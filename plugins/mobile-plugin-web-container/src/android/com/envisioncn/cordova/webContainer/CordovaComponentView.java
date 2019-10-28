package com.envisioncn.cordova.webContainer;

import android.content.Context;

/**
 * 接口定义一个CordovaActivity所应该具有的一些基本行为
 */
public interface CordovaComponentView {

    /**
     * 上下文
     * @return
     */
    Context getContext();

    /**
     * 获得导航栏对象
     *
     */
    Object getToolBar();
    
    /**
     * 执行js
     *
     * @param type 事件类型
     */
    void postEventToJs(String type);

    /**
     * 执行js
     *
     * @param type 事件类型
     * @param data 事件数据
     */
    void postEventToJs(String type, Object data);

    /**
     * 根据字符串类型的key,获得字符串资源
     *
     * @param key
     * @return String
     */
    String getStringFromRes(String key);

    /**
     * 加载url
     *
     * @param url
     */
    void loadWebContent(String url);

    /**
     * 响应返回操作
     */
    void backToPrevious();
}
