//
//  FinanceViewController.h
//  MotherMoney
//
//  Created by on 14-8-3.
//  Copyright (c) 2014年. All rights reserved.
//

#import "QMViewController.h"
#import "QMProductInfoViewController.h"
#import "QMPullRefreshAndPagingViewController.h"

// 理财产品
@interface FinanceViewController : QMPullRefreshAndPagingViewController

- (id)initViewControllerWithChannelId:(NSString *)channelId;

- (void)refreshBtnClicked:(id)sender;

@end
