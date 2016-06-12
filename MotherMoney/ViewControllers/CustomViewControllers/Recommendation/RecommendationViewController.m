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
#define PRODUCT_GUIDE_HAS_SHOW_KEY @"PRODUCT_GUIDE_HAS_SHOW_KEY"

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
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self postAdvertisementInterface];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [self updateLeftBarButtonItem];
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
        
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *myDirectory = [documentsDirectory stringByAppendingPathComponent:@"test"];
                NSString *filePath = [myDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",model.AdverID]];
                NSLog(@"documentsDirectory --- %@",filePath);
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
                havePicture = YES;
                [pictureArray addObject:[file objectAtIndex:i]];
            }
        }
    }
    
    
    if (!havePicture) {
        [self downAdvertisementPicture:advertArray];
        [self updataView];
    }else
    {
        NSInteger randnum = arc4random() % [pictureArray count];
        NSString *idstr = [pictureArray objectAtIndex:!([pictureArray count] - 1)? 0:(randnum > 0? randnum:0)];
        NSString *fullPath = [[documentsDirectory stringByAppendingPathComponent:@"test"] stringByAppendingPathComponent:idstr];
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        [self showAdvertisementPicture:savedImage];
        
        for (int n = 0;n < [advertArray count]; n ++)
        {
            QMAdvertisementModel *model = [advertArray objectAtIndex:n];
            if ([idstr isEqualToString:[NSString stringWithFormat:@"%ld",model.AdverID]])
            {
                advertUrlString = model.AdverUrl;
            }
        }
    }
}

//显示广告页
- (void)showAdvertisementPicture:(UIImage *)advinimage
{
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
    QMWebViewAdvertisementViewController *advertwebview = [[QMWebViewAdvertisementViewController alloc] init];
    advertwebview.advertUrlString = advertUrlString;
    [advertwebview setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:advertwebview animated:YES];
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

- (void)updataView
{
    //实现上部分子view
    [self setUpSubViews];
    [[NSNotificationCenter defaultCenter] addObserverForName:QM_ACCOUNT_INFO_DID_SAVE
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                                                          // 登录成功之后，更新数据和UI
                                                          [self initDataSource];
                                                          [self updateLeftBarButtonItem];
                                                      }];
    [self registerNotification];
    if ([self shouldShowGuideView]) {
        [self showGuideView];
    }
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
    [(UITableView *)self.scrollView setTableHeaderView:mImagePager];
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
        [QMWebViewController showWebViewWithRequest:request navTitle:bannerTitle isModel:YES from:self];
        }
}

// 购买产品
- (void)buyProductBtnClicked:(UIButton *)btn {
    [self hideGuideView];
    
    // 打点
    [QMUMTookKitManager event:USER_CLICK_BUY_IN_RECOMMENDVIEW_KEY label:@"首页点击购买"];
    
    // 可以购买，进入详情页面
    QMProductInfoViewController *con = [[QMProductInfoViewController alloc] initViewControllerWithProductInfo:recommendationData.productionInfo];
    con.isModel = NO;
    
    [self.navigationController pushViewController:con animated:YES];
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
    [cell configureCellWithProductionInfo:recommendationData.productionInfo];
    
    return cell;
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
    [self unRegisterNotification];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_navigation_title_recommendation", @"精品推荐");
}

@end
