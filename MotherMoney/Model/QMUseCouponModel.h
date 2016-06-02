//
//  QMUseCouponModel.h
//  MotherMoney
//
//  Created by liuyanfang on 15/9/17.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface QMUseCouponModel : BaseModel
@property(nonatomic,strong)NSString *ticketName;
@property(nonatomic,strong)NSString *ticketType;
@property(nonatomic,strong)NSString *endDate;
@property(nonatomic,strong)NSNumber *value;
@property (nonatomic, strong)NSNumber *expire;
@end
