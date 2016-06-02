//
//  QMSelectBankViewControllerV2.h
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/19.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMViewController.h"
#import "QMBankCardModel.h"

@protocol QMSelectBankViewControllerV2Delegate;
@interface QMSelectBankViewControllerV2 : QMViewController
@property (nonatomic, weak) id<QMSelectBankViewControllerV2Delegate> delegate;

@end

@protocol QMSelectBankViewControllerV2Delegate <NSObject>

- (void)selectBankViewController:(QMSelectBankViewControllerV2 *)con didSelectBank:(QMBankCardModel *)model;
- (void)selectBankViewControllerDidCancel:(QMSelectBankViewControllerV2 *)con;

@end

