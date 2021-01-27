//
//  RecommendationViewController.m
//  MotherMoney
//ƒ
//  Created by   on 14-8-3.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "RecommendationViewController.h"
#import "KIImagePager.h"
#import "QMRecommendData.h"
#import "NetServiceManager.h"
#import "QMProductInfoViewController.h"
#import "QMRecommendProductInfoCell.h"
#import "QMProductRecommendGuideView.h"
#import "QMPreferenceUtil.h"
#import <AdSupport/AdSupport.h>
#import "ProgressView.h"
#import "QMAdvertisementModel.h"
#import "QMWebViewAdvertisementViewController.h"
#import "QMTokenInfo.h"
#import "QMDealDetailViewController.h"
#import "QMFrameUtil.h"
#import "QMActivityCenterViewController.h"
#import "QMAssistCenterViewController.h"
#import "QMMessageCenterViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"
#import "UIImageView+WebCache.h"
#import "QMMoreItemInfo.h"
#import "QMGoodsListViewController.h"

static NSString *appKey = @"36ff80808157b6c5510157b6c551690000";
static NSString *appSecret= @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCv%2FckL6%2Fs9FwSVXb7OEOHZH%2BXFgPI8Q1KeExgZAbgVfCinA44XqKfKBSroJcVPnxHiXplqSTthUtgxDToGvzezTR6kbPyjJtfEsZVqnYsbaxcKQTF0PDirq4KxiUjOKQhE0dgriz%2ByUdMF3MqPAqnCLE0wavx9Pt2ySsX9HjcKFQIDAQAB";
#define PRODUCT_GUIDE_HAS_SHOW_KEY @"PRODUCT_GUIDE_HAS_SHOW_KEY"
#define Click_Button_Number_Action 200
#define Click_Button_Number_Buy 201
#define Click_Button_Number_Store 202
#define Click_Button_Number_People 203
#define Click_Button_Number_Help 204
#define Click_Button_Number_Message 205
#define Click_Button_Number_Middle 206


@interface RecommendationViewController ()<KIImagePagerDelegate, KIImagePagerDataSource, UITableViewDataSource, UITableViewDelegate>

@end

@implementation RecommendationViewController {
    QMRecommendData *recommendationData;
    KIImagePager *mImagePager;
    QMProductRecommendGuideView *guideView;
    UIImageView *advinimageview;
//    UIImage *advinimage;
    NSTimer *distimer;
    NSTimer *protimer;
    UIButton *passbutton;
    UIView *backgroundView;
    NSString *advertUrlString;
    ProgressView *progress;
    BOOL isPeopleLoginClick;
    NSString *middleURLString;
    NSString *middleName;
    NSString *canGoToOneBuy;
    UIImageView *readLastImageView;
    UILabel *registPeopleLbl;
    UILabel *safeDayLbl;
    UILabel *expiredLbl;
    UILabel *rankOneLbl;
    UILabel *rankTwoLbl;
    UILabel *rankThreeLbl;
    UILabel *rankOneNameLbl;
    UILabel *rankTwoNameLbl;
    UILabel *rankThreeNameLbl;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *filepath = [defaults objectForKey:@"advertisementPicPath"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:filepath];
    if (!savedImage)
    {
        savedImage = [UIImage imageNamed:@"启动页"];
    }
    if ([QMFrameUtil hasShownWelcomPage])
    {
        [self showAdvertisementPicture:savedImage];
    }else
    {
        [self updataView];
    }
    
    isPeopleLoginClick = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticegotoMyFund) name:noticeLoginPeopleMessage object:nil];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [self updateLeftBarButtonItem];
    [(UITableView *)self.scrollView reloadData];
}

- (void)reloadData {
    [self asyncLoadDataFromServer];
}

#pragma mark -
#pragma mark GuideView or AdvertisementView

//加载向导页
- (void)showGuideView {
    guideView = [[QMProductRecommendGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [guideView.buyBtn addTarget:self action:@selector(buyProductBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.view addSubview:guideView];
}
//隐藏向导页
- (void)hideGuideView {
    if (guideView.superview) {
        [guideView removeFromSuperview];
        guideView = nil;
        
        [QMPreferenceUtil setGlobalBoolKey:PRODUCT_GUIDE_HAS_SHOW_KEY value:YES syncWrite:YES];
    }
}

//请求广告接口
- (void)postAdvertisementInterface
{
    NSString *mobile =[NSString stringWithFormat:kAdvertisement];
    NSString *base_string = [NSString stringWithFormat:@"%@",URL_BASE];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",base_string,mobile];
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:base_string]];
    __weak __typeof(self) bself = self;
    [httpClient xsPostPath:urlString delegate:self params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)[responseObject objectFromJSONData];
        NSLog(@"%@",dic);
        NSArray *advertArray = [QMAdvertisementModel instanceArrayDictFromArray:[[dic objectForKey:@"data"] objectForKey:@"list"]];;
        [bself getPictures:advertArray];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [bself getPictures:nil];
    }];

}

