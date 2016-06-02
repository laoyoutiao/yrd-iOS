//
//  QMAccountInfo.m
//  MotherMoney
//
//  Created by on 14-8-9.
//  Copyright (c) 2014年. All rights reserved.
//

#import "QMAccountInfo.h"

@implementation QMAccountInfo

- (id)initWithDictionary:(NSDictionary *)dict {
    //
    if (self = [super init]) {
        self.userId = [dict objectForKey:QM_USER_ID_KEY];
        self.userName = [dict objectForKey:QM_USER_NAME_KEY];
        self.userNickName = [dict objectForKey:QM_USER_NICK_NAME_KEY];
        self.phoneNumber = [dict objectForKey:QM_PHONE_NUMBER_KEY];
        self.iconUrl = [dict objectForKey:QM_ICON_URL_KEY];
        self.isHasPayPwd = [[dict objectForKey:QM_HAS_PAY_PASSWORD_KEY] boolValue];
        self.isAuthenticated = [[dict objectForKey:QM_HAS_REAL_NAME_AUTHENTICATED] boolValue];
        self.identifierCardId = [dict objectForKeyedSubscript:QM_USER_IDCARD_NUMBER];
    }
    
    return self;
}

- (NSDictionary *)dictAccountInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (!QM_IS_STR_NIL(self.userId)) {
        [dict setObject:self.userId forKey:QM_USER_ID_KEY];
    }
    if (!QM_IS_STR_NIL(self.identifierCardId)) {
        [dict setObject:self.identifierCardId forKey:QM_USER_IDCARD_NUMBER];
    }
    
    if (!QM_IS_STR_NIL(self.userName)) {
        [dict setObject:self.userName forKey:QM_USER_NAME_KEY];
    }
    
    if (!QM_IS_STR_NIL(self.userNickName)) {
        [dict setObject:self.userNickName forKey:QM_USER_NICK_NAME_KEY];
    }
    
    if (!QM_IS_STR_NIL(self.iconUrl)) {
        [dict setObject:self.iconUrl forKey:QM_ICON_URL_KEY];
    }
    
    if (!QM_IS_STR_NIL(self.password)) {
        [dict setObject:self.password forKey:QM_USER_PASSWORD_KEY];
    }
    
    if (!QM_IS_STR_NIL(self.recPwd)) {
        [dict setObject:self.recPwd forKey:QM_RECT_PASSWORD_KEY];
    }
    
    if (!QM_IS_STR_NIL(self.phoneNumber)) {
        [dict setObject:self.phoneNumber forKey:QM_PHONE_NUMBER_KEY];
    }
    [dict setObject:[NSNumber numberWithBool:self.isAuthenticated] forKey:QM_HAS_REAL_NAME_AUTHENTICATED];
    
    [dict setObject:[NSNumber numberWithBool:self.isHasPayPwd] forKey:QM_HAS_PAY_PASSWORD_KEY];
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (BOOL)isUsingRecPwd {
    return !QM_IS_STR_NIL(self.recPwd);
}

- (BOOL)isLogin {
    return !QM_IS_STR_NIL(self.password);
}

@end
