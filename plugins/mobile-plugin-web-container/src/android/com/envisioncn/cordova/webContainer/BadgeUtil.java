package com.envisioncn.cordova.webContainer;

import android.content.Context;
import android.util.TypedValue;

import com.envision.demo.R;
import com.readystatesoftware.viewbadger.BadgeView;


public class BadgeUtil {
    /**
     * 统一处理显示角标的逻辑
     *
     * @param context
     * @param badgeView
     * @param num
     */
    public static void showBadge(Context context, BadgeView badgeView, String num) {
        if (null != badgeView) {
            badgeView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 10);
            badgeView.setBadgeBackgroundColor(context.getResources().getColor(R.color.env_navi_corner_color));
            badgeView.setTextColor(context.getResources().getColor(R.color.env_navi_corner_text_color));
            badgeView.setMaxWidth(Integer.MAX_VALUE);
            badgeView.setMaxHeight(Integer.MAX_VALUE);
            if (null != num) {
                if (num.equals("0")) {
                    badgeView.hide();
                } else if (num.equals("")) {
                    // 红点角标
                    badgeView.setBadgeMargin(DensityUtil.dip2px(context, 10), DensityUtil.dip2px(context, 10));
                    badgeView.setMaxWidth(DensityUtil.dip2px(context, 10));
                    badgeView.setMaxHeight(DensityUtil.dip2px(context, 10));
                    badgeView.setText("");
                    badgeView.show();
                } else {
                    // 带数字的角标
                    badgeView.setBadgeMargin(DensityUtil.dip2px(context, 6), DensityUtil.dip2px(context, 6));
                    badgeView.setText(num);
                    badgeView.show();
                }
            } else {
                badgeView.hide();
            }
        }
    }

    /**
     * 统一处理显示角标的逻辑
     *
     * @param context
     * @param badgeView
     */
    public static void hideBadge(Context context, BadgeView badgeView) {
        if (null != badgeView) {
            badgeView.hide();
        }
    }
}
