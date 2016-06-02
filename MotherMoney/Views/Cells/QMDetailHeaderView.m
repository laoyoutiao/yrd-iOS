//
//  QMDetailHeaderView.m
//  MotherMoney
//
//  Created by liuyanfang on 15/8/19.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMDetailHeaderView.h"

@implementation QMDetailHeaderView
{
    UIImageView* remainingView;
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    
    
    
    
    if (self=[super initWithFrame:frame]) {
        remainingView=[[UIImageView alloc] initWithFrame:frame];
//        remainingView.backgroundColor=[UIColor whiteColor];
        [self addSubview:remainingView];
        self.remaningValueLabel=[[UILabel alloc] initWithFrame:frame];
        self.remaningValueLabel.textAlignment=NSTextAlignmentRight;
        
        [remainingView addSubview:self.remaningValueLabel];
        [self.remaningValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(remainingView.mas_top).offset(10.0f);
            make.right.equalTo(remainingView.mas_right).offset(-10.0f);
            make.width.mas_offset(200);
        }];
    }
    return self;
}


@end
