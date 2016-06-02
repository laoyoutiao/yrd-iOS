//
//  QMViewController.h
//  MotherMoney
//
//  Created by   on 14-8-3.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMEmptyView.h"

@interface QMViewController : UIViewController

- (void)customOrUpdateNavigationBar;
- (UIBarButtonItem *)leftBarButtonItem;
- (UIBarButtonItem *)rightBarButtonItem;
-(NSArray*)leftBarButtonItems;
- (NSArray *)rightBarButtonItems;
- (void)leftBarButtonItemClicked;
- (void)rightBarButtonItemClicked;

- (UIRectEdge)customEdgesForExtendedLayout;

- (NSString *)backButtonTitle;

// 空列表是的提示文案
- (NSString *)emptyTitle;

// 显示空列表提示

-(void)showEmptyView;
// 隐藏空列表提示
- (void)hideEmptyView;

@end