//加载广告图片
- (void)downAdvertisementPicture:(NSArray *)advertArray
{
    for (int i = 0; i < [advertArray count]; i ++) {
        
        QMAdvertisementModel *model = [advertArray objectAtIndex:i];
        NSURL *url = [NSURL URLWithString:model.AdverHomePath];
        NSData *data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        advertUrlString = model.AdverUrl;
        [defaults setObject:advertUrlString forKey:@"advertisementPicLinkPath"];
        
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *myDirectory = [documentsDirectory stringByAppendingPathComponent:@"test"];
                NSString *filePath = [myDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",model.AdverID]];
                NSLog(@"documentsDirectory --- %@",filePath);
                [defaults setObject:filePath forKey:@"advertisementPicPath"];
                [UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES];
                [fileManager createDirectoryAtPath:myDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            });
        }
    }
}

//取出沙盒的图片
-(void)getPictures:(NSArray *)advertArray
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *myDirectory = [documentsDirectory stringByAppendingPathComponent:@"test"];
    NSArray *file = [fileManage subpathsOfDirectoryAtPath: myDirectory error:nil];
    
    NSMutableArray *pictureArray = [NSMutableArray array];
    
    BOOL havePicture = NO;
    for (int i = 0;i < [file count];i ++) {
        for (int m = 0;m < [advertArray count]; m ++)
        {
            QMAdvertisementModel *model = [advertArray objectAtIndex:m];
            if ([[file objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%ld",model.AdverID]]) {
                [pictureArray addObject:[file objectAtIndex:i]];
            }
        }
    }
    
    if ([pictureArray count] == [advertArray count] && [pictureArray count] != 0) {
        havePicture = YES;
    }
    
    if (!havePicture) {
        [self downAdvertisementPicture:advertArray];
//        [self updataView];
    }else
    {
        NSInteger randnum = arc4random() % [pictureArray count];
        NSString *idstr = [pictureArray objectAtIndex:!([pictureArray count] - 1)? 0:(randnum > 0? randnum:0)];
        NSString *fullPath = [[documentsDirectory stringByAppendingPathComponent:@"test"] stringByAppendingPathComponent:idstr];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:fullPath forKey:@"advertisementPicPath"];
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
//        [self showAdvertisementPicture:savedImage];
        
        for (int n = 0;n < [advertArray count]; n ++)
        {
            QMAdvertisementModel *model = [advertArray objectAtIndex:n];
            if ([idstr isEqualToString:[NSString stringWithFormat:@"%ld",model.AdverID]])
            {
                advertUrlString = model.AdverUrl;
                [defaults setObject:advertUrlString forKey:@"advertisementPicLinkPath"];
            }
        }
    }
}

//显示广告页
- (void)showAdvertisementPicture:(UIImage *)advinimage
{
    [self postAdvertisementInterface];
    if (!advinimage)
    {
        [self updataView];
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
    backgroundView.alpha = 0.5;
    backgroundView.backgroundColor = [UIColor blackColor];
    [window addSubview:backgroundView];
    
    advinimageview = [[UIImageView alloc] initWithFrame:window.frame];
    [advinimageview setImage:advinimage];
    advinimageview.center = CGPointMake(window.frame.size.width / 2, window.frame.size.height / 2);
    advinimageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAdvertisement)];
    [advinimageview addGestureRecognizer:tapGestureRecognizer];
    [window addSubview:advinimageview];
    
    passbutton = [[UIButton alloc] initWithFrame:CGRectMake(window.frame.size.width - 70, 30, 60, 30)];
    passbutton.backgroundColor = [UIColor grayColor];
    [passbutton setTitle:@"跳过" forState:UIControlStateNormal];
    [passbutton setTintColor:[UIColor whiteColor]];
    [passbutton addTarget:self action:@selector(dismissAdvin) forControlEvents:UIControlEventTouchUpInside];
    passbutton.layer.cornerRadius = passbutton.frame.size.height / 2;
    passbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    passbutton.alpha = 0.8;
    [window addSubview:passbutton];
    
    distimer = [NSTimer scheduledTimerWithTimeInterval:3.05 target:self selector:@selector(dismissAdvin) userInfo:nil repeats:NO];
}

- (void)clickAdvertisement
{
    advinimageview.userInteractionEnabled = NO;
    
//    QMWebViewAdvertisementViewController *advertwebview = [[QMWebViewAdvertisementViewController alloc] init];
//    advertwebview.advertUrlString = advertUrlString;
//    [advertwebview setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:advertwebview animated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *link = [defaults objectForKey:@"advertisementPicLinkPath"];
    
    [QMWebViewController showWebViewWithRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:link]] navTitle:nil isModel:YES from:self];


    [passbutton removeFromSuperview];
    [backgroundView removeFromSuperview];
    [self close];
}

- (void)dismissAdvin
{
    [passbutton removeFromSuperview];
    [backgroundView removeFromSuperview];
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(close)];
    advinimageview.bounds = CGRectMake(0, 0, self.view.frame.size.width / 2 * 3, self.view.frame.size.height / 2 * 3);
    advinimageview.center = self.view.center;
    advinimageview.alpha = 0;
    [UIView commitAnimations];
}

- (void)close
{
    [advinimageview removeFromSuperview];
    [self updataView];
    [distimer invalidate];
}

#pragma mark -
#pragma mark FeaturesViews

