//
//  QMCouponViewController.m
//  MotherMoney
//
//  Created by liuyanfang on 15/9/10.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMCouponViewController.h"
#import "DLScrollTabbarView.h"
#import "DLLRUCache.h"
#import "UnuseViewController.h"
#import "UseViewController.h"
@interface QMCouponViewController (){
    NSMutableArray *itemArray;
    UnuseViewController *vc2;
    UseViewController *vc1;
}
@end

@implementation QMCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    DLScrollTabbarView *tabbar = [[DLScrollTabbarView alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    
    tabbar.tabItemNormalColor = [UIColor blackColor];
    tabbar.tabItemSelectedColor = QM_THEME_COLOR;
    tabbar.tabItemNormalFontSize = 14.0f;
    tabbar.trackColor = QM_THEME_COLOR;
    itemArray = [NSMutableArray array];
    
    DLScrollTabbarItem *item = [DLScrollTabbarItem itemWithTitle:@"可使用" width:width /2.0f];
    [itemArray addObject:item];
    
    DLScrollTabbarItem *item2 = [DLScrollTabbarItem itemWithTitle:@"已使用" width:width / 2.0f];
    [itemArray addObject:item2];
    tabbar.tabbarItems = itemArray;
    
    self.slideView.tabbar = tabbar;
    self.slideView.cache = cache;
    self.slideView.tabbarBottomSpacing = 5;
    self.slideView.baseViewController = self;
    [self.slideView setup];
    self.slideView.selectedIndex = 0;

}
- (NSInteger)numberOfTabsInDLCustomSlideView:(DLCustomSlideView *)sender{
    return [itemArray count];
}

- (UIViewController *)DLCustomSlideView:(DLCustomSlideView *)sender controllerAt:(NSInteger)index{
    if (index == 0) {
        return vc1;
    }else if (index == 1) {
        return vc2;
    }
    
    return nil;
}
- (void)setUpSubViewControllers {
    vc1 = [[UseViewController alloc] init];
    vc1.hidesBottomBarWhenPushed = NO;
    
    vc2 = [[UnuseViewController alloc] init];
    vc2.hidesBottomBarWhenPushed = NO;
    
    
}
- (NSString *)title{
    return QMLocalizedString(@"qm_navigation_title_mycoupon", @"代金券明细");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
