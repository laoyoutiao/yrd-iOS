//
//  QMGoodListDetailCellModel.h
//  MotherMoney
//
//  Created by liuyanfang on 15/9/1.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "BaseModel.h"

@interface QMGoodListDetailCellModel : BaseModel
@property (nonatomic,strong)NSNumber *availableScore;
@property (nonatomic,strong)NSString *scoreOperTypeName;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSNumber *plus;
@property (nonatomic,strong)NSNumber *score;
@end
