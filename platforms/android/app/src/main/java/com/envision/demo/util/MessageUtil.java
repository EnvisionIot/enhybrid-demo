package com.envision.demo.util;

import android.content.Context;
import android.support.v7.app.AlertDialog;
import android.view.View;
import android.widget.TextView;

import com.envision.demo.R;


public class MessageUtil {
    /**
     * 生成正常无图片toast
     *
     * @param context
     * @param info
     */
    public static void info(Context context, String info, String detail) {
        showMessageDialog(context, info, detail);
    }

    /**
     * 生成笑脸toas
     *
     * @param context
     * @param info
     */
    public static void success(Context context, String info, String detail) {
        showMessageDialog(context, info, detail);
    }

    /**
     * 生成哭脸toast
     *
     * @param context
     * @param info
     */
    public static void error(Context context, String info, String detail) {
        showMessageDialog(context, info, detail);
    }

    private static void showMessageDialog(Context context, String info, String detail) {
        View layout = View.inflate(context, R.layout.dialog_message, null);
        TextView tvMessage = layout.findViewById(R.id.tv_message);
        TextView tvMessageDetail = layout.findViewById(R.id.tv_message_detail);
        tvMessage.setText(info);
        tvMessageDetail.setText(detail);
        final AlertDialog dialog = new AlertDialog.Builder(context)
            .setView(layout)
            .create();
        layout.findViewById(R.id.btn_ok).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.hide();
            }
        });
        dialog.show();
    }
}
