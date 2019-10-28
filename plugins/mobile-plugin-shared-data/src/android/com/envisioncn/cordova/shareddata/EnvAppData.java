package com.envisioncn.cordova.shareddata;

import android.content.Context;
import android.content.SharedPreferences;
import android.text.TextUtils;
import android.util.Log;
import android.webkit.ValueCallback;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.LinkedList;
import java.util.List;
import java.util.Locale;

/**
 * 应用全局的共享数据，可以用来在native和webview, webview和webview之间交换数据
 */
public class EnvAppData {
    private static final String TAG = EnvAppData.class.getSimpleName();

    // 共享数据挂载点
    private static final String ROOT_OBJECT = "window.global";

    private static final String SP_NAME = "EnvAppData";

    private IJavaScriptRuntime jsContext = null;
    private Context context = null;
    private boolean isInitialized = false;
    private JSONObject initialState = null;
    private List<QueryOperation> taskQueue = new LinkedList<QueryOperation>();
    private boolean isExecuting = false;
    private static EnvAppData instance = null;

    private EnvAppData(Context context){
        this.context = context;
        jsContext = new WebKitJSRunner(context);
        jsContext.evaluateJavascript("window.global = {}", null);
    }

    public static synchronized EnvAppData getInstance(){
        if(instance == null){
            throw new RuntimeException("Should invoke create method before use EnvAppData");
        }
        return instance;
    }

    public static synchronized void create(Context context){
        if(instance == null){
            instance = new EnvAppData(context);
        }
    }

    public boolean isInitialized(){
        return isInitialized;
    }

    public synchronized void terminate(){
        instance = null;
        if(jsContext != null){
            jsContext.terminate();
        }
    }

    private synchronized void addOperation(QueryOperation operation){
        taskQueue.add(operation);
        if(!isExecuting){
            executePendingOperations();
        }
    }

    private synchronized void executePendingOperations(){
        while (taskQueue.size() > 0){
            isExecuting = true;
            final QueryOperation operation = taskQueue.remove(0);
            final IJSValueCallback callback = operation.getCallback();
            switch (operation.getType()){
                case GET:
                    this._getItem(operation.getKey(), new IJSValueCallback() {
                        @Override
                        public void onResolveValue(Object value) {
                            if(callback != null){
                                callback.onResolveValue(value);
                            }
                        }
                    });
                    break;
                case SET:
                    this._setItem(operation.getKey(), operation.getData(), new IJSValueCallback() {
                        @Override
                        public void onResolveValue(Object value) {
                            if(callback != null){
                                callback.onResolveValue(value);
                            }
                        }
                    });
                    break;
                case REMOVE:
                    this._removeItem(operation.getKey(), new IJSValueCallback() {
                        @Override
                        public void onResolveValue(Object value) {
                            if(callback != null){
                                callback.onResolveValue(value);
                            }
                        }
                    });
                    break;
                case INIT:
                    this._initialize((JSONObject)operation.getData(), new IJSValueCallback() {
                        @Override
                        public void onResolveValue(Object value) {
                            if(callback != null){
                                callback.onResolveValue(value);
                            }
                        }
                    });
                    break;
                case RESET:
                    this._resetState((JSONObject) operation.getData(), new IJSValueCallback() {
                        @Override
                        public void onResolveValue(Object value) {
                            if(callback != null){
                                callback.onResolveValue(value);
                            }
                        }
                    });
                    break;
                default:
                    break;
            }
        }
        isExecuting = false;
    }

    /**
     * 初始化数据, web层在页面加载时会将初始store同步到js运行时
     * 不可以在Native 层调用！！！！
     * @param rootObject
     * @param callback
     */
    public synchronized void initialize(JSONObject rootObject, IJSValueCallback callback){
        Log.v(TAG, "@@@@@ initialize EnvAppData");
        initialState = rootObject;
        addOperation(new QueryOperation(QueryOperation.QueryOperationType.INIT, "/", rootObject, callback));
    }

    private synchronized void _initialize(JSONObject rootObject, final IJSValueCallback callback){
        String stringifiedValue = (rootObject).toString();
        // 合并js运行时中的全局状态（window.global）到rootObject（初始store）中
        String jsExpression = String.format("%s = Object.assign({}, JSON.parse(\'%s\'), %s); ", new Object[]{"window.global", stringifiedValue, "window.global"});
        jsContext.evaluateJavascript(jsExpression, new ValueCallback<String>() {
            @Override
            public void onReceiveValue(String value) {
                isInitialized = true;
                if(callback != null){
                    callback.onResolveValue(value);
                }
            }
        });
    }

