//
//  QMMyFundBuyProductRecordView.h
//  MotherMoney
//
//  Created by liuyanfang on 15/8/18.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBuyedProductResolveModel.h"
@interface QMMyFundBuyProductRecordView : UIView
@property (nonatomic,strong)UILabel* buyTimeLabel;
@property(nonatomic,strong)UILabel* buyTimeValueLabel;
@property(nonatomic,strong)UILabel* endTimeLabel;
@property(nonatomic,strong)UILabel* endTimeValueLabel;
@property(nonatomic,strong)UILabel* principalLabel;
@property(nonatomic,strong)UILabel* principalValueLabel;
@property(nonatomic,strong)UILabel*earningLabel;
@property(nonatomic,strong)UILabel* earningValueLabel;
@property(nonatomic,strong)UILabel* statusLabel;
@property(nonatomic,strong)UILabel*statusValueLabel;
@property(nonatomic,strong)UIButton*templateBtn;
@property(nonatomic,strong)UIViewController* controller;
-(void)configureView:(QMBuyedProductResolveModel*)model;
-(void)configureCurrentViewController:(UIViewController*)controller;
@end
