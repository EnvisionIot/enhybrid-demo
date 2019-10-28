package com.envision.demo.util;

import java.lang.reflect.Field;

import android.content.Context;
import android.content.res.Configuration;
import android.util.Log;

/**
 * 屏幕相关工具
 * 
 * @author chao.xu
 * 
 */
public class ScreenUtils {
    private static final String TAG = ScreenUtils.class.getSimpleName();

    /**
     * 手机分辨率从 dp 单位 转成为 px(像素)
     * 
     * @param context
     *            上下文环境
     * @param dpValue
     *            以dp为单位的数值
     * @return
     */
    public static int dip2px(Context context, float dpValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dpValue * scale + 0.5f);
    }

    /**
     * 手机分辨率从 px(像素) 单位 转成为 dp
     * 
     * @param context
     *            上下文环境
     * @param pxValue
     *            以px为单位的数值
     * @return
     */
    public static int px2dip(Context context, float pxValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (pxValue / scale + 0.5f);
    }

    /**
     * 获取通知栏的高度
     * 
     * @param context
     *            上下文环境
     * @return
     */
    public static int getStatusBarHeight(Context context) {
        Class<?> c = null;
        Object obj = null;
        Field field = null;
        int x = 0, statusBarHeight = 0;
        try {
            c = Class.forName("com.android.internal.R$dimen");
            obj = c.newInstance();
            field = c.getField("status_bar_height");
            x = Integer.parseInt(field.get(obj).toString());
            statusBarHeight = context.getResources().getDimensionPixelSize(x);
        } catch (Exception e) {
            Log.e(TAG, "", e);
        }
        return statusBarHeight;
    }

    /**
     * 获取屏幕的宽度（px）
     * @param context
     * @return
     */
    public static int getScreenWidth(Context context) {
        return context.getResources().getDisplayMetrics().widthPixels;
    }

    /**
     * 获取屏幕的高度（px）
     * @param context
     * @return
     */
    public static int getScreenHeight(Context context) {
        return context.getResources().getDisplayMetrics().heightPixels;
    }

    /**
     * 获取屏幕dpi
     * @param context
     * @return
     */
    public static float getScreenDensity(Context context) {
        return context.getResources().getDisplayMetrics().density;
    }
    
    /**
     * 获取屏幕的dpi所属级别：mdpi, ldpi, xdpi等
     * @param context
     * @return
     */
    public static int getScreenDensityDpi(Context context) {
        return context.getResources().getDisplayMetrics().densityDpi;
    }
    
    
    /**
     * 判断当前设备是pad还是手机
     * @param context
     *                上下文
     * @return true pad; false 手机
     */
    public static boolean deviceIsPad(Context context) {
        return (context.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) >= Configuration.SCREENLAYOUT_SIZE_LARGE;
    }
}
