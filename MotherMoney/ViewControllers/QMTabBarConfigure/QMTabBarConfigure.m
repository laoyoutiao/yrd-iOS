//
//  QMTabBarConfigure.m
//  MotherMoney
//
//  Created by   on 14-8-3.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMTabBarConfigure.h"
#import "AppDelegate.h"
#import "QMProductListViewController.h"

@implementation QMTabBarConfigure

+ (QMTabBarController *)configuredTabBarController {
    QMTabBarController *tabBarController = [[QMTabBarController alloc] init];
    tabBarController.delegate = [AppDelegate appDelegate];
    tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"tab_bar_bg"];
    
    // 精品推荐
    RecommendationViewController *recomend = [[RecommendationViewController alloc] init];
    recomend.hidesBottomBarWhenPushed = NO;
    QMNavigationController *recommendNav = [[QMNavigationController alloc] initWithRootViewController:recomend];
    recomend.tabBarItem = [self recommendTabBarItem];
    
    // 理财产品
    QMProductListViewController *products = [[QMProductListViewController alloc] init];
    products.hidesBottomBarWhenPushed = NO;
    QMNavigationController *financeNav = [[QMNavigationController alloc] initWithRootViewController:products];
    products.tabBarItem = [self financeTabBarItem];
    
    // 我的资产
    MyFundViewController *myFund = [[MyFundViewController alloc] init];
    myFund.hidesBottomBarWhenPushed = NO;
    QMNavigationController *myFundNav = [[QMNavigationController alloc] initWithRootViewController:myFund];
    myFund.tabBarItem = [self myFundTabBarItem];
    
    // 更多
    MoreViewController *more = [[MoreViewController alloc] init];
    more.hidesBottomBarWhenPushed = NO;
    QMNavigationController *moreNav = [[QMNavigationController alloc] initWithRootViewController:more];
    more.tabBarItem = [self moreTabBarItem];
    
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:recommendNav, financeNav, myFundNav, moreNav, nil];
    [tabBarController setViewControllers:viewControllers];
    
    [self customTabBarAppearance:tabBarController];
    
    return tabBarController;
}

+ (void)customTabBarAppearance:(QMTabBarController *)tabBarController {
    
}

+ (UITabBarItem *)myFundTabBarItem {
    return [self commonTabBarItemWithTitle:QMLocalizedString(@"qm_tab_title_myfund", @"我的资产") normalImageName:@"mine_nm.png" selectedImageName:@"mine_selected.png"];
}

+ (UITabBarItem *)moreTabBarItem {
    return [self commonTabBarItemWithTitle:QMLocalizedString(@"qm_tab_title_more", @"更多") normalImageName:@"more_nm.png" selectedImageName:@"more_selected.png"];
}

+ (UITabBarItem *)recommendTabBarItem {
    return [self commonTabBarItemWithTitle:QMLocalizedString(@"qm_tab_title_recommendation", @"精品推荐") normalImageName:@"home_nm.png" selectedImageName:@"home_selected.png"];
}

+ (UITabBarItem *)financeTabBarItem {
    return [self commonTabBarItemWithTitle:QMLocalizedString(@"qm_tab_title_finance", @"理财产品") normalImageName:@"diary_nm.png" selectedImageName:@"diary_selected.png"];
}

+ (UITabBarItem *)commonTabBarItemWithTitle:(NSString *)title
                            normalImageName:(NSString *)normalName
                          selectedImageName:(NSString *)selectedName {
    UIImage *image = [[self commonScaledImageFromImage:[UIImage imageNamed:normalName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *selectedImage = [[self commonScaledImageFromImage:[UIImage imageNamed:selectedName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
    
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10], NSFontAttributeName, [UIColor colorWithRed:231.0f / 255.0f green:108.0f / 255.0f blue:96.0f / 255.0f alpha:1.0f], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10], NSFontAttributeName, [UIColor grayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    return item;
}

+ (UIImage *)commonScaledImageFromImage:(UIImage *)img {
    return img;
}

@end
