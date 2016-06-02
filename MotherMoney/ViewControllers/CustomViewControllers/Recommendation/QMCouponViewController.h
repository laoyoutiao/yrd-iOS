//
//  QMCouponViewController.h
//  MotherMoney
//
//  Created by liuyanfang on 15/9/10.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMViewController.h"
#import "DLCustomSlideView.h"
@interface QMCouponViewController : QMViewController<DLCustomSlideViewDelegate>
@property (nonatomic, strong) DLCustomSlideView *slideView;
@end
