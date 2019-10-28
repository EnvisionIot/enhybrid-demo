//
//  Strs.h
//  Wind
//
//  Created by xuchao on 18/3/27.
//
//

#ifndef Strs_h
#define Strs_h


#endif /* Strs_h */

#define LOGIN_ROUTE @"/login"
#define UPDATE_ROUTE @"/updating"
#define HOME_ROUTE @"/demo/index.html"

#define USER_NAME               @"username"
#define PASSWORD                @"password"

#define APPID @"appid"
#define OPENID @"openid"
#define GLOBAL_ID @"global_id"
#define DEVICEUUID @"device_uuid"
#define LOGIN_INFO @"login_info"
#define USERID @"userId"
#define USERNAME  @"userName"
#define WORKING_PRG  @"workingOrganizationId"
#define ACCESSTOKEN @"accessToken"
#define REFRESHTOKEN @"refreshToken"
#define ORGS  @"organizations"
#define AUTHORIZATION  @"Authorization"

#define USERDEFAULT_PRIFIX  @"envappdata_"

#define LANGUAGE_ZH_TO_WEB     @"zh-CN"
#define LANGUAGE_EN_TO_WEB     @"en-US"

typedef enum {
    CN = 0,
    US,
    EU
//    PPE
} EnvironmentType;

typedef enum {
    Default = 0,
    Portal,
} AuthType;


#define CURRENT_ENV @"current_env"  
#define CURRENT_AUTH_TYPE @"current_auth_type"

#define CN_SERVER @"https://app-portal-ppe1.envisioniot.com"