- (UIView *)setFeaturesViews
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 140.0f * CGRectGetWidth([UIScreen mainScreen].bounds) / 320, CGRectGetWidth([UIScreen mainScreen].bounds), 320)];
    
    UIView *rankview = [[UIView alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth([UIScreen mainScreen].bounds), 100)];
    rankview.backgroundColor = [UIColor whiteColor];
    
    UIImage *rankimage = [UIImage imageNamed:@"ranking_home_icon"];
    UIImageView *rankimageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 25, 22)];
    rankimageview.image = rankimage;
    [rankview addSubview:rankimageview];
    
    UILabel *ranklabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 12, 70, 14)];
    ranklabel.text = @"投资排行榜";
    ranklabel.textColor = [UIColor brownColor];
    ranklabel.font = [UIFont systemFontOfSize:13];
    [rankview addSubview:ranklabel];
    
    UILabel *wantextlabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 15, 30, 11)];
    wantextlabel.text = @"(元)";
    wantextlabel.textColor = [UIColor brownColor];
    wantextlabel.font = [UIFont systemFontOfSize:10];
    [rankview addSubview:wantextlabel];
    
    UIImage *ranklistimage = [UIImage imageNamed:@"ranklist_home_image.png"];
    UIImageView *ranklistimageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 70)];
    ranklistimageview.image = ranklistimage;
    [rankview addSubview:ranklistimageview];
    
    rankTwoNameLbl = [self headNumLabel:CGRectMake(0, 40, size.width / 3, 35) :rankview :16 :[UIColor blackColor]];
    rankTwoNameLbl.text = @"未上榜";
    rankOneNameLbl = [self headNumLabel:CGRectMake(size.width / 3 + 20, 35, size.width / 3, 35) :rankview :16 :[UIColor redColor]];
    rankOneNameLbl.text = @"未上榜";
    rankThreeNameLbl = [self headNumLabel:CGRectMake(size.width / 3 * 2 + 5, 45, size.width / 3, 35) :rankview :16 :[UIColor blackColor]];
    rankThreeNameLbl.text = @"未上榜";
    
    rankTwoLbl = [self headNumLabel:CGRectMake(0, 63, size.width / 3, 35) :rankview :16 :[UIColor blackColor]];
    rankTwoLbl.text = @"";
    rankOneLbl = [self headNumLabel:CGRectMake(size.width / 3 + 20, 58, size.width / 3, 35) :rankview :16 :[UIColor redColor]];
    rankOneLbl.text = @"";
    rankThreeLbl = [self headNumLabel:CGRectMake(size.width / 3 * 2 + 5, 68, size.width / 3, 35) :rankview :16 :[UIColor blackColor]];
    rankThreeLbl.text = @"";
    
    [view addSubview:rankview];
    
    view.backgroundColor = [UIColor whiteColor];
    
    registPeopleLbl = [self headNumLabel:CGRectMake(0, 5, size.width / 3, 35) :view :22 :[UIColor redColor]];
    registPeopleLbl.text = @"0";
    safeDayLbl = [self headNumLabel:CGRectMake(size.width / 3, 5, size.width / 3, 35) :view :22 :[UIColor redColor]];
    safeDayLbl.text = @"0";
    expiredLbl = [self headNumLabel:CGRectMake(size.width / 3 * 2, 5, size.width / 3, 35) :view :22 :[UIColor redColor]];
    expiredLbl.text = @"0";
    
    UIButton *registTextBtn = [self headTextBtn:CGRectMake(0, 30, size.width / 3, 25) :@"people_home_icon" :view];
    [registTextBtn setTitle:@"注册人数" forState:UIControlStateNormal];
    UIButton *safeDayTextBtn = [self headTextBtn:CGRectMake(size.width / 3, 30, size.width / 3, 25) :@"safe_home_icon" :view];
    [safeDayTextBtn setTitle:@"安全运营日" forState:UIControlStateNormal];
    UIButton *expiredTextBtn = [self headTextBtn:CGRectMake(size.width / 3 * 2, 30, size.width / 3, 25) :@"time_home_icon" :view];
    [expiredTextBtn setTitle:@"逾期" forState:UIControlStateNormal];
    
    UIButton *actionBtn = [self headClickBtn:CGRectMake(0, 160, size.width / 4, 80) :@"action_home_button_icon" :view];
    [actionBtn setTitle:@"热门活动" forState:UIControlStateNormal];
    actionBtn.tag = Click_Button_Number_Action;
    UIButton *buyBtn = [self headClickBtn:CGRectMake(size.width / 4, 160, size.width / 4, 80) :@"buy_home_button_icon" :view];
    [buyBtn setTitle:@"积分抢购" forState:UIControlStateNormal];
    buyBtn.tag = Click_Button_Number_Buy;
    UIButton *shoreBtn = [self headClickBtn:CGRectMake(size.width / 4 * 2, 160,size.width / 4, 80) :@"store_home_button_icon" :view];
    [shoreBtn setTitle:@"积分商城" forState:UIControlStateNormal];
    shoreBtn.tag = Click_Button_Number_Store;
    UIButton *peopleBtn = [self headClickBtn:CGRectMake(size.width / 4 * 3, 160, size.width / 4, 80) :@"people_home_button_icon" :view];
    [peopleBtn setTitle:@"个人中心" forState:UIControlStateNormal];
    peopleBtn.tag = Click_Button_Number_People;
    UIButton *helpBtn = [self headClickBtn:CGRectMake(0, 240, size.width / 4, 80) :@"help_home_button_icon" :view];
    [helpBtn setTitle:@"帮助中心" forState:UIControlStateNormal];
    helpBtn.tag = Click_Button_Number_Help;
    UIButton *middleBtn = [self headClickBtn:CGRectMake(size.width / 4, 240, size.width / 2, 80):nil :view];
    middleBtn.tag = Click_Button_Number_Middle;
    UIImageView *middleimageview = [[UIImageView alloc] initWithFrame:CGRectMake(size.width / 4, 240, size.width / 2, 80)];
    [view addSubview:middleimageview];
    UIButton *messageBtn = [self headClickBtn:CGRectMake(size.width / 4 * 3, 240, size.width / 4, 80) :@"message_home_button_icon" :view];
    [messageBtn setTitle:@"消息中心" forState:UIControlStateNormal];
    messageBtn.tag = Click_Button_Number_Message;
    
    [[NetServiceManager sharedInstance] getHomeMiddleLinkDelegate:self success:^(id responseObject) {
        [middleimageview sd_setImageWithURL:[NSURL URLWithString:[responseObject safeStringForKey:@"piclink"]]];
        middleURLString = [responseObject safeStringForKey:@"jumplink"];
        middleName = [responseObject safeStringForKey:@"title"];
        canGoToOneBuy = [responseObject safeStringForKey:@"kengdie"];
    } failure:^(NSError *error) {
        
    }];
    
    [[NetServiceManager sharedInstance] getHomeDataWithDelegate:self success:^(id responseObject) {
        registPeopleLbl.text = [NSString stringWithFormat:@"%@",[responseObject safeStringForKey:@"customerCount"]];
        safeDayLbl.text = [NSString stringWithFormat:@"%@",[responseObject safeStringForKey:@"yunying"]];
        NSArray *rankarray = [responseObject safeArrayForKey:@"rank"];
        NSDictionary *rankonedict = [rankarray objectAtIndex:0];
        NSDictionary *ranktwodict = [rankarray objectAtIndex:1];
        NSDictionary *rankthreedict = [rankarray objectAtIndex:2];
        
        rankOneLbl.text = [self rankMoney:rankonedict];
        rankTwoLbl.text = [self rankMoney:ranktwodict];
        rankThreeLbl.text = [self rankMoney:rankthreedict];
        
        rankOneNameLbl.text = [self rankName:rankonedict];
        rankTwoNameLbl.text = [self rankName:ranktwodict];
        rankThreeNameLbl.text = [self rankName:rankthreedict];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    [[NetServiceManager sharedInstance] getMsgActivityLastUpdateTimeWithDelegate:self
                                                                         success:^(id responseObject) {
                                                                             NSLog(@"response:%@", responseObject);
                                                                             if (!QM_IS_DICT_NIL(responseObject)) {
                                                                                 NSString *lastMessage = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"lastMessage"]];;
                                                                                 
                                                                                 NSString *lastMessageRead = [QMPreferenceUtil getGlobalKey:MESSAGE_LAST_READ_TIME];
                                                                                 
                                                                                 if ([CMMUtility isStringOk:lastMessage]) {
                                                                                     [QMPreferenceUtil setGlobalKey:MESSAGE_LAST_UPDATE_TIME value:lastMessage syncWrite:YES];
                                                                                 }
                                                                                 
                                                                                 if ([lastMessage longLongValue] > [lastMessageRead longLongValue]) { // 消息有未读
                                                                                     readLastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
                                                                                     readLastImageView.center = CGPointMake(size.width / 16 * 15, 260);
                                                                                     readLastImageView.image = [UIImage imageNamed:@"new_message.png"];
                                                                                     [view addSubview:readLastImageView];
                                                                                 }
                                                                             }
                                                                         } failure:^(NSError *error) {
                                                                             // 获取成功
                                                                             
                                                                         }];
    


    
    [self line:CGRectMake(0, 60, size.width, 0.5) :view];
    [self line:CGRectMake(0, 240, size.width, 0.5) :view];
    [self line:CGRectMake(size.width / 4, 170, 1, 60) :view];
    [self line:CGRectMake(size.width /4 * 2, 170, 1, 60) :view];
    [self line:CGRectMake(size.width /4 * 3, 170, 1, 60) :view];
    [self line:CGRectMake(size.width / 4, 250, 1, 60) :view];
    [self line:CGRectMake(size.width /4 * 3, 250, 1, 60) :view];
    
    return  view;
}

