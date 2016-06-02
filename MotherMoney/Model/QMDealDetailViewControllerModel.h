//
//  QMDealDetailViewControllerModel.h
//  MotherMoney
//
//  Created by liuyanfang on 15/8/28.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "BaseModel.h"

@interface QMDealDetailViewControllerModel : BaseModel
@property (nonatomic,strong)NSString *ableWithdrawalAmount;
@property (nonatomic,strong)NSString *customerPointTypeName;
@property (nonatomic,strong)NSNumber *availableAmount;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSNumber *pointColorType;
@property (nonatomic,strong)NSNumber *amount;
@property (nonatomic,strong)NSNumber *plus;
@end
