package com.envisioncn.cordova.naviBar;

import android.app.Activity;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;


public class NaviBarPlugin extends CordovaPlugin {
    private static final String TAG = "NaviBarPlugin";

    /**
     * Executes the request and returns PluginResult.
     *
     * @param action          The action to execute.
     * @param data            JSONArray of arguments for the plugin.
     * @param callbackContext The callback context used when calling back into JavaScript.
     * @return True when the action was valid, false otherwise.
     */
    @Override
    public boolean execute(String action, JSONArray data,
                           CallbackContext callbackContext) throws JSONException {
        /*
         * Don't run any of these if the current activity is finishing
         * in order to avoid android.view.WindowManager$BadTokenException
         * crashing the app. Just return true here since false should only
         * be returned in the event of an invalid action.
         */
        if (this.cordova.getActivity().isFinishing()) return true;
        if (action.equals("enableNaviBar")) {
            this.enableNaviBar(callbackContext);
        } else if (action.equals("disableNaviBar")) {
            this.disableNaviBar(callbackContext);
        } else if (action.equals("setTitle")) {
            this.setNaviBarTitle(data.getString(0), callbackContext);
        } else if (action.equals("showLeftBadge")) {
            this.showLeftBadge(data.getString(0), callbackContext);
        } else if (action.equals("hideLeftBadge")) {
            this.hideLeftBadge(callbackContext);
        } else if (action.equals("showRightBadge")) {
            this.showRightBadge(data.getString(0), callbackContext);
        } else if (action.equals("hideRightBadge")) {
            this.hideRightBadge(callbackContext);
        } else if (action.equals("setLeftIcon")) {
            this.setLeftIcon(data.getString(0), callbackContext);
        } else if (action.equals("setRightIcon")) {
            this.setRightIcon(data.getString(0), callbackContext);
        } else if (action.equals("showNaviBar")) {
            this.showNaviBar(callbackContext);
        } else if (action.equals("hideNaviBar")) {
            this.hideNaviBar(callbackContext);
        }
        // Only alert and confirm are async.
        callbackContext.success();
        return true;
    }

    /**
     * 显示导航栏
     * @param callbackContext
     */
    private void showNaviBar(CallbackContext callbackContext) {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (activity instanceof NaviBarView) {
                    // 配合框架默认实现
                    ((NaviBarView) activity).showNaviBar();
                } else {
                    // 自定义实现覆盖

                }
            }
        });
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    /**
     * 隐藏导航栏
     * @param callbackContext
     */
    private void hideNaviBar(CallbackContext callbackContext) {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (activity instanceof NaviBarView) {
                    // 配合框架默认实现
                    ((NaviBarView) activity).hideNaviBar();
                } else {
                    // 自定义实现覆盖

                }
            }
        });
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    /**
     * 使导航栏有效
     * @param callbackContext
     */
    private void enableNaviBar(CallbackContext callbackContext) {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (activity instanceof NaviBarView) {
                    // 配合框架默认实现
                    ((NaviBarView) activity).enableNaviBar();
                } else {
                    // 自定义实现覆盖

                }
            }
        });
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    /**
     * 使导航栏无效
     * @param callbackContext
     */
    private void disableNaviBar(CallbackContext callbackContext) {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (activity instanceof NaviBarView) {
                    // 配合框架默认实现
                    ((NaviBarView) activity).disableNaviBar();
                } else {
                    // 自定义实现覆盖

                }
            }
        });
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    /**
     * 设置导航栏title
     * @param title
     * @param callbackContext
     */
    private void setNaviBarTitle(final String title, CallbackContext callbackContext) {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                // 配合框架默认实现
                if (activity instanceof NaviBarView) {
                    ((NaviBarView) activity).setNaviBarTitle(title);
                } else {
                    // 自定义实现覆盖

                }
            }
        });
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    /**
     * 显示导航栏左边按钮的角标
     * @param num             角标显示的数字
     * @param callbackContext
     */
    private void showLeftBadge(final String num, CallbackContext callbackContext) {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (activity instanceof NaviBarView) {
                    // 配合框架默认实现
                    ((NaviBarView) activity).showNaviBarLeftBadge(num);
                } else {
                    // 自定义实现覆盖

                }
            }
        });
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    /**
     * 隐藏导航栏左边按钮的角标
     * @param callbackContext
     */
    private void hideLeftBadge(CallbackContext callbackContext) {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (activity instanceof NaviBarView) {
                    // 配合框架默认实现
                    ((NaviBarView) activity).hideNaviBarLeftBadge();
                } else {
                    // 自定义实现覆盖

                }
            }
        });
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    /**
     * 显示导航栏右边按钮的角标
     * @param num             角标显示的数字
     * @param callbackContext
     */
    private void showRightBadge(final String num, CallbackContext callbackContext) {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (activity instanceof NaviBarView) {
                    // 配合框架默认实现
                    ((NaviBarView) activity).showNaviBarRightBadge(num);
                } else {
                    // 自定义实现覆盖

                }
            }
        });
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    /**
     * 隐藏导航栏右边角标
     * @param callbackContext
     */
    private void hideRightBadge(CallbackContext callbackContext) {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (activity instanceof NaviBarView) {
                    // 配合框架默认实现
                    ((NaviBarView) activity).hideNaviBarRightBadge();
                } else {
                    // 自定义实现覆盖

                }
            }
        });
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    /**
     * 设置导航栏左上角的Icon
     *
     * @param icon            设置的icon值
     * @param callbackContext
     */
    private void setLeftIcon(final String icon, CallbackContext callbackContext) {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (activity instanceof NaviBarView) {
                    // 配合框架默认实现
                    ((NaviBarView) activity).setNaviBarLeftIcon(icon);
                } else {
                    // 自定义实现覆盖

                }
            }
        });
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    /**
     * 设置导航栏右上角的Icon
     *
     * @param icon            设置的icon值
     * @param callbackContext
     */
    private void setRightIcon(final String icon, CallbackContext callbackContext) {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (activity instanceof NaviBarView) {
                    // 配合框架默认实现
                    ((NaviBarView) activity).setNaviBarRightIcon(icon);
                } else {
                    // 自定义实现覆盖

                }
            }
        });
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }
}
