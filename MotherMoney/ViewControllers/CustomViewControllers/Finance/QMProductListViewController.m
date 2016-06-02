//
//  QMProductListViewController.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/17.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMProductListViewController.h"
#import "FinanceViewController.h"
#import "DLScrollTabbarView.h"
#import "DLLRUCache.h"
//产品列表，理财产品
@interface QMProductListViewController ()

@end

@implementation QMProductListViewController {
    NSMutableArray *itemArray;
    
    FinanceViewController *finance1;
    FinanceViewController *finance2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [self setUpSubViewControllers];
    
    self.slideView = [[DLCustomSlideView alloc] initWithFrame:CGRectZero];
    self.slideView.backgroundColor = [UIColor whiteColor];
    self.slideView.delegate = self;
    [self.view addSubview:self.slideView];
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    
    DLLRUCache *cache = [[DLLRUCache alloc] initWithCount:6];
    DLScrollTabbarView *tabbar = [[DLScrollTabbarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    tabbar.tabItemNormalColor = [UIColor blackColor];
    tabbar.tabItemSelectedColor = QM_THEME_COLOR;
    tabbar.tabItemNormalFontSize = 14.0f;
    tabbar.trackColor = QM_THEME_COLOR;
    itemArray = [NSMutableArray array];
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    DLScrollTabbarItem *item = [DLScrollTabbarItem itemWithTitle:@"钱宝宝" width:width /2.0f];
    [itemArray addObject:item];
    
//    DLScrollTabbarItem *item2 = [DLScrollTabbarItem itemWithTitle:@"钱生钱" width:width / 2.0f];
//    [itemArray addObject:item2];
    tabbar.tabbarItems = itemArray;
    
//    self.slideView.tabbar = tabbar;
    self.slideView.cache = cache;
    self.slideView.tabbarBottomSpacing = 0;
    self.slideView.baseViewController = self;
    [self.slideView setup];
    self.slideView.selectedIndex = 0;
    ////////////////////////////////////
    
    [[NSNotificationCenter defaultCenter] addObserverForName:QM_ACCOUNT_INFO_DID_SAVE
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                                                          [self updateLeftBarButtonItem];
                                                      }];
    [self registerNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateLeftBarButtonItem];
}

- (void)loginBtnClicked:(id)sender {
    // 点击登录
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

- (void)refreshBtnClicked:(id)sender {
    // 判断当前是哪一个ViewController
//    if (finance1.parentViewController) {
        [finance1 refreshBtnClicked:sender];
//    }
//    else if (finance2.parentViewController) {
//        [finance2 refreshBtnClicked:sender];
//    }
}

- (void)setUpSubViewControllers {
    finance1 = [[FinanceViewController alloc] initViewControllerWithChannelId:@"2"];
    finance1.hidesBottomBarWhenPushed = NO;
    
    finance2 = [[FinanceViewController alloc] initViewControllerWithChannelId:@"1"];
    finance2.hidesBottomBarWhenPushed = NO;
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

#pragma mark -
#pragma mark DLCustomSlideViewDelegate
- (NSInteger)numberOfTabsInDLCustomSlideView:(DLCustomSlideView *)sender{
    return [itemArray count];
}

- (UIViewController *)DLCustomSlideView:(DLCustomSlideView *)sender controllerAt:(NSInteger)index{
    if (index == 0) {
        return finance1;
    }else if (index == 1) {
        return finance2;
    }
    
    return nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QM_ACCOUNT_INFO_DID_SAVE object:nil];
    [self unRegisterNotification];
}

- (NSString *)title {
    return QMLocalizedString(@"qm_navigation_title_finance", @"理财产品");
}

@end


