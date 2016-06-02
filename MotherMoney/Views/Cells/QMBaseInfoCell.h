//
//  QMBaseInfoCell.h
//  MotherMoney
//
//  Created by liuyanfang on 15/8/11.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMMyFundModel.h"
@interface QMBaseInfoCell : UICollectionViewCell

@property (nonatomic,strong)UIButton* userInfoBtn;//个人中心按钮
@property (nonatomic,strong)UIButton* dealDetailBtn;
@property (nonatomic,strong)UIButton* investRecordBtn;
@property (nonatomic,strong)UIButton* goodListBtn;
@property (nonatomic,strong)UIButton* rechargeBtn;
@property (nonatomic,strong)UIButton* withDrawBtn;

+ (CGFloat)getBaseInfoViewHeightForFundInfo:(QMMyFundModel *)info;

- (void)configureWithFundInfo:(QMMyFundModel *)info;

@end
