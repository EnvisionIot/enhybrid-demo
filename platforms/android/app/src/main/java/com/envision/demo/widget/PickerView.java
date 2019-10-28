package com.envision.demo.widget;

import android.app.Activity;
import android.content.Context;
import android.content.res.ColorStateList;
import android.support.annotation.StringRes;
import android.support.v7.widget.RecyclerView;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.TextView;


import com.envision.demo.R;

import java.util.ArrayList;
import java.util.List;

public class PickerView<T> {

    private ViewGroup mDecorView;

    private ViewGroup mRootView;
    private ViewGroup mContentView;
    private TextView tvTitle;

    private OptionAdapter mAdapter;

    private OnItemClickListener mItemClickListener;
    private OnDismissListener mDismissListener;

    private boolean isShowing = false;
    private boolean isDismissing = false;

    private Animation inAnim;
    private Animation outAnim;

    private View.OnKeyListener onKeyBackListener = new View.OnKeyListener() {
        @Override
        public boolean onKey(View v, int keyCode, KeyEvent event) {
            if (keyCode == KeyEvent.KEYCODE_BACK && event.getAction() == MotionEvent.ACTION_DOWN
                && isShowing) {
                dismiss();
                return true;
            }
            return false;
        }
    };

    private final View.OnTouchListener onCancelableTouchListener = new View.OnTouchListener() {
        @Override
        public boolean onTouch(View v, MotionEvent event) {
            if (event.getAction() == MotionEvent.ACTION_DOWN) {
                dismiss();
            }
            return false;
        }
    };

    private final View.OnTouchListener onContentTouchListener = new View.OnTouchListener() {
        @Override
        public boolean onTouch(View v, MotionEvent event) {
            return event.getAction() == MotionEvent.ACTION_DOWN;
        }
    };

    public PickerView(Context context) {
        mDecorView = ((Activity) context).getWindow().getDecorView().findViewById(android.R.id.content);

        mRootView = (ViewGroup) LayoutInflater.from(context).inflate(R.layout.view_picker, mDecorView, false);
        mContentView = mRootView.findViewById(R.id.ll_content_container);
        tvTitle = mRootView.findViewById(R.id.tv_title);
        View tvClose = mRootView.findViewById(R.id.eiv_close);
        tvClose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });

        RecyclerView rvOptions = mRootView.findViewById(R.id.rv_options);
        mAdapter = new OptionAdapter();
        rvOptions.setAdapter(mAdapter);

        inAnim = AnimationUtils.loadAnimation(context, R.anim.pickerview_slide_in_bottom);
        outAnim = AnimationUtils.loadAnimation(context, R.anim.pickerview_slide_out_bottom);
        outAnim.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {}

            @Override
            public void onAnimationEnd(Animation animation) {
                PickerView.this.onDetached();
            }

            @Override
            public void onAnimationRepeat(Animation animation) {}
        });

        setKeyBackCancelable(true);
        setOutSideCancelable(true);
    }

    public void setTitle(CharSequence title) {
        tvTitle.setText(title);
    }

    public void setTitle(@StringRes int title) {
        tvTitle.setText(title);
    }

    public void setOptions(List<T> options) {
        mAdapter.replaceData(options);
    }

    public void setSelectOption(int position) {
        mAdapter.setSelected(position, false);
    }

    public void setOnItemClickListener(OnItemClickListener itemClickListener) {
        mItemClickListener = itemClickListener;
    }

    public void setOnDismissListener(OnDismissListener dismissListener) {
        mDismissListener = dismissListener;
    }

    public void setKeyBackCancelable(boolean isCancelable) {
        ViewGroup view = mRootView;

        view.setFocusable(isCancelable);
        view.setFocusableInTouchMode(isCancelable);
        if (isCancelable) {
            view.setOnKeyListener(onKeyBackListener);
        } else {
            view.setOnKeyListener(null);
        }
    }

    public void setOutSideCancelable(boolean isCancelable) {
        if (mRootView != null) {
            View view = mRootView.findViewById(R.id.mask_container);

            if (isCancelable) {
                view.setOnTouchListener(onCancelableTouchListener);
                mContentView.setOnTouchListener(onContentTouchListener);
            } else {
                view.setOnTouchListener(null);
                mContentView.setOnTouchListener(null);
            }
        }
    }

    public void show() {
        if (!isShowing) {
            isShowing = true;
            isDismissing = false;
            onAttached();
            mRootView.requestFocus();
        }
    }

    public void dismiss() {
        if (isShowing && !isDismissing) {
            mContentView.startAnimation(outAnim);
        }
    }

    private void onAttached() {
        mDecorView.addView(mRootView);
        mContentView.startAnimation(inAnim);
    }

    private void onDetached() {
        mDecorView.post(new Runnable() {
            @Override
            public void run() {
                //从根视图移除
                mDecorView.removeView(mRootView);
                isShowing = false;
                isDismissing = false;
                if (mDismissListener != null) {
                    mDismissListener.onDismiss();
                }
            }
        });
    }

    public interface IPickerViewOption {
        String getPickerViewText();
    }

    public interface OnItemClickListener {
        void onItemClick(int position);
    }

    public interface OnDismissListener {
        void onDismiss();
    }

    public class OptionAdapter extends RecyclerView.Adapter<ItemViewHolder> {
        private List<T> mItems;

        private int mSelectedPosition = -1;
        private View mSelectedView = null;

        public OptionAdapter() {
            mItems = new ArrayList<T>();
        }

        public OptionAdapter(List<T> items) {
            mItems = items;
        }

        public void replaceData(List<T> items) {
            mItems = items;
            notifyDataSetChanged();
        }

        private void setSelected(int position, boolean callback) {
            int previousPosition = mSelectedPosition;
            mSelectedPosition = position;
            if (previousPosition >= 0) {
                notifyItemChanged(previousPosition);
            }
            notifyItemChanged(position);
            if (callback && mItemClickListener != null)
                mItemClickListener.onItemClick(position);
            if (position >= 0 && position < getItemCount())
                dismiss();
        }

        @Override
        public ItemViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
            TextView view = new TextView(parent.getContext());
            view.setLayoutParams(new RecyclerView.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
            ColorStateList csl = parent.getContext().getResources().getColorStateList(R.color.picker_option_tc);
            view.setTextColor(csl);
            view.setTextSize(18);
            view.setPadding(0, 48, 0, 48);
            view.setGravity(Gravity.CENTER);
            return new ItemViewHolder(view);
        }

        @Override
        public void onBindViewHolder(final ItemViewHolder holder, int position) {
            TextView text = (TextView) holder.itemView;
            IPickerViewOption item = (IPickerViewOption) mItems.get(position);
            text.setText(item.getPickerViewText());
            if (position == mSelectedPosition)
                text.setSelected(true);
            else
                text.setSelected(false);
            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    OptionAdapter.this.setSelected(holder.getAdapterPosition(), true);
                }
            });
        }

        @Override
        public int getItemCount() {
            return mItems.size();
        }
    }

    private static class ItemViewHolder extends RecyclerView.ViewHolder {

        public ItemViewHolder(View itemView) {
            super(itemView);
        }
    }

}
