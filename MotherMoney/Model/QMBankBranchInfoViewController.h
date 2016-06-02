//
//  QMBankBranchInfoViewController.h
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/14.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMViewController.h"
#import "QMBankBranchInfo.h"
#import "QMSelectItemViewController.h"
//银行支行信息
@protocol QMBankBranchInfoViewControllerDelegate;
@interface QMBankBranchInfoViewController : QMSelectItemViewController
@property (nonatomic, weak) id<QMBankBranchInfoViewControllerDelegate> myDelegate;

- (id)initViewControllerWithKeyWord:(NSString *)keyword cardNumber:(NSString *)cardNumber cityCode:(NSString *)cityCode;

@end

@protocol QMBankBranchInfoViewControllerDelegate <NSObject>

- (void)bankBranchInfoViewController:(QMBankBranchInfoViewController *)controller didSelectBankBranch:(QMBankBranchInfo *)info;
- (void)bankBranchInfoViewControllerDidCancel:(QMBankBranchInfoViewController *)controller;

@end
