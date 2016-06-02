//
//  QMDetailCollectionViewCell.h
//  MotherMoney
//
//  Created by liuyanfang on 15/8/19.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMDetailControllerViewCellModel.h"
#import "QMGoodListDetailCellModel.h"
//明细cell
@interface QMDetailCollectionViewCell : UICollectionViewCell

//
@property(nonatomic,strong)UILabel* actionTitleLabel;
//日期
@property(nonatomic,strong)UILabel* dateLabel;
//
@property(nonatomic,strong)UILabel* actionNumberLabel;
//剩余钱数
@property(nonatomic,strong)UILabel* remainingLabel;

@property (nonatomic,strong)UIImageView* leftIconView;

@property (nonatomic,strong)QMDetailControllerViewCellModel *detailCellModel;

@property (nonatomic,strong)QMGoodListDetailCellModel *goodListCellModel;
-(void)configureDetailCell;
+(float)getDetailCellHeight;

@end
