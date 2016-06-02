//
//  QMActivityItemInfo.h
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMActivityItemInfo : NSObject
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *picPath;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *activityId;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
