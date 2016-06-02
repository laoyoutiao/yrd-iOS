//
//  QMProductCouponCollectionViewCell.m
//  MotherMoney
//
//  Created by liuyanfang on 15/9/16.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMProductCouponCollectionViewCell.h"
#define NAMECOLOR [UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f]

#define VALUECOLOR [UIColor colorWithRed:221.0f / 255.0f green:46.0f / 255.0f blue:28.0f / 255.0f alpha:1.0f]
#define TIMECOLOR [UIColor colorWithRed:153.0f / 255.0f green:153.0f / 255.0f blue:153.0f / 255.0f alpha:1.0f]

@implementation QMProductCouponCollectionViewCell{
    
    UILabel *couponName;
    UILabel *couponValue;
    UILabel *timeLabel;
    UILabel *title;
    UIImageView *bgImage;

}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.selected = NO;
        bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-50, frame.size.height)];
        
        bgImage.contentMode = UIViewContentModeScaleAspectFit;

        bgImage.image = [UIImage imageNamed:@"voucher_pay_bg"];
        
        bgImage.contentMode =UIViewContentModeRedraw;
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(bgImage.frame)/4, CGRectGetWidth(bgImage.frame)/10.0f*3.2f, 20)];
        
        title.font = [UIFont systemFontOfSize:12];
        
        title.textColor = NAMECOLOR;
        
        title.textAlignment = NSTextAlignmentCenter;
        
        couponName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgImage.frame)/10.0f*3.0f, CGRectGetHeight(bgImage.frame)/4, CGRectGetWidth(bgImage.frame)/10.0f*7.0f, 30)];
        
        couponName.textAlignment = NSTextAlignmentCenter;
        
        couponName.textColor = NAMECOLOR;
        
        couponName.font = [UIFont systemFontOfSize:12];
        
        couponValue = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(bgImage.frame)-CGRectGetHeight(bgImage.frame)/4-30, CGRectGetWidth(bgImage.frame)/10.0f*3.0f, 30)];
        
        couponValue.font = [UIFont systemFontOfSize:19];
        
        couponValue.textColor = VALUECOLOR;
        
        couponValue.textAlignment = NSTextAlignmentCenter;
        
        timeLabel= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgImage.frame)/10.0f*3.0f, CGRectGetHeight(bgImage.frame)-10-30, CGRectGetWidth(bgImage.frame)/10.0f*7.0f-10, 30)];
        
        timeLabel.font = [UIFont systemFontOfSize:11];
        
        timeLabel.textColor = TIMECOLOR;
        
        timeLabel.textAlignment = NSTextAlignmentRight;


        [bgImage addSubview:timeLabel];
        [bgImage addSubview:couponName];
        [bgImage addSubview:couponValue];
        [bgImage addSubview:title];
        [self addSubview:bgImage];
    }
    return self;
}
- (void)setModel:(QMProductCouponModel *)model{
    couponValue.text = [NSString stringWithFormat:@"¥%@",model.value];
    couponName.text = [NSString stringWithFormat:@"%@",model.ticketName];
    title.text = [NSString stringWithFormat:@"%@",model.ticketType];
    timeLabel.text = [NSString stringWithFormat:@"%@",model.endDate];
}
@end
