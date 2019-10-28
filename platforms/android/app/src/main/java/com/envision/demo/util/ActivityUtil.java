package com.envision.demo.util;

import android.support.annotation.StringRes;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.util.TypedValue;
import android.view.View;
import android.widget.TextView;

import com.envision.demo.R;
import com.envisioncn.cordova.webContainer.EnvIconView;
import com.envisioncn.cordova.webContainer.EnvStyleUtil;

public class ActivityUtil {

    public static void initToolbar(
        Toolbar toolbar, @StringRes int title, String leftIcon, String rightIcon, View.OnClickListener
        leftIconListener, View.OnClickListener rightIconListener
    ) {
        if (toolbar == null)
            return;
        toolbar.setBackgroundColor(toolbar.getContext().getResources().getColor(R.color.white_navi_bg_color));
        TextView titleTV = toolbar.findViewById(R.id.toolbar_title);
        titleTV.setText(title);
        titleTV.setTextColor(toolbar.getContext().getResources().getColor(R.color.white_navi_icon_color));
        titleTV.setTextSize(TypedValue.COMPLEX_UNIT_PX,
            (Integer) EnvStyleUtil.getStyleByAttr(toolbar.getContext(), R.attr.envNaviTitleTextSize));

        int iconColor = toolbar.getContext().getResources().getColor(R.color.white_navi_icon_color);
        int iconSize = (Integer) EnvStyleUtil.getStyleByAttr(toolbar.getContext(),
            R.attr.envNaviIconSize);

        if (!TextUtils.isEmpty(leftIcon)) {
            EnvIconView iconIV = toolbar.findViewById(R.id.left_icon_iv);
            View iconL = toolbar.findViewById(R.id.left_icon_corner);
            iconIV.setText(leftIcon);
            iconIV.setTextColor(iconColor);
//            iconIV.setTextSize(TypedValue.COMPLEX_UNIT_PX, iconSize);
            iconL.setOnClickListener(leftIconListener);
        }

        if (!TextUtils.isEmpty(rightIcon)) {
            EnvIconView iconIV = toolbar.findViewById(R.id.right_icon_iv);
            View iconR = toolbar.findViewById(R.id.right_icon_corner);
            iconIV.setText(rightIcon);
            iconIV.setTextColor(iconColor);
            iconIV.setTextSize(TypedValue.COMPLEX_UNIT_PX, iconSize);
            iconR.setOnClickListener(rightIconListener);
        }
    }
}
