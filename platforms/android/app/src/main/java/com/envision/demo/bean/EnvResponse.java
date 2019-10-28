package com.envision.demo.bean;

public class EnvResponse<T> {

    private String code;
    private String message;
    private String detailMsg;
    private T data;

    public String getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }

    public String getDetailMsg() {
        return detailMsg;
    }

    public T getData() {
        return data;
    }
}