    /**
     * 将AppData重置到上次initialize的状态
     * @param callback
     */
    public synchronized void resetState(IJSValueCallback callback){
        Log.v(TAG, "@@@@@ resetState");
        if(initialState != null){
            addOperation(new QueryOperation(QueryOperation.QueryOperationType.RESET, "/", initialState, callback));
        }
    }

    private synchronized void _resetState(JSONObject rootObject, final IJSValueCallback callback){
        String stringfiedValue = (rootObject).toString();
        String jsExpression = String.format("%s = JSON.parse('%s'); ", ROOT_OBJECT, stringfiedValue);
        jsContext.evaluateJavascript(jsExpression, new ValueCallback<String>() {
            @Override
            public void onReceiveValue(String value) {
                isInitialized = true;
                if (callback != null) {
                    callback.onResolveValue(value);
                }
            }
        });
    }

    public synchronized void setItem(String key, Object value, IJSValueCallback callback){
        Log.v(TAG, "@@@@@ setItem: " + key);
        addOperation(new QueryOperation(QueryOperation.QueryOperationType.SET, key, value, callback));
    }

    private synchronized void _setItem(final String key, Object value, final IJSValueCallback callback){
        String firstPath = keyToFirstPath(key);
        String firstPathExpression = firstPath + " = " + firstPath + " || {};";
        String jsPath = keyToJsonPath(key);
        String jsExpression = null;
        if(value instanceof String){
            jsExpression = jsPath + " = '" + value + "'";   // 防止value中有特殊字符（-，+等）影响js执行
            //jsExpression = String.format("%s = %s", jsPath, value);
        }else if(value instanceof JSONObject){
            jsExpression = jsPath + " = JSON.parse('" + ( escapeSpecialCharacters(((JSONObject)value).toString())) +"')";
        }else if(value instanceof JSONArray){
            jsExpression = jsPath + " = JSON.parse('" + ( escapeSpecialCharacters(((JSONArray)value).toString())) +"')";
        }else if(value instanceof Boolean || value instanceof Integer || value instanceof Float || value instanceof Double){
            jsExpression = jsPath + " = " + value;
        }else{
            Log.e(TAG, "@@@ invalid value type" + value);
        }

        if(jsExpression != null){
            jsContext.evaluateJavascript(firstPathExpression + jsExpression, new ValueCallback<String>() {
                @Override
                public void onReceiveValue(String value) {
                    Log.v(TAG, "@@@@@ setItem with " + key +" succeed");
                    if(callback != null){
                        callback.onResolveValue(value);
                    }
                }
            });
        }
    }

    public synchronized void getItem(final String key, final IJSValueCallback valueCallback){
        Log.v(TAG, "@@@@@ getItem: " + key);
        addOperation(new QueryOperation(QueryOperation.QueryOperationType.GET, key, null, valueCallback));
    }

    private synchronized void _getItem(final String key, final IJSValueCallback valueCallback){
        String jsPath = keyToJsonPath(key);
        /* 不可直接写String.format("%s ? ({type: %s.constructor.name, value: %s}) :
         {type: \"String\", value: \"null\"}",new Object[]{jsPath, jsPath, jsPath});
         否则在数据为boolean类型且值为false时，会执行第二个选项。
         */
        String jsExpression = String.format("(%s !== null && %s !== undefined) ? ({type: %s.constructor.name, value: %s}) : {type: \"String\", value: \"null\"}" , jsPath, jsPath,  jsPath, jsPath);

        jsContext.evaluateJavascript(jsExpression, new ValueCallback<String>() {
            @Override
            public void onReceiveValue(String value) {
                if (valueCallback != null && value != null && value.length() > 0) {
                    try {
                        JSONObject resultObject = new JSONObject(value);
                        String type = resultObject.getString("type");
                        if ("String".equals(type) && resultObject.has("value")) {
                            String result = resultObject.getString("value");
                            valueCallback.onResolveValue(result);
                            Log.v(TAG, "@@@@@ getItem with " + key + " succeed");
                        } else if ("Object".equals(type) && resultObject.has("value")) {
                            String strJSONObject = resultObject.getString("value");
                            JSONObject result = new JSONObject(strJSONObject);
                            valueCallback.onResolveValue(result);
                            Log.v(TAG, "@@@@@ getItem with " + key + " succeed");
                        } else if ("Array".equals(type) && resultObject.has("value")) {
                            String strJSONArray = resultObject.getString("value");
                            JSONArray result = new JSONArray(strJSONArray);
                            valueCallback.onResolveValue(result);
                            Log.v(TAG, "@@@@@ getItem with " + key + " succeed");
                        } else if ("Boolean".equals(type) && resultObject.has("value")) {
                            if ("true".equalsIgnoreCase(resultObject.getString("value"))) {
                                valueCallback.onResolveValue(true);
                            } else {
                                valueCallback.onResolveValue(false);
                            }
                            Log.v(TAG, "@@@@@ getItem with " + key + " succeed");
                        } else if ("Number".equals(type) && resultObject.has("value")) {
                            String strValue = resultObject.getString("value");
                            if (strValue.indexOf('.') >= 0) {
                                valueCallback.onResolveValue(Double.parseDouble(strValue));
                            } else {
                                valueCallback.onResolveValue(Integer.parseInt(strValue));
                            }
                            Log.v(TAG, "@@@@@ getItem with " + key + " succeed");
                        } else {
                            Log.v(TAG, "@@@@@ getItem with " + key + " with unknow type");
                            valueCallback.onResolveValue(null);
                        }
                    } catch (JSONException e) {
                        Log.e(TAG, "", e);
                        valueCallback.onResolveValue(null);
                    }
                }
            }
        });
    }

