//
//  QMBankInfoCell.h
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/21.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBankCardModel.h"

@interface QMBankInfoCell : UICollectionViewCell
@property (nonatomic, strong) UIButton *actionBtn;
@property (nonatomic, assign) BOOL withDraw;
@property (nonatomic, assign) BOOL withDrawCard;
@property (nonatomic, assign) BOOL withOnlyCard;
@property (nonatomic, strong) UILabel *mPromptLabel;
@property (nonatomic, strong) UILabel *bankNameLable;
@property (nonatomic, strong) UILabel *bankCardLabel;

- (void)configureCellWithBankCardModel:(QMBankCardModel *)model;
+ (CGFloat)getCellHeightWithBankCardModel:(QMBankCardModel *)model;
- (void)addCheckBox;

@end
