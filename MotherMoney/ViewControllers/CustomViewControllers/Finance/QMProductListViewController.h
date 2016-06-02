//
//  QMProductListViewController.h
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/17.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMViewController.h"
#import "DLCustomSlideView.h"

@interface QMProductListViewController : QMViewController<DLCustomSlideViewDelegate>
@property (nonatomic, strong) DLCustomSlideView *slideView;

@end