- (NSString *)rankMoney:(NSDictionary *)dict
{
    NSString *money = [NSString stringWithFormat:@"%@", [dict safeStringForKey:@"total"]];
    if (!money.integerValue)
    {
        return nil;
    }
    NSString *returnstring = @"";
    for (int i = 0; i <= money.length / 3 ; i ++)
    {
        if (i == 0) {
            returnstring = [NSString stringWithFormat:@"%@%@", returnstring ,[money substringWithRange:NSMakeRange(0, money.length % 3)]];
        }else
        {
            returnstring = [NSString stringWithFormat:@"%@,%@", returnstring ,[money substringWithRange:NSMakeRange(money.length % 3 + (i - 1) * 3, 3)]];
        }
    }
    return returnstring;
}

- (NSString *)rankName:(NSDictionary *)dict
{
    NSString *gender = [dict safeStringForKey:@"gender"];
    if (gender.length == 0)
    {
        return nil;
    }else
    {
        return [NSString stringWithFormat:@"%@%@", [dict safeStringForKey:@"realName"], [gender isEqualToString:@"MALE"]? @"先生":@"女士"];
    }
}

- (void)line:(CGRect)rect  :(UIView *)fatherview
{
    UIView *line = [[UIView alloc] initWithFrame:rect];
    line.backgroundColor = [UIColor grayColor];
    [fatherview addSubview:line];
}

