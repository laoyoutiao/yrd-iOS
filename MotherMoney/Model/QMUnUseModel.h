//
//  QMUnUseModel.h
//  MotherMoney
//
//  Created by liuyanfang on 15/9/21.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "BaseModel.h"

@interface QMUnUseModel : BaseModel
@property(nonatomic,strong)NSString *ticketName;
@property(nonatomic,strong)NSString *ticketType;
@property(nonatomic,strong)NSNumber *value;
@property(nonatomic,strong)NSNumber *expire;
@property(nonatomic,strong)NSString *endDate;
@end
