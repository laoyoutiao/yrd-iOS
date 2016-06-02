//
//  QMTokenInfo.m
//  MotherMoney
//
//  Created by cgt cgt on 16/5/25.
//  Copyright © 2016年 cgt cgt. All rights reserved.
//

#import "QMTokenInfo.h"

@implementation QMTokenInfo

+(QMTokenInfo *)sharedInstance
{
    static QMTokenInfo *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[QMTokenInfo alloc] init];
    });
    
    return sharedManager;
}

- (void)setMobileToken:(NSData *)mobileToken
{
    _tokenString = [[[[mobileToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
