package com.envision.demo.widget;

import android.app.Activity;
import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.HorizontalScrollView;
import android.widget.Scroller;

import com.envision.demo.R;


public class SlidingLayout extends HorizontalScrollView {
    private int leftWidth;
    private ViewGroup leftView;
    private final Context context;
    private boolean isOpenMenu = false;

    private Scroller mScroller;
    private Activity mActivity;



    public SlidingLayout(Context context) {
        this(context, null);
        setFadingEdgeLength(0);
        initViews(context);
    }

    public SlidingLayout(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
        setFadingEdgeLength(0);
        initViews(context);

    }

    public SlidingLayout(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        this.context = context;
        //获取自定义的属性
        TypedArray typedArray = context.obtainStyledAttributes(attrs, R.styleable.SlidingLayout);
        float rightPadding = typedArray.getDimension(R.styleable.SlidingLayout_rightPadding, 80);
        typedArray.recycle();
        //计算左侧菜单的宽度
        leftWidth = (int) (getScreenWidth() - rightPadding + 0.5f);
        setFadingEdgeLength(0);
        initViews(context);

    }

    /**
     * 初始化参数
     */
    private void initViews(Context context) {

        mScroller = new Scroller(context);
    }

    /**
     * activity的顶级view是DecorView，所以这里在DecorView的下一级包装了一层SlidingLayout
     * @param activity
     */
    public void replaceCurrentLayout(Activity activity){

        mActivity = activity;
        ViewGroup decorView= (ViewGroup) mActivity.getWindow().getDecorView();
        View child = decorView.getChildAt(0);   //我们DecorView包裹的布局
        decorView.removeView(child);
        this.addView(child);    //将我们DecorView包裹的布局添加到我们自定义的SlidingLayout当中
        decorView.addView(this);
    }

    private int mInterceptDownX;    //按下的位置x的坐标值
    private int mLastInterceptX;    //最后的触摸位置x坐标的值
    private int mLastInterceptY;    //最后的触摸位置y坐标的值

    /**
     * 根据手指移动的距离判断是否拦截触摸事件
     *
     * @param ev
     * @return
     */
    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev) {
        super.onInterceptTouchEvent(ev);
        int x = (int) ev.getX();
        int y = (int) ev.getY();
        boolean mIntercept = false;
        switch (ev.getAction()) {
            case MotionEvent.ACTION_DOWN:

                mInterceptDownX = x;
                mLastInterceptX = x;
                mLastInterceptY = y;
                break;
            case MotionEvent.ACTION_MOVE:

                int moveX = x - mLastInterceptX;
                int moveY = y - mLastInterceptY;
                //按下的位置的X位置小于屏幕的十分之一，并且x移动的距离大于y移动的距离，就拦截
                if (Math.abs(moveX) > Math.abs(moveY) + 5) {
                    mIntercept = true;
                } else {
                    mIntercept = false;
                }
                Log.d("tag", "mInterceptDownX:" + mInterceptDownX + "mLastInterceptX:" + mLastInterceptX + "x:" + x + "moveX:" + moveX + "moveY" + moveY + "mIntercept:" + mIntercept);
                mLastInterceptX = x;
                mLastInterceptY = y;

                break;
            case MotionEvent.ACTION_UP: //抬起的时候重置参数
                mIntercept = false;
                mInterceptDownX = mLastInterceptX = mLastInterceptY = 0;
                break;
        }
        return mIntercept;
    }

    private int mTouchDownX;
    private int mLastTouchX;
    private int mLastTouchY;

