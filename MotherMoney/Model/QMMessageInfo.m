//
//  QMMessageInfo.m
//  MotherMoney
//
//  Created by   on 14-8-10.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMMessageInfo.h"

@implementation QMMessageInfo

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        // 1
        NSString *msgId = [dict objectForKey:@"id"];
        if ([CMMUtility isStringOk:msgId]) {
            self.messageId = msgId;
        }
        
        // 2
        NSString *createTime = [dict objectForKey:@"createTime"];
        if ([CMMUtility isStringOk:createTime]) {
            self.createTime = createTime;
        }
        
        // 3
        NSString *updateTime = [dict objectForKey:@"updateTime"];
        if ([CMMUtility isStringOk:updateTime]) {
            self.updateTime = updateTime;
        }
        
        self.messageTitle = QMLocalizedString(@"qm_system_message_title", @"系统消息");
        
        // 5
        NSString *messageContent = [dict objectForKey:@"messageContent"];
        if ([CMMUtility isStringOk:messageContent]) {
            self.messageContent = messageContent;
        }
        
        // 6
        NSString *enable = [dict objectForKey:@"enable"];
        if ([CMMUtility isStringOk:enable]) {
            self.enable = enable;
        }
    }
    
    return self;
}

@end
