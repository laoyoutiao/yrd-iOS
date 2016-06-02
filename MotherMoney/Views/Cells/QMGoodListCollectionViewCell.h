//
//  QMGoodListCollectionViewCell.h
//  MotherMoney
//
//  Created by liuyanfang on 15/9/1.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMGoodListDetailCellModel.h"
@interface QMGoodListCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UILabel* actionTitleLabel;

@property(nonatomic,strong)UILabel* dateLabel;

@property(nonatomic,strong)UILabel* actionNumberLabel;

@property(nonatomic,strong)UILabel* remainingLabel;

@property (nonatomic,strong)UIImageView* leftIconView;

@property (nonatomic,strong)QMGoodListDetailCellModel *goodListCellModel;
-(void)configureDetailCell;
+(float)getDetailCellHeight;
@end
