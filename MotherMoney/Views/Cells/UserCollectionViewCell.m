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
#define TIMECOLOR [UIColor colorWithRed:255.0f / 255.0f green:205.0f / 255.0f blue:172.0f / 255.0f alpha:1.0f]
@implementation UserCollectionViewCell{
    UILabel *couponName;
    UILabel *couponValue;
    UILabel *timeLabel;
    UIImageView *bgImage;
    UILabel *title;
    UILabel *explain;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"voucher_list_bg"]];
        
        
        bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, frame.size.width - 30, frame.size.height)];
        
//        bgImage.contentMode = UIViewContentModeScaleAspectFit;
        self.backgroundView = bgImage;
        
        bgImage.contentMode =UIViewContentModeRedraw;
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(bgImage.frame)/10.0f*3.6f, 20)];
        
        title.font = [UIFont systemFontOfSize:16];
        
        title.textColor = [UIColor whiteColor];
        
        title.textAlignment = NSTextAlignmentCenter;
        
        couponValue = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(bgImage.frame)-CGRectGetHeight(bgImage.frame)/4-30, CGRectGetWidth(bgImage.frame)/10.0f*3.6f, 35)];
        
        //        couponValue.text = [NSString stringWithFormat:@"¥6"];
        
        couponValue.font = [UIFont systemFontOfSize:35];
        
        couponValue.textColor = [UIColor whiteColor];
        
        couponValue.textAlignment = NSTextAlignmentCenter;
        
        couponName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgImage.frame)/10.0f*3.5f + 20, 15, CGRectGetWidth(bgImage.frame)/10.0f*5.0f, 30)];
        
//        couponName.text = @"所有产品通用";
        
        couponName.textAlignment = NSTextAlignmentLeft;
        
        couponName.textColor = [UIColor whiteColor];
        
        couponName.font = [UIFont boldSystemFontOfSize:16];
        
        explain = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgImage.frame)/10.0f*3.5f + 20, 35, CGRectGetWidth(bgImage.frame)/10.0f*5.0f, 50)];
        
        //        couponName.text = @"所有产品通用";
        
        explain.textAlignment = NSTextAlignmentLeft;
        explain.numberOfLines = 2;
        explain.textColor = TIMECOLOR;
        
        explain.font = [UIFont systemFontOfSize:12];
        
        timeLabel= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgImage.frame)/10.0f*3.5f + 20, CGRectGetHeight(bgImage.frame) - 35, 120, 30)];
        
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = TIMECOLOR;
        
        timeLabel.textAlignment = NSTextAlignmentLeft;
        [bgImage addSubview:timeLabel];
        [bgImage addSubview:couponName];
        [bgImage addSubview:couponValue];
        [bgImage addSubview:title];
        [bgImage addSubview:explain];

    }
    return self;
}
- (void)setModel:(QMUseCouponModel *)model{
    
    
    
    couponValue.text = [NSString stringWithFormat:@"¥%@",model.value];

    explain.text = [NSString stringWithFormat:@"%@",model.explanation];
    
    couponName.text = [NSString stringWithFormat:@"%@",model.ticketName];
    
    title.text = [NSString stringWithFormat:@"%@",model.ticketType];
    
    if ([model.ticketType isEqualToString:@"积分抢购体验券"]) {
        couponValue.text = @"100积分";
        couponValue.font = [UIFont systemFontOfSize:20];
        title.text = [title.text substringFromIndex:4];
    }else if ([model.ticketType isEqualToString:@"加息券"])
    {
        couponValue.text = model.extraInterest;
    }
    
    if ([model.expire boolValue]==NO) {
        bgImage.image =[UIImage imageNamed:@"voucher_list_bg_red"];
        
        timeLabel.text = [NSString stringWithFormat:@"%@ 到期",model.endDate];
    }else{
        bgImage.image = [UIImage imageNamed:@"voucher_list_bg_red"];
        
        timeLabel.text = [NSString stringWithFormat:@"%@ 已过期",model.endDate];
    }
    
}
@end
