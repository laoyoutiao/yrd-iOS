//
//  QMTokenInfo.h
//  MotherMoney
//
//  Created by cgt cgt on 16/5/25.
//  Copyright © 2016年 cgt cgt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMTokenInfo : NSObject

@property (nonatomic, strong) NSString *tokenString;
@property (nonatomic, strong) NSString *phoneNumber;

- (void)setMobileToken:(NSData *)mobileToken;
- (void)setAccountPhoneNumber:(NSString *)phoneNumber;

+(QMTokenInfo *)sharedInstance;


@end
