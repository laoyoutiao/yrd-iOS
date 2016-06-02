//
//  NSString+url.h
//  MotherMoney
//
//  Created by liuyanfang on 15/9/21.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (url)

+(NSString*)encodeString:(NSString*)unencodedString;

+(NSString *)decodeString:(NSString*)encodedString;

@end
