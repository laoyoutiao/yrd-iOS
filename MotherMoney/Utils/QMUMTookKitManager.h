//
//  QMUMTookKitManager.h
//  MotherMoney
//
//  Created by   on 14-8-5.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobClick.h"
#import "UMSocialSnsService.h"
#import "UMSocialDataService.h"

@interface QMUMTookKitManager : NSObject

#pragma mark -
#pragma mark MobClick相关

+ (NSString *)UMAppKey;

// 开始统计
+ (void)startMobClickAnalize;
+ (void)startMobClickAnalizeWithReportPolicy:(ReportPolicy)rp channelId:(NSString *)cid;

#pragma mark event logs
+ (void)event:(NSString *)eventId label:(NSString *)label;

#pragma mark -
#pragma mark 友盟Social 配置
+ (void)UMShareConfigure:(NSString *)shareUrl
;
+ (void)shareTo:(NSString *)platform
          title:(NSString *)title11
        content:(NSString *)content
          image:(UIImage *)image
       shareUrl:(NSString *)shareUrl
presentedController:(UIViewController *)controller
     completion:(UMSocialDataServiceCompletion)completion;

@end
