package com.envision.demo.base;

import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.envisioncn.cordova.webContainer.BadgeUtil;
import com.envisioncn.cordova.webContainer.EnvBaseWebViewActivity;
import com.envisioncn.cordova.naviBar.NaviBarView;


import com.envision.demo.R;
import com.envisioncn.cordova.webContainer.EnvIconView;
import com.envisioncn.mobile.hybrid.util.StringUtil;
import com.gyf.barlibrary.ImmersionBar;
import com.readystatesoftware.viewbadger.BadgeView;

public abstract class BaseWindWebViewActivity extends EnvBaseWebViewActivity implements NaviBarView {

    protected Toolbar toolbar = null;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ImmersionBar.with(this)
                .statusBarColor(R.color.status_bar_color)
                .statusBarDarkFont(true)
                .init();
    }

    @Override
    public Context getContext() {
        return this;
    }

    @Override
    public Object getToolBar() {
        return toolbar;
    }

    @Override
    public void setNaviBarTitle(String title) {
        if (null != toolbar) {
            TextView titleTV = (TextView) toolbar.findViewById(R.id.toolbar_title);
            if(StringUtil.isEmpty(title)){
                titleTV.setText(title);
                toolbar.setClickable(false);
            }else{
                try {
                    titleTV.setText(getResources().getString(getResources().getIdentifier(title, "string", getPackageName())));
                }catch (Exception e){
                    titleTV.setText(title);
                }
                toolbar.setClickable(true);
            }
        }
    }

    @Override
    public void setNaviBarLeftIcon(String icon) {
        if (null != toolbar) {
            EnvIconView iconIV = (EnvIconView) toolbar.findViewById(R.id.left_icon_iv);
            View iconL = toolbar.findViewById(R.id.left_icon_corner);
            if (null != iconIV && null != iconL) {
                if (!StringUtil.isEmpty(icon)) {
                    iconL.setVisibility(View.VISIBLE);
                    try {
                        iconIV.setText(getResources().getString(getResources().getIdentifier(icon, "string", getPackageName())));
                    }catch (Exception e){
                        iconIV.setText(icon);
                    }
                } else {
                    iconL.setVisibility(View.INVISIBLE);
                }
            }
        }
    }

    @Override
    public void setNaviBarRightIcon(String icon) {
        if (null != toolbar) {
            EnvIconView iconIV = (EnvIconView) toolbar.findViewById(R.id.right_icon_iv);
            View iconL = toolbar.findViewById(R.id.right_icon_corner);
            if (null != iconIV && null != iconL) {
                if (!StringUtil.isEmpty(icon)) {
                    iconL.setVisibility(View.VISIBLE);
                    try {
                        iconIV.setText(getResources().getString(getResources().getIdentifier(icon, "string", getPackageName())));
                    }catch (Exception e){
                        iconIV.setText(icon);
                    }
                } else {
                    iconL.setVisibility(View.INVISIBLE);
                }
            }
        }
    }

    @Override
    public void showNaviBarLeftBadge(String num) {
        if (null != toolbar) {
            BadgeView badge = null;
            View target = toolbar.findViewById(R.id.left_icon_corner);
            Object badgeObj = target.getTag();
            if (null == badgeObj) {
                badge = new BadgeView(this, target);
                target.setTag(badge);
            } else {
                badge = (BadgeView) badgeObj;
            }
            BadgeUtil.showBadge(this, badge, num);
        }
    }

    @Override
    public void hideNaviBarLeftBadge() {
        if (null != toolbar) {
            BadgeView badge = null;
            View target = toolbar.findViewById(R.id.left_icon_corner);
            Object badgeObj = target.getTag();
            if (null == badgeObj) {
                badge = new BadgeView(this, target);
                target.setTag(badge);
            } else {
                badge = (BadgeView) badgeObj;
            }
            BadgeUtil.hideBadge(this, badge);
        }
    }

    @Override
    public void showNaviBarRightBadge(String num) {
        if (null != toolbar) {
            BadgeView badge = null;
            View target = toolbar.findViewById(R.id.right_icon_corner);
            Object badgeObj = target.getTag();
            if (null == badgeObj) {
                badge = new BadgeView(this, target);
                target.setTag(badge);
            } else {
                badge = (BadgeView) badgeObj;
            }
            BadgeUtil.showBadge(this, badge, num);
        }
    }

    @Override
    public void hideNaviBarRightBadge() {
        if (null != toolbar) {
            BadgeView badge = null;
            View target = toolbar.findViewById(R.id.right_icon_corner);
            Object badgeObj = target.getTag();
            if (null == badgeObj) {
                badge = new BadgeView(this, target);
                target.setTag(badge);
            } else {
                badge = (BadgeView) badgeObj;
            }
            BadgeUtil.hideBadge(this, badge);
        }
    }

    @Override
    public void enableNaviBar() {
        if (null != toolbar) {
            View leftBtn = toolbar.findViewById(R.id.left_icon_corner);
            View rightBtn = toolbar.findViewById(R.id.right_icon_corner);
            leftBtn.setClickable(true);
            rightBtn.setClickable(true);
            toolbar.setClickable(true);
        }
    }

    @Override
    public void disableNaviBar() {
        if (null != toolbar) {
            View leftBtn = toolbar.findViewById(R.id.left_icon_corner);
            View rightBtn = toolbar.findViewById(R.id.right_icon_corner);
            leftBtn.setClickable(false);
            rightBtn.setClickable(false);
            toolbar.setClickable(false);
        }
    }
}
