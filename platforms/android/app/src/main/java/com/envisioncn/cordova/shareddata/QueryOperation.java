package com.envisioncn.cordova.shareddata;

/**
 * Created by chao.xu on 16/3/27.
 */
public class QueryOperation {

    private String key;
    private QueryOperationType type;
    private IJSValueCallback callback;
    private Object data;

    public QueryOperation(QueryOperationType type, String key, Object data, IJSValueCallback callback) {
        this.type = type;
        this.key = key;
        this.data = data;
        this.callback = callback;
    }

    public String getKey() {
        return key;
    }

    public QueryOperationType getType() {
        return type;
    }

    public Object getData() {
        return data;
    }

    public IJSValueCallback getCallback() {
        return callback;
    }

    public enum QueryOperationType {
        GET,
        SET,
        REMOVE,
        INIT,
        RESET
    }
}

