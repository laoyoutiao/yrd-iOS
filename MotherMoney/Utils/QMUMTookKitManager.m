//
//  QMUMTookKitManager.m
//  MotherMoney
//
//  Created by   on 14-8-5.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMUMTookKitManager.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialData.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSnsPlatformManager.h"

#define APP_DOWNLOAD_H5_URL @"http://m.yrdloan.com/mobile/rest/share/target"
#define SHARE_MARK @"%"
@implementation QMUMTookKitManager

+ (NSString *)UMAppKey {
    return UMKey;
}

+ (void)startMobClickAnalize {
    [self startMobClickAnalizeWithReportPolicy:BATCH channelId:nil];
}

+ (void)startMobClickAnalizeWithReportPolicy:(ReportPolicy)rp channelId:(NSString *)cid {
    [MobClick startWithAppkey:[self UMAppKey] reportPolicy:rp channelId:cid];
    [MobClick setLogEnabled:NO];
    
    [self setAppVersion];
}

+ (void)setAppVersion {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
}

#pragma mark event logs
+ (void)event:(NSString *)eventId label:(NSString *)label {
    [MobClick event:eventId label:label];
}

#pragma mark -
#pragma mark 社交分享相关
+ (void)UMShareConfigure:(NSString *)shareUrl
 {
     if (QM_IS_STR_NIL(shareUrl)) {
         shareUrl= APP_DOWNLOAD_H5_URL;
     }
    [UMSocialData setAppKey:[self UMAppKey]];
    // 微信分享配置
    [UMSocialWechatHandler setWXAppId:@"wxb05f40f331dd269c" appSecret:@"c250130ce72d7368ea2ea6a0246f081a" url:shareUrl];
    
    // 新浪微博分享
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    // QQ 分享
    [UMSocialQQHandler setQQWithAppId:@"1105012298" appKey:@"2irOUHKtua2l0p8w" url:shareUrl];
    
}

+ (void)shareTo:(NSString *)platform
          title:(NSString *)title1
        content:(NSString *)content
          image:(UIImage *)image
       shareUrl:(NSString *)shareUrl
presentedController:(UIViewController *)controller
     completion:(UMSocialDataServiceCompletion)completion {
    [self UMShareConfigure:shareUrl];
    if (QM_IS_STR_NIL(content)) {
        
        
        
        content = [NSString stringWithFormat:@"粤融贷为理财用户提供安全高效、专业优质的高收益理财产品。点击 %@ 即刻让我们的财富向前进。", APP_DOWNLOAD_H5_URL];
    }
    
    if (QM_IS_STR_NIL(title1)) {
        
        title1 = @"粤融贷理财APP";
        
    }
    
    if (QM_IS_STR_NIL(platform)) {
        
        return;
    }
    UIImage *shareImage = [UIImage imageNamed:@"share_icon.png"];
    if ([platform isEqualToString:UMShareToWechatSession]) { // 分享到微信
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title1;
        [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
    }else if ([platform isEqualToString:UMShareToWechatTimeline]) { // 分享到微信朋友圈
        content = [NSString stringWithFormat:@"%@\n%@", title1, content];
        [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeWeb;
    }else if ([platform isEqualToString:UMShareToQQ]) { // 分享到QQ
        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
        [UMSocialData defaultData].extConfig.qqData.title = title1;
        
        //        content = [NSString stringWithFormat:@"%@\n%@", title, content];
        //        shareImage = nil;
    }else if ([platform isEqualToString:UMShareToSina]) { // 分享到新浪
        content = [NSString stringWithFormat:@"%@\n%@", title1, content];
        shareImage = [UIImage imageNamed:@""];
    }else if ([platform isEqualToString:UMShareToSms]) { // 短信分析那个
        content = [NSString stringWithFormat:@"%@\n%@ %@", title1, content,
                   (shareUrl == nil) ? @"":shareUrl];
        shareImage = nil;
    }else {
        return;
    }
    NSLog(@"title1=%@", title1);
    [self postSNSWithType:platform
                  content:content
                    image:shareImage
                 location:nil
              urlResource:nil
      presentedController:controller
               conpletion:completion];
}

+ (void)postSNSWithType:(NSString *)platform
                content:(NSString *)content
                  image:(UIImage *)image
               location:(CLLocation *)location
            urlResource:(UMSocialUrlResource *)urlResource
    presentedController:(UIViewController *)controller
             conpletion:(void(^)(UMSocialResponseEntity *response))completionBlock {
    
    if (QM_IS_STR_NIL(platform)) {
        return;
    }
    
//    if (QM_IS_STR_NIL(content) && nil == image) {
//        return;
//    }
    
    [[UMSocialControllerService defaultControllerService] setShareText:content shareImage:image socialUIDelegate:nil];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platform];
    snsPlatform.snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
}

@end
