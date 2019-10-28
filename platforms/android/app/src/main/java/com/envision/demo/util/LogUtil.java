package com.envision.demo.util;

import android.util.Log;

public class LogUtil {
    private final static boolean DEBUG = true;
    private final static int MAX_LENGTH = 1000;

    private LogUtil() {
    }

    public static void d(String tag, String msg) {
        if (DEBUG)
            Log.d(tag, msg);
    }

    public static void e(String tag, String msg) {
        if (DEBUG)
            Log.e(tag, msg);
    }

    public static void i(String tag, String msg) {
        if (DEBUG)
            Log.i(tag, msg);
    }

    public static void w(String tag, String msg) {
        if (DEBUG)
            Log.w(tag, msg);
    }

    public static void v(String tag, String msg) {
        if (DEBUG)
            Log.v(tag, msg);
    }

    public static void iLong(String tag, String msg) {
        if (DEBUG) {
            int length = msg.length();
            for (int i = 0; i < length; i += MAX_LENGTH)
                Log.i(tag, msg.substring(i, Math.min(i + MAX_LENGTH, length)));
        }
    }
}
