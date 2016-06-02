//
//  QMGoodListDetailViewController.h
//  MotherMoney
//
//  Created by liuyanfang on 15/8/14.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMPullRefreshAndPagingViewController.h"
#import "QMGoodListDetailModel.h"
@interface QMGoodListDetailViewController : QMPullRefreshAndPagingViewController
@property (nonatomic,strong)NSNumber* currentScore;
@property (nonatomic,strong)QMGoodListDetailModel *goodListModel;
//-(void)configureCurrentScore:(NSString*)currentScore;
@end
