//
//  QMViewController.m
//  MotherMoney
//
//  Created by   on 14-8-3.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMViewController.h"

@interface QMViewController ()

@end

@implementation QMViewController {
    QMEmptyView *emptyView;
}

- (id)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[self backButtonTitle] style:UIBarButtonItemStylePlain target:nil action:nil];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = [self customEdgesForExtendedLayout];
    [self customOrUpdateNavigationBar];
}

- (NSString *)backButtonTitle {
    return QMLocalizedString(@"qm_navigation_back_title", @"返回");
}

- (UIRectEdge)customEdgesForExtendedLayout {
    return UIRectEdgeNone;
}

- (void)customOrUpdateNavigationBar {
    // left item
    UIBarButtonItem *leftItem = [self leftBarButtonItem];
    if (nil != leftItem) {
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
    
    // right item
    UIBarButtonItem *rightItem = [self rightBarButtonItem];
    if (nil != rightItem) {
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    if ([self leftBarButtonItems]) {
        self.navigationItem.leftBarButtonItems=[self leftBarButtonItems];
    }
    if ([self rightBarButtonItems]) {
        self.navigationItem.rightBarButtonItems=[self rightBarButtonItems];
    }
}
-(NSArray*)leftBarButtonItems
{
    return nil;
}
-(NSArray*)rightBarButtonItems
{
    return nil;
}
- (UIBarButtonItem *)leftBarButtonItem {
    return nil;
}

- (UIBarButtonItem *)rightBarButtonItem {
    return nil;
}

- (void)leftBarButtonItemClicked {
    
}

- (void)rightBarButtonItemClicked {
    
}

// 空列表是的提示文案
- (NSString *)emptyTitle {
    return QMLocalizedString(@"qm_default_empty_text", @"列表为空");
}

// 显示空列表提示
- (void)showEmptyView {
    if (nil == emptyView) {
        emptyView = [[QMEmptyView alloc] initWithFrame:self.view.bounds];
        emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        emptyView.textLabel.text = [self emptyTitle];
        emptyView.userInteractionEnabled = NO;
        [self.view addSubview:emptyView];
    }
    
    if (nil == [emptyView superview]) {
        [self.view addSubview:emptyView];
    }
    
    [self.view bringSubviewToFront:emptyView];
}

// 隐藏空列表提示
- (void)hideEmptyView {
    if (nil != [emptyView superview]) {
        [emptyView removeFromSuperview];
    }
    
    emptyView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
