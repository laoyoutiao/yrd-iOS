//
//  QMNavigationController.m
//  MotherMoney
//
//  Created by   on 14-8-3.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMNavigationController.h"

@interface QMNavigationController ()

@end

@implementation QMNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateNavigationBar];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSDictionary *)navTitleAttributes {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    return attributes;
}

- (UIColor *)navBackgroundColor {
    return QM_THEME_COLOR;
}

- (UIImage *)navBackgroundImage {
    return [[UIImage imageNamed:@"common_bar_bg.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:32];
}

- (void)updateNavigationBar {
    // background appearance
    UIImage *navBackgroundImage = [self navBackgroundImage];
    UIColor *navBackgroundColor = [self navBackgroundColor];
    
    if (nil != navBackgroundImage) {
        [self.navigationBar setBackgroundImage:navBackgroundImage forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }else if (nil != navBackgroundColor) {
        [self.navigationBar setBarTintColor:navBackgroundColor];
    }else {
        
    }
    
    // title appearance
    NSDictionary *titleAttribute = [self navTitleAttributes];
    if (!QM_IS_DICT_NIL(titleAttribute)) {
        [self.navigationBar setTitleTextAttributes:titleAttribute];
    }
    
    [self.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)updateNavigationBarBgWithCurrentBackgroundImage {
    [self.navigationBar setBackgroundImage:[QMImageFactory commonNavigationBackgroundImageForCurrentFullScreenBackgroundImage] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
