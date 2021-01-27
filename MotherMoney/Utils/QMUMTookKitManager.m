//
//  QMUMTookKitManager.m
//  MotherMoney
//
//  Created by   on 14-8-5.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMUMTookKitManager.h"

#define APP_DOWNLOAD_H5_URL @"http://m.yrdloan.com/wap/register"
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
//    [UMSocialData setAppKey:[self UMAppKey]];
    // 微信分享配置
//    [UMSocialWechatHandler setWXAppId:@"wxb05f40f331dd269c" appSecret:@"c250130ce72d7368ea2ea6a0246f081a" url:shareUrl];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxb05f40f331dd269c" appSecret:@"c250130ce72d7368ea2ea6a0246f081a" redirectURL:shareUrl];
    
    // 新浪微博分享
     [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2482297240"  appSecret:@"3ce75361dd8ed85f597535f82f39d60b" redirectURL:shareUrl];
    
    // QQ 分享
//    [UMSocialQQHandler setQQWithAppId:@"1105012298" appKey:@"2irOUHKtua2l0p8w" url:shareUrl];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105012298"/*设置QQ平台的appID*/  appSecret:@"2irOUHKtua2l0p8w" redirectURL:shareUrl];
     
}

+ (void)shareTo:(UMSocialPlatformType)platform
          title:(NSString *)title1
        content:(NSString *)content
          image:(UIImage *)image
       shareUrl:(NSString *)shareUrl
presentedController:(UIViewController *)controller{
    
    [self UMShareConfigure:shareUrl];
    if (QM_IS_STR_NIL(content)) {
        content = [NSString stringWithFormat:@"粤融贷为理财用户提供安全高效、专业优质的高收益理财产品。点击 %@ 即刻让我们的财富向前进。", APP_DOWNLOAD_H5_URL];
    }
    
    if (QM_IS_STR_NIL(title1)) {
        
        title1 = @"粤融贷理财APP";
        
    }
    
    if (QM_IS_STR_NIL(shareUrl)) {
        shareUrl= APP_DOWNLOAD_H5_URL;
    }
    
    UIImage *shareImage = [UIImage imageNamed:@"share_icon.png"];
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    if (platform == UMSocialPlatformType_WechatSession) { // 分享到微信
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title1 descr:content thumImage:shareImage];
        //设置网页地址
        shareObject.webpageUrl = shareUrl;
        messageObject.shareObject = shareObject;
    }else if (platform == UMSocialPlatformType_WechatTimeLine) { // 分享到微信朋友圈
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"%@\n%@", title1, content] descr:nil thumImage:shareImage];
        //设置网页地址
        shareObject.webpageUrl = shareUrl;
        messageObject.shareObject = shareObject;

    }else if (platform == UMSocialPlatformType_QQ) { // 分享到QQ
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title1 descr:content thumImage:shareImage];
        //设置网页地址
        shareObject.webpageUrl = shareUrl;
        messageObject.shareObject = shareObject;
    }else if (platform == UMSocialPlatformType_Sina) { // 分享到新浪
        messageObject.text = [NSString stringWithFormat:@"%@\n%@ %@", title1, content, (shareUrl == nil) ? @"":shareUrl];
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        shareObject.shareImage = shareImage;
        messageObject.shareObject = shareObject;
    }else if (platform == UMSocialPlatformType_Sms) { // 短信分析那个
        messageObject.text = [NSString stringWithFormat:@"%@\n%@ %@", title1, content, (shareUrl == nil) ? @"":shareUrl];
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        shareObject.shareImage = shareImage;
        messageObject.shareObject = shareObject;
    }else {
            return;
    }
    
    [self postSNSWithType:platform
                 location:nil
      presentedController:controller
            messageObject:messageObject];
}

+ (void)postSNSWithType:(UMSocialPlatformType)platform
               location:(CLLocation *)location
    presentedController:(UIViewController *)controller
          messageObject:(UMSocialMessageObject *)messageObject{
    
//    messageObject.title = @"粤融贷";
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:controller completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
            
        }
//        [self alertWithError:error];
    }];
    
}

@end
