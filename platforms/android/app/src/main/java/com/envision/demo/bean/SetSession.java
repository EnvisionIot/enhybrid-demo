package com.envision.demo.bean;

public class SetSession {
    private String userId;
    private String userName;
    private String workingOrganizationId;
    private String workingOrganizationName;
    private String accessToken;
    private String refreshToken;
    private String refreshTokenExpire;

    public String getUserId() {
        return userId;
    }

    public SetSession(String userId, String userName, String workingOrganizationId, String workingOrganizationName, String accessToken, String refreshToken, String refreshTokenExpire) {
        this.userId = userId;
        this.userName = userName;
        this.workingOrganizationId = workingOrganizationId;
        this.workingOrganizationName = workingOrganizationName;
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
        this.refreshTokenExpire = refreshTokenExpire;
    }

    public SetSession() {
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getWorkingOrganizationId() {
        return workingOrganizationId;
    }

    public void setWorkingOrganizationId(String workingOrganizationId) {
        this.workingOrganizationId = workingOrganizationId;
    }

    public String getWorkingOrganizationName() {
        return workingOrganizationName;
    }

    public void setWorkingOrganizationName(String workingOrganizationName) {
        this.workingOrganizationName = workingOrganizationName;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public String getRefreshToken() {
        return refreshToken;
    }

    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }

    public String getRefreshTokenExpire() {
        return refreshTokenExpire;
    }

    public void setRefreshTokenExpire(String refreshTokenExpire) {
        this.refreshTokenExpire = refreshTokenExpire;
    }
}