    public synchronized void removeItem(final String key, final IJSValueCallback callback) {
        Log.v(TAG, "@@@@@ removeItem: " + key);
        addOperation(new QueryOperation(QueryOperation.QueryOperationType.REMOVE, key, null, callback));
    }

    private synchronized void _removeItem(final String key, final IJSValueCallback callback){
        keyToJsonPath(key, new ILastComponentCallback() {
            @Override
            public void callbackLastComponent(String jsPath, String parent, boolean isNumber, int index) {
                if (!isNumber) {
                    // 如果是删除对象，调用delete方法
                    jsContext.evaluateJavascript("delete " + jsPath, new ValueCallback<String>() {
                        @Override
                        public void onReceiveValue(String value) {
                            Log.v(TAG, "@@@ removeItem with " + value + " succeed");
                            if (callback != null) {
                                callback.onResolveValue(value);
                            }
                        }
                    });
                } else {
                    // 如果是删除数组元素，对父元素调用 splice方法
                    jsContext.evaluateJavascript(String.format("%s.splice( %d , 1)", parent, index), new ValueCallback<String>() {
                        @Override
                        public void onReceiveValue(String value) {
                            Log.v(TAG, "@@@ removeItem in array " + value + " succeed");
                            if (callback != null) {
                                callback.onResolveValue(value);
                            }
                        }
                    });
                }
            }
        });
    }
    /**
     *  将key转换成json的路径 , eg: /login/codes/0/zh_desc => this.global.login.codes[0].zh_desc
     *  @param key
     *  @return json path
     */
    private String keyToJsonPath(String key){
        return keyToJsonPath(key, null);
    }

    /**
     *  获取第一级key，对应reducer名字，当第一级在window.global下不存在时，先创建。为多页面下的Store共享适配
     *  @param key
     *  @return json path
     */
    private String keyToFirstPath(String key){
        if(key ==null || key.length() <=0 ){
            return null;
        }
        // key对应模型的路径,必须以‘/’开头, 如果不是以‘/’开头，程序默认补齐
        if(!key.startsWith("/")){
            key = "/" + key;
        }
        String [] components = key.split("/");
        return ROOT_OBJECT + '.' + components[1];
    }

    /**
     *  将model路径转换成json的路径 , eg: /login/codes/0/zh_desc => this.global.login.codes[0].zh_desc
     *  @param key model路径
     *  @param callback
     *  @return json path
     */
    private String keyToJsonPath(String key, ILastComponentCallback callback){
        if(key ==null || key.length() <=0 ){
            return null;
        }
        // key对应模型的路径,必须以‘/’开头, 如果不是以‘/’开头，程序默认补齐
        if(!key.startsWith("/")){
            key = "/" + key;
        }
        String [] components = key.split("/");
        StringBuilder resultBuilder = new StringBuilder("");
        String result = "";
        String parent = "";
        String dotStr = ".";
        boolean isNum = false;
        int index = -1;
        for(int i = 0; i < components.length ; i++ ){
            if(i == 0){
                resultBuilder.append(ROOT_OBJECT);
            }else{
                String component = components[i];
                if(component.length()>0){
                    if(TextUtils.isDigitsOnly(component)){
                        if( i == components.length -1 && callback != null){
                            parent = new String(resultBuilder);
                            isNum = true;
                            index = Integer.parseInt(component);
                        }
                        resultBuilder.append(String.format(Locale.getDefault(),"[%d]", Integer.parseInt(component)));
                    }else{
                        if( i == components.length -1 && callback != null){
                            parent = new String(resultBuilder);
                        }
                        resultBuilder.append(dotStr).append(component);
                    }
                }
            }
        }
        result = resultBuilder.toString();
        if(callback != null){
            callback.callbackLastComponent(result, parent, isNum, index);
        }
        return result;
    }

