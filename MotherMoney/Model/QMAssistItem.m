//
//  QMAssistItem.m
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import "QMAssistItem.h"

#define kAssistIdKey @"helpCenter_id"
#define kAssistTitleKey @"helpTitle"
#define kAssistContentKey @"helpContent"

@implementation QMAssistItem

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        NSString *strId = [dict objectForKey:@"id"];
        if ([CMMUtility isStringOk:strId]) {
            self.assistId = strId;
        }
        
        NSString *createTime = [dict objectForKey:@"createTime"];
        if ([CMMUtility isStringOk:createTime]) {
            self.createTime = createTime;
        }
        
        NSString *updateTime = [dict objectForKey:@"updateTime"];
        if ([CMMUtility isStringOk:updateTime]) {
            self.updateTime = updateTime;
        }
        
        
        NSString *helpContent = [dict objectForKey:@"helpContent"];
        if ([CMMUtility isStringOk:helpContent]) {
            self.helpContent = helpContent;
        }
        
        NSString *helpTitle = [dict objectForKey:@"helpTitle"];
        if ([CMMUtility isStringOk:helpTitle]) {
            self.helpTitle = helpTitle;
        }
        
        NSString *sortParameter = [dict objectForKey:@"sortParameter"];
        if ([CMMUtility isStringOk:sortParameter]) {
            self.sortParameter = sortParameter;
        }
        
        NSString *enable = [dict objectForKey:@"enable"];
        if ([CMMUtility isStringOk:enable]) {
            self.enable = enable;
        }
    }
    
    return self;
}

@end