- (UILabel *)headNumLabel:(CGRect)rect  :(UIView *)fatherview :(NSInteger)font :(UIColor *)color
{
    UILabel *Lbl = [[UILabel alloc] initWithFrame:rect];
    Lbl.textAlignment = NSTextAlignmentCenter;
    Lbl.textColor = color;
    Lbl.font = [UIFont systemFontOfSize:font];
    [fatherview addSubview:Lbl];
    return Lbl;
}

- (UIButton *)headTextBtn:(CGRect)rect :(NSString *)pictname  :(UIView *)fatherview
{
    UIButton *Btn = [[UIButton alloc] initWithFrame:rect];
    Btn.enabled = NO;
    [Btn setImage:[UIImage imageNamed:pictname] forState:UIControlStateNormal];
    Btn.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);
    Btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [Btn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [fatherview addSubview:Btn];
    return Btn;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIButton *)headClickBtn:(CGRect)rect :(NSString *)pictname :(UIView *)fatherview
{
    UIButton *Btn = [[UIButton alloc] initWithFrame:rect];
    UIImage *image = [UIImage imageNamed:pictname];
    [fatherview addSubview:Btn];
    [Btn setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [Btn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1]] forState:UIControlStateHighlighted];
    
    if (pictname.length)
    {
        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
        imageview.frame = CGRectMake(fatherview.frame.size.width / 8 - image.size.width / 2 + Btn.frame.origin.x, (Btn.frame.size.height - 20 - image.size.height) /2 + Btn.frame.origin.y, image.size.width, image.size.height);
        [fatherview addSubview:imageview];
    }
    
    Btn.backgroundColor = [UIColor clearColor];
    [Btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    Btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    Btn.titleEdgeInsets = UIEdgeInsetsMake(40, 0, 0, 0);
    Btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return Btn;
}

- (void)click:(UIButton *)sender
{
    NSLog(@"%ld",sender.tag);
    switch (sender.tag) {
        case Click_Button_Number_Action:
            [self gotoActivityCenter];
            break;
            
        case Click_Button_Number_Buy:
            [self gotoOneBuy];
            break;
            
        case Click_Button_Number_Store:
            [self gotoStore];
            break;
            
        case Click_Button_Number_People:
            [self gotoMyFund];
            break;
            
        case Click_Button_Number_Help:
            [self gotoHelpCenter];
            break;
            
        case Click_Button_Number_Message:
            [self gotoMessageCenter];
            break;
            
        case Click_Button_Number_Middle:
            [self gotoMiddleWebView];
            break;
            
        default:
            break;
    }
}

- (void)gotoOneBuy
{
    if ([canGoToOneBuy isEqualToString:@"true"])
    {
        [QMWebViewController showWebViewWithRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_BASE,@"/onebuy/home"]]] navTitle:@"积分抢购" isModel:YES from:self];
    }else if([canGoToOneBuy isEqualToString:@"false"])
    {
        UIViewController *viewcontroller = [UIApplication sharedApplication].keyWindow.rootViewController;
        UIAlertController *alertviewcontroller = [UIAlertController alertControllerWithTitle:@"敬请期待" message:@"我们正在精心帮你挑选兑换商品，敬请期待" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertviewcontroller addAction:cancelAction];
        [viewcontroller presentViewController:alertviewcontroller animated:YES completion:nil];
    }

}

// 积分商城
- (void)gotoStore
{
    if (![[QMAccountUtil sharedInstance] userHasLogin])
    {
//        [QMLoginManagerUtil showLoginViewControllerFromViewController:self];
        [QMLoginManagerUtil showLoginViewControllerFromViewController:self completion:^{
            [QMWebViewController showWebViewWithRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_BASE,@"/index/scoreProduct"]]] navTitle:@"积分商城" isModel:YES from:self];
        }];
        return;
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/scoreshop",URL_BASE];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *onlinedict = [dict safeDictForKey:@"data"];
        NSLog(@"%@",dict);
        if([dict safeStringForKey:@"code"].integerValue == 3)
        {
            [QMLoginManagerUtil showLoginViewControllerFromViewController:self completion:^{
                [QMWebViewController showWebViewWithRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_BASE,@"/index/scoreProduct"]]] navTitle:@"积分商城" isModel:YES from:self];
            }];
        }
        else
        {
            if ([onlinedict safeStringForKey:@"online"].integerValue == 0)
            {
                UIViewController *viewcontroller = [UIApplication sharedApplication].keyWindow.rootViewController;
                UIAlertController *alertviewcontroller = [UIAlertController alertControllerWithTitle:@"敬请期待" message:@"我们正在精心帮你挑选兑换商品，敬请期待" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertviewcontroller addAction:cancelAction];
                [viewcontroller presentViewController:alertviewcontroller animated:YES completion:nil];
            }
            else if([onlinedict safeStringForKey:@"online"].integerValue == 2) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [QMWebViewController showWebViewWithRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_BASE,@"/index/scoreProduct"]]] navTitle:@"积分商城" isModel:YES from:self];
                });
            }
            else
            {
                NSLog(@"requestUrl == %@ \n\n\n\n",requestUrl);
                [QMWebViewController showWebViewWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[dict safeStringForKey:@"link"]]] navTitle:@"积分商城" isModel:YES from:self];
            }
        }
    }];
    [task resume];
}

