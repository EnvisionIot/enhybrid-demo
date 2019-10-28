package com.envision.demo;

import com.envision.demo.bean.EnvResponse;
import com.envision.demo.bean.LoginUser;
import com.envision.demo.bean.User;
import com.envisioncn.cordova.webContainer.CookieSyncUtils;

import java.io.IOException;

import okhttp3.Cookie;
import okhttp3.HttpUrl;
import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import retrofit2.Call;
import retrofit2.Retrofit;
import retrofit2.converter.jackson.JacksonConverterFactory;
import retrofit2.http.Body;
import retrofit2.http.POST;

import static com.envision.demo.MyApplication.BASE_URL;


public interface EnvService {

    @POST("/app-portal/api/v1/login")
    Call<EnvResponse<User>> login(@Body LoginUser user);

    class Builder {
        private Retrofit.Builder mRetrofitBuilder;

        public Builder() {
            this(BASE_URL);
        }

        public Builder(String baseUrl) {
            OkHttpClient client = new OkHttpClient.Builder()
                .addInterceptor(new CookieInterceptor())
                .build();
//            client.interceptors().add(new CookieInterceptor());
            mRetrofitBuilder = new Retrofit.Builder()
                .client(client).baseUrl(baseUrl)
                .addConverterFactory(JacksonConverterFactory.create());
        }

        public Builder baseUrl(String baseUrl) {
            mRetrofitBuilder.baseUrl(baseUrl);
            return this;
        }

        public EnvService create() {
            return mRetrofitBuilder.build().create(EnvService.class);
        }
    }

    class CookieInterceptor implements Interceptor {

        @Override
        public Response intercept(Chain chain) throws IOException {
            // 设置 Cookie
            Request userRequest = chain.request();
            Request.Builder requestBuilder = userRequest.newBuilder();
            requestBuilder.addHeader("Content-Type", "application/json");

            // 存储 cookie
            Response originalResponse = chain.proceed(requestBuilder.build());
            if (!originalResponse.headers("Set-Cookie").isEmpty()) {
                HttpUrl url = userRequest.url();
                for (String cookieStr : originalResponse.headers("Set-Cookie")) {
                    Cookie cookie = Cookie.parse(url, cookieStr);
                    CookieSyncUtils.syncCookie(MyApplication.APP_CONTEXT, BASE_URL,cookie.name() + "=" + cookie.value());
                }
            }
            return originalResponse;
        }
    }
}
