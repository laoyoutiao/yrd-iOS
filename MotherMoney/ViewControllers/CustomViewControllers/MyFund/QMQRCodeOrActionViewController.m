//
//  QMQRCodeOrActionViewController.m
//  MotherMoney
//
//  Created by cgt cgt on 2017/8/9.
//  Copyright © 2017年 cgt cgt. All rights reserved.
//

#import "QMQRCodeOrActionViewController.h"
#import "SGQRCode.h"
#import "BlockActionSheet.h"

@interface QMQRCodeOrActionViewController ()

@end

@implementation QMQRCodeOrActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    if (_isQRCode) {
        [self setupGenerateQRCode];
        [self setupNumberInfo];
    }else
    {
        [self setupActionWebView];
    }
    
    // Do any additional setup after loading the view.
}

- (UIBarButtonItem *)rightBarButtonItem {
    if (_isQRCode) {
        UIBarButtonItem *item = [QMNavigationBarItemFactory createNavigationItemWithTitle:@"分享"
                                                                                   target:self
                                                                                 selector:@selector(socailPlatem)
                                                                                   isLeft:NO];
        return item;
    }else
    {
        return nil;
    }

}

- (void)socailPlatem
{
    __block NSString *shareContent = @"";
    __block UMSocialPlatformType platform = 1000;
    UIImage *shareImage = nil;
    
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@"分享到"];
    // 短信
    [sheet addButtonWithTitle:@"短信" imageName:@"message_icon.png" block:^{
        platform = UMSocialPlatformType_Sms;
        [self shareTo:platform content:shareContent image:shareImage];
    }];
    
    // 微信好友
    [sheet addButtonWithTitle:@"微信好友" imageName:@"wechat_icon.png" block:^{
        platform = UMSocialPlatformType_WechatSession;
        [self shareTo:platform content:shareContent image:shareImage];
    }];
    
    // 微信朋友圈
    [sheet addButtonWithTitle:@"微信朋友圈" imageName:@"wechat_favirate_icon.png" block:^{
        platform = UMSocialPlatformType_WechatTimeLine;
        [self shareTo:platform content:shareContent image:shareImage];
    }];
    
    // 新浪微博
    [sheet addButtonWithTitle:@"新浪微博" imageName:@"sina_icon.png" block:^{
        platform = UMSocialPlatformType_Sina;
        [self shareTo:platform content:shareContent image:shareImage];
    }];
    
    // QQ
    [sheet addButtonWithTitle:@"QQ" imageName:@"qq_icon.png" block:^{
        platform = UMSocialPlatformType_QQ;
        [self shareTo:platform content:shareContent image:shareImage];
    }];
    
    [sheet setDestructiveButtonWithTitle:@"取消" block:^{
        
    }];
    
    [sheet showInView:self.tabBarController.view];
}

- (void)shareTo:(UMSocialPlatformType)platform
        content:(NSString *)content
          image:(UIImage *)image {

    [QMUMTookKitManager shareTo:platform title:nil content:nil image:image shareUrl:[NSString stringWithFormat:@"http://www.yrdloan.com/wap/register?channelId=%@",_channelID] presentedController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 生成二维码
- (void)setupGenerateQRCode {
    
    // 1、借助UIImageView显示二维码
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat imageViewW = 200;
    CGFloat imageViewH = imageViewW;
    imageView.frame =CGRectMake(self.view.center.x - (imageViewW / 2), self.view.center.y - imageViewH, imageViewW, imageViewH);
    NSLog(@"%@ ----- %@",self.view, imageView);
    [self.view addSubview:imageView];
    
    // 2、将CIImage转换成UIImage，并放大显示
    imageView.image = [SGQRCodeGenerateManager SG_generateWithDefaultQRCodeData:[NSString stringWithFormat:@"http://www.yrdloan.com/wap/register?channelId=%@",_channelID] imageViewWidth:imageViewW];
    
//#pragma mark - - - 模仿支付宝二维码样式（添加用户头像）
//    CGFloat scale = 0.22;
//    CGFloat borderW = 5;
//    UIView *borderView = [[UIView alloc] init];
//    CGFloat borderViewW = imageViewW * scale;
//    CGFloat borderViewH = imageViewH * scale;
//    CGFloat borderViewX = 0.5 * (imageViewW - borderViewW);
//    CGFloat borderViewY = 0.5 * (imageViewH - borderViewH);
//    borderView.frame = CGRectMake(borderViewX, borderViewY, borderViewW, borderViewH);
//    borderView.layer.borderWidth = borderW;
//    borderView.layer.borderColor = [UIColor purpleColor].CGColor;
//    borderView.layer.cornerRadius = 10;
//    borderView.layer.masksToBounds = YES;
//    borderView.layer.contents = (id)[UIImage imageNamed:@"logo"].CGImage;
    
    //[imageView addSubview:borderView];
}

- (void)setupNumberInfo
{
    
}

- (void)setupActionWebView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    label.text = @"活动规则待定";
    [self.view addSubview:label];
}

- (NSString *)title
{
    if (_isQRCode) {
        return @"邀请二维码";
    }else
    {
        return @"活动规则";
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
