package com.envisioncn.cordova.webContainer;

import android.content.Context;
import android.content.res.TypedArray;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by zhenghuiyu on 2017/4/24.
 */

public class EnvStyleUtil {

    public static Integer getStyleByAttr(Context context, int resid, int attr) {
        Map<Integer, Integer> styleMaps = new HashMap<Integer, Integer>();
        TypedArray typedArray = context.obtainStyledAttributes(resid, new int[]{attr});
        styleMaps.put(attr, typedArray.getResourceId(0, -1));
        typedArray.recycle();
        return styleMaps.get(attr);
    }

    public static Integer getStyleByAttr(Context context, int attr) {
        Map<Integer, Integer> styleMaps = new HashMap<Integer, Integer>();
        TypedArray typedArray = context.obtainStyledAttributes(new int[]{attr});
        styleMaps.put(attr, typedArray.getResourceId(0, -1));
        typedArray.recycle();
        return styleMaps.get(attr);
    }
}