//    @Override
//    public boolean onTouchEvent(MotionEvent event) {
//        return super.onTouchEvent(event);
//        boolean mConsumed = false;
//        int x = (int) event.getX();
//        int y = (int) event.getY();
//        switch (event.getAction()) {
//            case MotionEvent.ACTION_DOWN:
//
//                mTouchDownX = x;
//                mLastTouchX = x;
//                mLastTouchY = y;
//                break;
//            case MotionEvent.ACTION_MOVE:
//
//                int moveX = x - mLastTouchX;
//                int moveY = y - mLastTouchY;
//                if (mTouchDownX < (getWidth() / 10) && Math.abs(moveX) > Math.abs(moveY) && !mConsumed) {
//                    mConsumed = true;
//                }
//                if (mConsumed) {
//                    int rightMoveX = (int) (mLastTouchX - event.getX());
//                    if ((getScrollX() + rightMoveX) > 0) {  //向左滑动的时候，getScrollX()和rightMoveX都大于0，所以禁止滑动
//                        scrollTo(0, 0);
//                    } else {
//                        scrollBy(rightMoveX, 0);
//                    }
//                }
//                mLastTouchX = x;
//                mLastTouchY = y;
//                break;
//            case MotionEvent.ACTION_UP:
//
//                mConsumed = false;
//                mTouchDownX = mLastTouchX = mLastTouchY = 0;
//                if(-getScrollX()<getWidth()/2){ //偏移量不到屏幕宽度的一般，就回到最初的位置
//                    scrollBack();
//                }else{
//                    scrollFinish();
//                }
//                break;
//            case MotionEvent.ACTION_CANCEL:
//                mConsumed = false;
//                mTouchDownX = mLastTouchX = mLastTouchY = 0;
//                if(-getScrollX()<getWidth()/2){ //偏移量不到屏幕宽度的一般，就回到最初的位置
//                    scrollBack();
//                }else{
//                    scrollFinish();
//                }
//                break;
//        }
//        return true;
//    }


    /**
     * 滑动到最初的位置
     */
    private void scrollBack() {
        int startX = getScrollX();
        int dx = -getScrollX();
        mScroller.startScroll(startX, 0, dx, 0, 300);
        invalidate();
    }

    /**
     * 向右滑动关闭
     */
    private void scrollFinish(){
        int dx = -getScrollX() - getWidth();
        mScroller.startScroll(getScrollX(),0,dx,0,300);
        invalidate();
    }

//    @Override
//    public void computeScroll() {
//
//        if(mScroller.computeScrollOffset()){
//            scrollTo(mScroller.getCurrX(),0);
//            postInvalidate();
//        }else if(-getScrollX() >= getWidth()){
//            mActivity.finish();
//        }
//    }

    //获取屏幕的宽度
    private float getScreenWidth() {
        return getResources().getDisplayMetrics().widthPixels;
    }

    /**
     * 布局解析完毕的时候
     */
    @Override
    protected void onFinishInflate() {
        super.onFinishInflate();
        ViewGroup container = (ViewGroup) getChildAt(0);
        if (container.getChildCount() > 2) {
            throw new IllegalStateException("SlidingLayout中只能放两个子View");
        }
        //获取左侧菜单view
        leftView = (ViewGroup) container.getChildAt(0);
        //获取主布局的Viwe
        ViewGroup contentView = (ViewGroup) container.getChildAt(1);
        //设置子view 的宽度
        leftView.getLayoutParams().width = leftWidth;
        contentView.getLayoutParams().width = (int) getScreenWidth();

        //移除父布局
        container.removeView(contentView);
        FrameLayout frameLayout = new FrameLayout(context);
        frameLayout.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT));
        frameLayout.addView(contentView);
        container.addView(frameLayout);
    }

    /**
     * 该方法在滑动的时候会不断的调用
     *
     * @param l    : left
     * @param t    : top
     * @param oldl : old left
     * @param oldt : old top
     */
    @Override
    protected void onScrollChanged(int l, int t, int oldl, int oldt) {
        super.onScrollChanged(l, t, oldl, oldt);
        float x = l * 0.6f;//偏移量
        leftView.setTranslationX(x);//平移
    }

    @Override
    public boolean onTouchEvent(MotionEvent ev) {
        switch (ev.getAction()) {
            case MotionEvent.ACTION_UP://手指抬起的时候判断是否关闭
                int currentX = getScrollX();
                if (isOpenMenu) {
                    if (currentX >= leftWidth / 3) {
                        closeMenu();
                    } else {
                        openMenu();
                    }
                    //点击关闭
                    float x = ev.getX();
                    if (x > leftWidth) {
                        closeMenu();
                    }
                    return true;
                } else {//关闭状态
                    if (currentX < leftWidth * 2 / 3) {
                        openMenu();
                    } else {
                        closeMenu();

                    }
                    return true;
                }

        }
        return super.onTouchEvent(ev);

    }

    public boolean isOpenMenu() {
        return isOpenMenu;
    }

    /**
     * 关闭菜单
     */
    public void closeMenu() {
        isOpenMenu = false;
        smoothScrollTo(leftWidth, 0);// 250ms
    }

    /**
     * 打开菜单
     */
    public void openMenu() {
        isOpenMenu = true;
        smoothScrollTo(0, 0);
    }

    /**
     * 改变菜单开启状态
     */
    public void changeMenu() {
        if (isOpenMenu) {
            this.closeMenu();
        } else {
            this.openMenu();
        }
    }
}
