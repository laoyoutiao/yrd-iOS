//
//  UserCollectionViewCell.m
//  MotherMoney
//
//  Created by liuyanfang on 15/9/14.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "UserCollectionViewCell.h"
#define NAMECOLOR [UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f]

#define VALUECOLOR [UIColor colorWithRed:221.0f / 255.0f green:46.0f / 255.0f blue:28.0f / 255.0f alpha:1.0f]
#define TIMECOLOR [UIColor colorWithRed:153.0f / 255.0f green:153.0f / 255.0f blue:153.0f / 255.0f alpha:1.0f]
@implementation UserCollectionViewCell{
    UILabel *couponName;
    UILabel *couponValue;
    UILabel *timeLabel;
    UIImageView *bgImage;
    UILabel *title;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"voucher_list_bg"]];
        
        
        bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        bgImage.contentMode = UIViewContentModeScaleAspectFit;
        self.backgroundView = bgImage;
        
        bgImage.contentMode =UIViewContentModeRedraw;
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(bgImage.frame)/4, CGRectGetWidth(bgImage.frame)/10.0f*3.2f, 20)];
        
        title.font = [UIFont systemFontOfSize:12];
        
        title.textColor = NAMECOLOR;
        
        title.textAlignment = NSTextAlignmentCenter;
        
        couponName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgImage.frame)/10.0f*3.0f, CGRectGetHeight(bgImage.frame)/4, CGRectGetWidth(bgImage.frame)/10.0f*7.0f, 30)];
        
//        couponName.text = @"所有产品通用";
        
        couponName.textAlignment = NSTextAlignmentCenter;
        
        couponName.textColor = NAMECOLOR;
        
        couponName.font = [UIFont systemFontOfSize:12];
        
        couponValue = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(bgImage.frame)-CGRectGetHeight(bgImage.frame)/4-30, CGRectGetWidth(bgImage.frame)/10.0f*3.0f, 30)];
        
//        couponValue.text = [NSString stringWithFormat:@"¥6"];
        
        couponValue.font = [UIFont systemFontOfSize:19];
        
        couponValue.textColor = VALUECOLOR;
        
        couponValue.textAlignment = NSTextAlignmentCenter;
        
        timeLabel= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgImage.frame)-20-120, CGRectGetHeight(bgImage.frame)-5-30, 120, 30)];
        
        timeLabel.font = [UIFont systemFontOfSize:11];
        
        timeLabel.textColor = TIMECOLOR;
        
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [bgImage addSubview:timeLabel];
        [bgImage addSubview:couponName];
        [bgImage addSubview:couponValue];
        [bgImage addSubview:title];

    }
    return self;
}
- (void)setModel:(QMUseCouponModel *)model{
    
    
    
    couponValue.text = [NSString stringWithFormat:@"¥%@",model.value];
    
    couponName.text = [NSString stringWithFormat:@"%@",model.ticketName];
    
    title.text = [NSString stringWithFormat:@"%@",model.ticketType];
    
    if ([model.expire boolValue]==NO) {
        bgImage.image =[UIImage imageNamed:@"voucher_list_bg"];
        
        timeLabel.text = [NSString stringWithFormat:@"%@ 到期",model.endDate];
    }else{
        bgImage.image = [UIImage imageNamed:@"voucher_list_bg2"];
        
        timeLabel.text = [NSString stringWithFormat:@"%@ 已过期",model.endDate];
    }
    
}
@end
