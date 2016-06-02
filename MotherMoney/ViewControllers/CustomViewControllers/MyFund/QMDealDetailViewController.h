//
//  QMDealDetailViewController.h
//  MotherMoney
//
//  Created by liuyanfang on 15/8/19.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMPullRefreshAndPagingViewController.h"
#import "QMDealDetailViewControllerModel.h"
@interface QMDealDetailViewController : QMPullRefreshAndPagingViewController
@property (assign,nonatomic) BOOL hasRealName;
@property (nonatomic,strong)QMDealDetailViewControllerModel *detailModel;
-(void)configureRealName:(BOOL)hasRealName;
@end
