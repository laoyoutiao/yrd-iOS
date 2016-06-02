//
//  QMMessageInfo.h
//  MotherMoney
//
//  Created by   on 14-8-10.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMMessageInfo : NSObject
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *messageTitle;
@property (nonatomic, strong) NSString *messageContent;
@property (nonatomic, strong) NSString *enable;


- (id)initWithDictionary:(NSDictionary *)dict;

@end
