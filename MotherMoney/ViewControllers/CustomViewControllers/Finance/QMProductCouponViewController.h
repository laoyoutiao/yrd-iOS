//
//  QMProductCouponViewController.h
//  MotherMoney
//
//  Created by liuyanfang on 15/9/16.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMViewController.h"
#import "QMProductCouponModel.h"
@protocol QMProductCouponViewControllerDelegate <NSObject>

-(void) userSelectedWithName:(NSString * )name value:(double )value useCode:(NSString *)useCode useLimit:(double)useLimit;


@end

@interface QMProductCouponViewController : QMViewController
@property(nonatomic,strong)NSString *ticketCode;
@property(nonatomic,strong)NSString *productId;
@property(nonatomic,retain)id<QMProductCouponViewControllerDelegate> delegate;
@property(nonatomic,strong)QMProductCouponModel *model;
- (id)initViewControllerWithUseCode:(NSString *)ticketCode;
@end
