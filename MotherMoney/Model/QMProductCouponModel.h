//
//  QMProductCouponModel.h
//  MotherMoney
//
//  Created by liuyanfang on 15/9/17.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "BaseModel.h"

@interface QMProductCouponModel : BaseModel
@property(nonatomic,strong)NSString *ticketName;
@property(nonatomic,strong)NSString *ticketType;
@property(nonatomic,strong)NSString *endDate;
@property(nonatomic,strong)NSNumber *value;
@property(nonatomic,strong)NSString *useCode;
@property(nonatomic,strong)NSNumber *useLimit;
@property(nonatomic,assign)NSNumber *expire;
@property (nonatomic, strong)NSString *extraInterest;
@property (nonatomic, strong)NSString *explanation;

@end
