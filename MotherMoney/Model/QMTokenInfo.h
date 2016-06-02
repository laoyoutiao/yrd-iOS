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

- (void)setMobileToken:(NSData *)mobileToken;

+(QMTokenInfo *)sharedInstance;


@end