- (UINavigationController *)getCurrentNavigationVC
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
            return nav;
        }
    }else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return nav;
    }
    return nil;
}

- (NSString *)timestamp
{
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    NSString *curTime = [NSString stringWithFormat:@"%llu", dTime];
    
    return curTime;
}

// 活动中心
- (void)gotoActivityCenter
{
    [QMUMTookKitManager event:SHOW_ACTIVITY_KEY label:@"显示活动"];
    
    QMActivityCenterViewController *con = [[QMActivityCenterViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

- (NSString *)md5Str:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [[NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

//中心连接
- (void)gotoMiddleWebView
{
    [QMWebViewController showWebViewWithRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:middleURLString]] navTitle:middleName isModel:YES from:self];
}

// 消息中心
- (void)gotoMessageCenter
{
    [QMUMTookKitManager event:SHOW_MSG_KEY label:@"显示消息中心"];
    
    [[NetServiceManager sharedInstance] getMsgActivityLastUpdateTimeWithDelegate:self
                                                                         success:^(id responseObject) {
                                                                             NSLog(@"response:%@", responseObject);
                                                                             if (!QM_IS_DICT_NIL(responseObject)) {
                                                                                 NSString *lastMessage = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"lastMessage"]];
                                                                                 
                                                                                 if ([CMMUtility isStringOk:lastMessage]) {
                                                                                     [QMPreferenceUtil setGlobalKey:MESSAGE_LAST_UPDATE_TIME value:lastMessage syncWrite:YES];
                                                                                 }
                                                                             }
                                                                         } failure:^(NSError *error) {
                                                                             // 获取成功
                                                                             
                                                                         }];
    
    [readLastImageView removeFromSuperview];
    
    
    QMMessageCenterViewController *con = [[QMMessageCenterViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

// 帮助中心
- (void)gotoHelpCenter
{
    [QMUMTookKitManager event:SHOW_HELP_KEY label:@"显示帮助"];
    
    QMAssistCenterViewController *con = [[QMAssistCenterViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

// 个人中心
- (void)noticegotoMyFund
{
    if (isPeopleLoginClick == YES) {
        MyFundViewController *myFund = [[MyFundViewController alloc] init];
        myFund.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myFund animated:YES];
        isPeopleLoginClick = NO;
    }
}

- (void)gotoMyFund
{
    isPeopleLoginClick = YES;
    MyFundViewController *myFund = [[MyFundViewController alloc] init];
    myFund.hidesBottomBarWhenPushed = YES;
    if (![[QMAccountUtil sharedInstance] userHasLogin])
    {
        [QMLoginManagerUtil showLoginViewControllerFromViewController:self];
    }else
    {
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:myFund animated:YES];
        isPeopleLoginClick = NO;
    }
}


#pragma mark -
#pragma mark MainView

- (void)updataView
{
    //检测后台更新接口
//    NSInteger statusnum = 0;
//    if (statusnum == 2) {
//        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"系统维护中" message:@"维护时间:xx-xx" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//        [alertview show];
//    }else if (statusnum == 1)
//    {
//        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"系统维护通知" message:@"预计维护时间:xx-xx" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertview show];
//    }
    
    //实现上部分子view
    [self setUpSubViews];
    [[NSNotificationCenter defaultCenter] addObserverForName:QM_ACCOUNT_INFO_DID_SAVE
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                                                          // 登录成功之后，更新数据和UI
                                                          [self initDataSource];
                                                          [self updateLeftBarButtonItem];
                                                      }];
    [self registerNotification];
//    if ([self shouldShowGuideView]) {
//        [self showGuideView];
//    }
    if ([self needGetIdfa]==YES) {
        NSString *adid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        NSString *currentVersion =[NSString stringWithFormat:@"@!version!@%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        ;
        NSString *currentDevice =[NSString stringWithFormat:@"@!device!@%@",[[UIDevice currentDevice] systemVersion]];
        NSString *base_string = @"http://www.yrdloan.com/ad/private/activation?ukey=idfa!@";
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@",base_string,adid,currentDevice,currentVersion];
        AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:base_string]];
        [httpClient xsPostPath:urlString delegate:self params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = (NSDictionary *)[responseObject objectFromJSONData];
            if ([[dic objectForKey:@"code"] integerValue]==2) {
                [self needGetIdfa];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
    
    //更新数据
    [self initDataSource];
}

//上拉加载
- (void)doneLoadingTableViewData {
    [super doneLoadingTableViewData];
    [mImagePager reloadData];
    [(UITableView *)self.scrollView reloadData];
    [self reloadNumber];
}

- (void)reloadNumber
{
    registPeopleLbl.text = @"0";
    safeDayLbl.text = @"0";
    expiredLbl.text = @"0";
    rankTwoNameLbl.text = @"未上榜";
    rankOneNameLbl.text = @"未上榜";
    rankThreeNameLbl.text = @"未上榜";
    rankTwoLbl.text = @"";
    rankOneLbl.text = @"";
    rankThreeLbl.text = @"";
    
    [[NetServiceManager sharedInstance] getHomeDataWithDelegate:self success:^(id responseObject) {
        registPeopleLbl.text = [NSString stringWithFormat:@"%@",[responseObject safeStringForKey:@"customerCount"]];
        safeDayLbl.text = [NSString stringWithFormat:@"%@",[responseObject safeStringForKey:@"yunying"]];
        NSArray *rankarray = [responseObject safeArrayForKey:@"rank"];
        NSDictionary *rankonedict = [rankarray objectAtIndex:0];
        NSDictionary *ranktwodict = [rankarray objectAtIndex:1];
        NSDictionary *rankthreedict = [rankarray objectAtIndex:2];
        
        rankOneLbl.text = [self rankMoney:rankonedict];
        rankTwoLbl.text = [self rankMoney:ranktwodict];
        rankThreeLbl.text = [self rankMoney:rankthreedict];
        
        rankOneNameLbl.text = [self rankName:rankonedict];
        rankTwoNameLbl.text = [self rankName:ranktwodict];
        rankThreeNameLbl.text = [self rankName:rankthreedict];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (BOOL)shouldShowGuideView {
    if ([QMPreferenceUtil getGlobalBoolKey:PRODUCT_GUIDE_HAS_SHOW_KEY]) {
        return NO;
    }
    
    return YES;
}
- (BOOL)needGetIdfa{
    if ([QMPreferenceUtil getGlobalBoolKey:PRODUCT_GUIDE_HAS_SHOW_KEY]) {
        return NO;
    }
    
    return YES;

}
#pragma mark -
#pragma mark Override mthoeds
- (UIScrollView *)customScrollView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    mScrollView = tableView;
    tableView.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    mScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return tableView;
}


#pragma mark -
#pragma mark custom
- (void)setUpSubViews {
    [self setUpBannerView];
}

- (void)setUpBannerView {
    mImagePager = [[KIImagePager alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) , 140.0f * CGRectGetWidth([UIScreen mainScreen].bounds) / 320)];
//    NSLog(@"%f",CGRectGetWidth([UIScreen mainScreen].bounds));
    mImagePager.imageCounterDisabled = YES;
    mImagePager.dataSource = self;
    mImagePager.delegate = self;
    mImagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    mImagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    //设置scrollView滑动的时间间隔
    mImagePager.slideshowTimeInterval = 3.0f;
    mImagePager.slideshowShouldCallScrollToDelegate = YES;
    
    UIView *featuresview = [self setFeaturesViews];
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), mImagePager.frame.size.height + featuresview.frame.size.height)];
    [headview addSubview:mImagePager];
    [headview addSubview:featuresview];
    
    [(UITableView *)self.scrollView setTableHeaderView:headview];
}

#pragma mark -
#pragma mark Action
- (void)gotoBannerDetailViewControllerWithBannerAtIndex:(NSInteger)index {
      NSArray *bannerData = recommendationData.banners;
    if (!QM_IS_ARRAY_NIL(bannerData)) {
        NSDictionary *banner = [bannerData objectAtIndex:index];
        NSString *bannerHtmlURL = [banner objectForKey:@"htmlURL"];
        NSString *bannerURL = [banner objectForKey:@"htmlURL"];
        NSString *bannerTitle = [banner objectForKey:@"htmlTitle"];
        
        NSString *requestURL = [CMMUtility isStringOk:bannerURL] ? bannerURL : bannerHtmlURL;
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:requestURL]];
        
//      http://m.yrdloan.com/wap/active/app02
//        QMWebViewAdvertisementViewController *advertwebview = [[QMWebViewAdvertisementViewController alloc] init];
//        advertwebview.advertUrlString = requestURL;
//        [advertwebview setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:advertwebview animated:YES];
        
//        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://yrdloan.com/mobile/active/app02"]];
        
        [QMWebViewController showWebViewWithRequest:request navTitle:bannerTitle isModel:YES from:self];
        }
}

// 购买产品
- (void)buyProductBtnClicked:(UIButton *)btn {
    [self hideGuideView];
    
    if (![[QMAccountUtil sharedInstance] userHasLogin]) {
        [QMLoginManagerUtil showLoginViewControllerFromViewController:self];
    }else
    {
        // 打点
        [QMUMTookKitManager event:USER_CLICK_BUY_IN_RECOMMENDVIEW_KEY label:@"首页点击购买"];
        // 可以购买，进入详情页面
        QMProductInfoViewController *con = [[QMProductInfoViewController alloc] initViewControllerWithProductInfo:recommendationData.productionInfo];
        con.isModel = NO;
        [self.navigationController setNavigationBarHidden:NO];
        con.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:con animated:YES];
    }
}

- (void)nobuyProductBtnClicked:(UIButton *)btn {
    [QMLoginManagerUtil showLoginViewControllerFromViewController:self];
}

- (void)refreshBtnClicked:(id)sender {
    LNLogInfo(@"refreshBtnClicked !!!");
    [self.scrollView setContentOffset:CGPointMake(0, -66) animated:NO];
    [mRefreshHeaderView egoRefreshScrollViewDidEndDragging:self.scrollView];
}

- (void)loginBtnClicked:(id)sender {
    // 打点
    [QMUMTookKitManager event:USER_LOGIN_KEY label:@"用户登录"];
    
    LNLogInfo(@"loginBtnClicked !!!");
    [QMLoginManagerUtil showLoginViewControllerFromViewController:self.navigationController];
}

- (void)updateLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem = [self leftBarButtonItem];
}

