package com.envisioncn.cordova.naviBar;


/**
 * Cordova插件接口,定义用于Activity相关的行为接口
 *
 * @author zhenghui.yu
 */
public interface NaviBarView {
    /**
     * 设置导航栏标题
     *
     * @param title
     */
    void setNaviBarTitle(final String title);

    /**
     * 设置导航栏左侧Icon
     *
     * @param icon
     */
    void setNaviBarLeftIcon(String icon);

    /**
     * 设置导航栏右侧Icon
     *
     * @param icon
     */
    void setNaviBarRightIcon(String icon);

    /**
     * 显示导航栏左侧Icon角标
     *
     * @param num
     */
    void showNaviBarLeftBadge(String num);

    /**
     * 隐藏导航栏左侧Icon角标
     */
    void hideNaviBarLeftBadge();

    /**
     * 显示导航栏右侧Icon角标
     *
     * @param num
     */
    void showNaviBarRightBadge(String num);

    /**
     * 隐藏导航栏右侧Icon角标
     */
    void hideNaviBarRightBadge();

    /**
     * 使导航栏有效
     */
    void enableNaviBar();

    /**
     * 使导航栏无效
     */
    void disableNaviBar();

    /**
     * 显示导航栏
     */
    void showNaviBar();

    /**
     * 隐藏导航栏
     */
    void hideNaviBar();

}
