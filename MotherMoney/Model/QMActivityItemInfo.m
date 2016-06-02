//
//  QMActivityItemInfo.m
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import "QMActivityItemInfo.h"

#define kActivityIdKey @"activityCenterId"
#define kActivityHtmlURLKey @"activityHTMLURL"
#define kActivityImagePathKey @"activityIMGPath"
#define kActivityTitleKey @"activityTitle"
#define kActivityStartDateKey @"startDate"
#define kActivityEndDateKey @"endDate"
#define kActivityStateKey @"state"
#define kActivityIntegralKey @"integral"
#define kActivityLogTimeKey @"logtime"

@implementation QMActivityItemInfo

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        // 1
        NSString *createTime = [dict objectForKey:@"createTime"];
        if ([CMMUtility isStringOk:createTime]) {
            self.createTime = createTime;
        }
        
        // 2
        NSString *endDate = [dict objectForKey:@"endDate"];
        if ([CMMUtility isStringOk:endDate]) {
            self.endDate = endDate;
        }
        
        // 3
        NSString *name = [dict objectForKey:@"name"];
        if ([CMMUtility isStringOk:name]) {
            self.name = name;
        }
        
        // 4
        NSString *activityId = [dict objectForKey:@"id"];
        if ([CMMUtility isStringOk:activityId]) {
            self.activityId = activityId;
        }

        // 5
        NSString *picPath = [dict objectForKey:@"picPath"];
        if ([CMMUtility isStringOk:picPath]) {
            self.picPath = picPath;
        }
        
        // 6
        NSString *startDate = [dict objectForKey:@"startDate"];
        if ([CMMUtility isStringOk:startDate]) {
            self.startDate = startDate;
        }
        
        // 7
        NSString *status = [dict objectForKey:@"status"];
        if ([CMMUtility isStringOk:status]) {
            self.status = status;
        }
        
        // 8
        NSString *updateTime = [dict objectForKey:@"updateTime"];
        if ([CMMUtility isStringOk:updateTime]) {
            self.updateTime = updateTime;
        }
        
        // 9
        NSString *url = [dict objectForKey:@"url"];
        if ([CMMUtility isStringOk:url]) {
            self.url = url;
        }
    }
    
    return self;
}

@end