    /**
     * 特殊JSON字符转义, 是否可以只做一个转义
     * @param originalString
     * @return
     */
    private String escapeSpecialCharacters(String originalString){
        String resultString = originalString;
        String[] specialCharacters = { "\\0", "\\b", "\\f", "\\n", "\\r", "\\t", "\\v", "\\'", "\\\"", "\\\\" };
        String[] escapedCharacters = { "\\\\0", "\\\\b", "\\\\f", "\\\\n", "\\\\r", "\\\\t", "\\\\v", "\\\\'", "\\\\\"", "\\\\\\\\" };
        for(int i = 0; i < specialCharacters.length; i++){
            if(originalString.contains(specialCharacters[i])){
                resultString = resultString.replace(specialCharacters[i], escapedCharacters[i]);
            }
        }
        return resultString;
    }

    public synchronized void getPersistentItem(final String key, final IJSValueCallback valueCallback){
        Log.v(TAG, "@@@@@ getPersistentItem: " + key);
        SharedPreferences sharedPreferences = this.context.getSharedPreferences(SP_NAME, Context.MODE_PRIVATE); //私有数据
        valueCallback.onResolveValue(sharedPreferences.getAll().get(key));
    }

    public synchronized void savePersistentItem(String key, Object value, IJSValueCallback callback){
        Log.v(TAG, "@@@@@ savePersistentItem: " + key);
        SharedPreferences sharedPreferences = this.context.getSharedPreferences(SP_NAME, Context.MODE_PRIVATE); //私有数据
        SharedPreferences.Editor editor = sharedPreferences.edit();//获取编辑器
        if(value instanceof String){
            editor.putString(key, (String) value);
        }else if(value instanceof Integer){
            editor.putInt(key, (Integer) value);
        }else if(value instanceof Long){
            editor.putLong(key, (Long) value);
        }else if(value instanceof Long){
            editor.putBoolean(key, (Boolean) value);
        }else if(value instanceof Float){
            editor.putFloat(key, (Float) value);
        }
        editor.commit();//提交修改
        callback.onResolveValue(value);
    }

    public synchronized void removePersistentItem(final String key, final IJSValueCallback callback) {
        Log.v(TAG, "@@@@@ removePersistentItem: " + key);
        SharedPreferences sharedPreferences = this.context.getSharedPreferences(SP_NAME, Context.MODE_PRIVATE); //私有数据
        SharedPreferences.Editor editor = sharedPreferences.edit();//获取编辑器
        editor.remove(key);
        editor.commit();//提交修改
        callback.onResolveValue((String) sharedPreferences.getString(key, ""));
    }

    public synchronized void getNameSpaceItem(String nameSpace, String key, IJSValueCallback valueCallback){
        SharedPreferences sharedPreferences = this.context.getSharedPreferences(nameSpace, Context.MODE_PRIVATE); //私有数据
        valueCallback.onResolveValue(sharedPreferences.getAll().get(key));
    }

    public synchronized void saveNameSpaceItem(String nameSpace, String key, Object value, IJSValueCallback callback){
        SharedPreferences sharedPreferences = this.context.getSharedPreferences(nameSpace, Context.MODE_PRIVATE); //私有数据
        SharedPreferences.Editor editor = sharedPreferences.edit();//获取编辑器
        if(value instanceof String){
            editor.putString(key, (String) value);
        }else if(value instanceof Integer){
            editor.putInt(key, (Integer) value);
        }else if(value instanceof Long){
            editor.putLong(key, (Long) value);
        }else if(value instanceof Long){
            editor.putBoolean(key, (Boolean) value);
        }else if(value instanceof Float){
            editor.putFloat(key, (Float) value);
        }
        editor.commit();//提交修改
        callback.onResolveValue(value);
    }

    public synchronized void removeNameSpaceItem(String nameSpace, String key, IJSValueCallback callback) {
        SharedPreferences sharedPreferences = this.context.getSharedPreferences(nameSpace, Context.MODE_PRIVATE); //私有数据
        SharedPreferences.Editor editor = sharedPreferences.edit();//获取编辑器
        editor.remove(key);
        editor.commit();//提交修改
        callback.onResolveValue("");
    }

    public synchronized void removeNameSpaceAllItem(String nameSpace, IJSValueCallback callback) {
        SharedPreferences sharedPreferences = this.context.getSharedPreferences(nameSpace, Context.MODE_PRIVATE); //私有数据
        SharedPreferences.Editor editor = sharedPreferences.edit();//获取编辑器
        editor.clear();
        editor.commit();//提交修改
        callback.onResolveValue("");
    }

}

interface ILastComponentCallback{
    void callbackLastComponent(String jsPath, String parent, boolean isNumber, int index);
}