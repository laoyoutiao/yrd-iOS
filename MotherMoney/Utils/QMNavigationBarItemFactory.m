//
//  QMNavigationBarItemFactory.m
//  MotherMoney
//
//  Created by   on 14-8-4.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMNavigationBarItemFactory.h"

@implementation QMNavigationBarItemFactory

+ (UIBarButtonItem *)createNavigationImageButtonWithNormalImage:(UIImage *)normalImage
                                                        hlImage:(UIImage *)hlImage
                                                         target:(id)target
                                                       selector:(SEL)selector
                                                         isLeft:(BOOL)isLeft {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStylePlain target:target action:selector];
    if (isLeft) {
        item.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }else {
        item.imageInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    }
    
    if (hlImage) {
        [item setBackButtonBackgroundImage:hlImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    }
    
    item.tintColor = [UIColor whiteColor];
    
    return item;
}

+(UIBarButtonItem *)createNavigationItemWithTitle:(NSString *)title
                                           target:(id)target
                                         selector:(SEL)selector
                                           isLeft:(BOOL)isLeft {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title
                                                             style:UIBarButtonItemStylePlain
                                                            target:target
                                                            action:selector];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.9f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    return item;
}
+ (UIBarButtonItem *)createNavigationReloadItemWithTarget:(id)target selector:(SEL)selector{
    UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadBtn.frame = CGRectMake(0, 0, 60, 40);
    reloadBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -7);
    reloadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    reloadBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 0);
    reloadBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [reloadBtn setTitle:QMLocalizedString(@"qm_navigation_close_title", @"关闭") forState:UIControlStateNormal];
//    [reloadBtn setImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
//    UIEdgeInsetsMake
//    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
//    reloadBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
//    reloadBtn.imageEdgeInsets =UIEdgeInsetsMake(0, 50, 0, 0);
    [reloadBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [reloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:reloadBtn];
    
    return backItem;

}
+ (UIBarButtonItem *)createNavigationBackItemWithTarget:(id)target selector:(SEL)selector {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 60, 40);
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 0);
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn setImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
    [backBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitle:QMLocalizedString(@"qm_navigation_back_title", @"返回") forState:UIControlStateNormal];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    return backItem;
}

@end