- (UIBarButtonItem *)leftBarButtonItem {
    if (![[QMAccountUtil sharedInstance] userHasLogin]) {
        return [QMNavigationBarItemFactory createNavigationItemWithTitle:QMLocalizedString(@"qm_recommendation_login_btn_title", @"登录")
                                                                  target:self
                                                                selector:@selector(loginBtnClicked:)
                                                                  isLeft:YES];
    }
    
    return nil;
}

- (UIBarButtonItem *)rightBarButtonItem {
    return [QMNavigationBarItemFactory createNavigationItemWithTitle:QMLocalizedString(@"qm_recommendation_refresh_btn_title", @"刷新")
                                                              target:self
                                                            selector:@selector(refreshBtnClicked:)
                                                              isLeft:NO];
}

#pragma mark -
#pragma mark Init
- (void)initDataSource {
    [self asyncLoadDataFromServer];
}

// 从服务器中更新数据
- (void)asyncLoadDataFromServer {
    
    [[NetServiceManager sharedInstance] recommendedProductInfo:@"1"
                                                      delegate:self
                                                       success:^(id responseObject) {
                                                           [self handleFetchDataSuccess:responseObject];
                                                       } failure:^(NSError *error) {
                                                           [self handleFetchDataFailure:error];
                                                       }];
}

