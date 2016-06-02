//
//  QMPullRefreshViewController.h
//  MotherMoney
//
//  Created by   on 14-8-6.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface QMPullRefreshViewController : QMViewController<EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *mRefreshHeaderView;
    UIScrollView *mScrollView;
    BOOL mIsLoading;
}
@property (nonatomic, strong) UIScrollView *scrollView;

- (UIScrollView *)customScrollView;

- (void)reloadData;

- (void)doneLoadingTableViewData;

@end
