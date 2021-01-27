//
//  QMAccountInfo.h
//  MotherMoney
//
//  Created by on 14-8-9.
//  Copyright (c) 2014年. All rights reserved.
//

#import <Foundation/Foundation.h>
//个人账户信息

#define QM_USER_ID_KEY @"userId"
#define QM_USER_NAME_KEY @"userName"//用户姓名
#define QM_USER_NICK_NAME_KEY @"userNickName"
#define QM_PHONE_NUMBER_KEY @"phoneNumber"
#define QM_ICON_URL_KEY @"iconUrl"
#define QM_USER_PASSWORD_KEY @"password"
#define QM_RECT_PASSWORD_KEY @"rectPassword"
#define QM_PASSSORD_KEY @"password"
#define QM_HAS_PAY_PASSWORD_KEY @"isHasPayPwd"
#define QM_HAS_REAL_NAME_AUTHENTICATED @"authenticated" // 是否实名认证
#define QM_USER_IDCARD_NUMBER @"idCardNumber"
@interface QMAccountInfo : NSObject
@property (nonatomic, strong) NSString *userId; // 用户ID
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userNickName; // 用户昵称
@property (nonatomic, strong) NSString *phoneNumber; // 同时也是账户名字
@property (nonatomic, strong) NSString *iconUrl;// 头像URL
@property (nonatomic, strong) NSString *password; // 账户密码
@property (nonatomic, strong) NSString *recPwd; // 手势密码

@property (nonatomic, assign) BOOL isHasPayPwd; // 是否有支付密码
@property (nonatomic, assign) BOOL isUsingRecPwd; // 是否在使用手势密码
@property (nonatomic, assign) BOOL isLogin; // 用户是否登录
@property (nonatomic, assign) BOOL isRemember; // 是否有记住密码选项
@property (nonatomic, assign) BOOL isAuthenticated;
@property (nonatomic, assign) BOOL hasRealName;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *identifierCardId;
@property (nonatomic, assign) BOOL salesman;
@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, strong) NSString *customerCount;
@property (nonatomic, strong) NSString *openAccountStatus;


- (id)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)dictAccountInfo;

@end