// 处理数据获取成功的回调
- (void)handleFetchDataSuccess:(NSDictionary *)responseObject {
    if (QM_IS_DICT_NIL(responseObject)) {
        [self doneLoadingTableViewData];
        return;
    }
    //条幅列表数组
    NSArray *banners = [responseObject objectForKey:@"bannerList"];
    //推荐产品信息字典
    NSDictionary *productInfo = [responseObject objectForKey:@"product"];
//    
    recommendationData = [[QMRecommendData alloc] init];
    if (!QM_IS_ARRAY_NIL(banners)) {
            recommendationData.banners = banners;
    }
    if (!QM_IS_DICT_NIL(productInfo)) {
            recommendationData.productionInfo = [[QMProductInfo alloc] initWithRecommandDictionary:productInfo];
    }
    
    [self doneLoadingTableViewData];
}

// 处理数据获取失败的回调
- (void)handleFetchDataFailure:(NSError *)error {
    [self doneLoadingTableViewData];
}

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages {
    NSArray *bannerData = recommendationData.banners;
    if (!QM_IS_ARRAY_NIL(bannerData)) {
        NSMutableArray *bannerImageURLs = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dic in bannerData) {
            NSString *bannerURL = [dic objectForKey:@"imageURI"];
            if ([CMMUtility isStringOk:bannerURL] && !QM_IS_STR_NIL(bannerURL)) {
                [bannerImageURLs addObject:bannerURL];
            }
        }
        return bannerImageURLs;
    }else{
        return nil;
    }
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image {
    return UIViewContentModeScaleAspectFill;
}

- (NSString *) captionForImageAtIndex:(NSUInteger)index {
    return @"";
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //one row in section
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取推荐产品cell的高度：336
    return [QMRecommendProductInfoCell getCellHeightForProductInfo:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    QMRecommendProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[QMRecommendProductInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.actionBtn addTarget:self action:@selector(buyProductBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (![[QMAccountUtil sharedInstance] userHasLogin]) {
        [cell.actionBtn setTitle:QMLocalizedString(@"qm_recommendation_nobuy_btn_title", @"注册登录") forState:UIControlStateNormal];
    }else
    {
        [cell.actionBtn setTitle:QMLocalizedString(@"qm_recommendation_buy_btn_title", @"购买") forState:UIControlStateNormal];
    }
    
    [cell configureCellWithProductionInfo:recommendationData.productionInfo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        // 打点
        [QMUMTookKitManager event:USER_CLICK_BUY_IN_RECOMMENDVIEW_KEY label:@"首页点击购买"];
        // 可以购买，进入详情页面
        QMProductInfoViewController *con = [[QMProductInfoViewController alloc] initViewControllerWithProductInfo:recommendationData.productionInfo];
        con.isModel = NO;
        [self.navigationController setNavigationBarHidden:NO];
        con.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:con animated:YES];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

#pragma mark - KIImagePager Delegate
- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index {
    if (imagePager != mImagePager) {
        return;
    }
    
    [self gotoBannerDetailViewControllerWithBannerAtIndex:index];
}

- (void)handleLoginStatusNotification:(NSNotification *)noti {
    [self updateLeftBarButtonItem];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginStatusNotification:) name:QM_LOGIN_SUCCESS_NOTIFICATION_KEY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginStatusNotification:) name:QM_REGISTER_SUCCESS_NOTIFICATION_KEY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginStatusNotification:) name:QM_LOGOUT_SUCCESS_NOTIFICATION_KEY object:nil];
}

- (void)unRegisterNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QM_LOGIN_SUCCESS_NOTIFICATION_KEY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QM_REGISTER_SUCCESS_NOTIFICATION_KEY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QM_LOGOUT_SUCCESS_NOTIFICATION_KEY object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QM_ACCOUNT_INFO_DID_SAVE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noticeLoginPeopleMessage object:nil];
    [self unRegisterNotification];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_navigation_title_recommendation", @"精品推荐");
}

@end
