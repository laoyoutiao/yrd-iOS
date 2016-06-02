//
//  QMCouponCollectionViewCell.m
//  MotherMoney
//
//  Created by liuyanfang on 15/9/10.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMCouponCollectionViewCell.h"
#import "QMImageFactory.h"
@implementation QMCouponCollectionViewCell
{
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40)];
        
        label.text = @"一个代金券";
        
        label.textAlignment = NSTextAlignmentLeft;
        
        self.horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        self.horizontalLine.frame = CGRectMake(5,CGRectGetHeight(self.frame)-1, self.bounds.size.width-10, 1);
        [self addSubview:self.horizontalLine];
        [self addSubview:label];
    }
    return self;
}
@end
