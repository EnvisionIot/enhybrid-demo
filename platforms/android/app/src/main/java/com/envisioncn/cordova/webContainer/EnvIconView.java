package com.envisioncn.cordova.webContainer;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.util.AttributeSet;

import com.envisioncn.mobile.hybrid.util.StringUtil;
import com.envision.demo.R;

public class EnvIconView extends android.support.v7.widget.AppCompatTextView {

    private Context mContext;

    private String resPath = "";

    public EnvIconView(Context context) {
        super(context);
        // TODO Auto-generated constructor stub
        initView();
    }

    public EnvIconView(Context context, AttributeSet attrs) {
        super(context, attrs);
        mContext = context;
        initAttributes(attrs);
        initView();
    }

    public EnvIconView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        // TODO Auto-generated constructor stub
        mContext = context;
        initAttributes(attrs);
        initView();
    }

    private void initView() {
        if(!StringUtil.isEmpty(resPath)){
            setTypeface(Typeface.createFromAsset(mContext.getAssets(), resPath));
        }
    }

    /**
     * @param
     * @return void
     * @Description: 设置属性
     */
    private void initAttributes(AttributeSet attrs) {
        if (null != attrs) {
            TypedArray styled = getContext().obtainStyledAttributes(attrs,
                    R.styleable.EnvIconView);
            resPath = styled.getString(R.styleable.EnvIconView_iconttf);
            styled.recycle();
            if (null == resPath) {
                String envFontIconPath = getResources().getString(EnvStyleUtil.getStyleByAttr(getContext(), R.style.EnvWebContainerDefaultStyle, R.attr.envFontIconPath));
                if (null != envFontIconPath && !envFontIconPath.equals("")) {
                    resPath = envFontIconPath;
                }
            }
        }
    }
}
