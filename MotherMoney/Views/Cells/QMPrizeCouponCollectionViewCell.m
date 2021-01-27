//
//  QMPrizeCouponCollectionViewCell.m
//  MotherMoney
//
//  Created by liuyanfang on 15/9/14.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMPrizeCouponCollectionViewCell.h"

@implementation QMPrizeCouponCollectionViewCell{
    UIImageView* currentScoreView;
    UIImageView* upLineView;
    UIImageView* downLineView;
    UIImageView* moneyIcon;
    UILabel* currentScoreValueLabel;
    UILabel* currentScoreTitleLabel;
    UIImageView* indictionView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        upLineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 1)];
        upLineView.backgroundColor=[UIColor colorWithRed:184.0f/255.0f green:184.0f/255.0f blue:184.0f/255.0f alpha:1];
        [self addSubview:upLineView];
        currentScoreView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 11, frame.size.width, 39)];
        currentScoreView.backgroundColor=[UIColor whiteColor];
        currentScoreView.userInteractionEnabled=YES;
        [self addSubview:currentScoreView];
        
        
        downLineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 1)];
        downLineView.backgroundColor=[UIColor colorWithRed:184.0f/255.0f green:184.0f/255.0f blue:184.0f/255.0f alpha:1];
        [self addSubview:downLineView];
        moneyIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"packet_icon3"]];
        [currentScoreView addSubview:moneyIcon];
        [moneyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(currentScoreView.mas_left).offset(10.0f);
            make.top.equalTo(currentScoreView.mas_top).offset(10.0f);
            make.size.mas_offset(CGSizeMake(20, 20));
        }];
        
        currentScoreTitleLabel=[[UILabel alloc] init];
        currentScoreTitleLabel.text=@"我的礼券";
        currentScoreTitleLabel.textColor=[UIColor colorWithRed:95.0f/255.0f green:95.0f/255.0f blue:95.0f/255.0f alpha:1];
        currentScoreTitleLabel.textAlignment=NSTextAlignmentLeft;
        currentScoreTitleLabel.font=[UIFont systemFontOfSize:15];
        [currentScoreView addSubview:currentScoreTitleLabel];
        [currentScoreTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moneyIcon.mas_right).offset(5.0f);
            make.top.equalTo(currentScoreView.mas_top);
            make.bottom.equalTo(currentScoreView.mas_bottom);
            make.width.mas_offset(100);
        }];
        
        
        indictionView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"click_icon"]];
        [currentScoreView addSubview:indictionView];
        [indictionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(currentScoreView.mas_right).offset(-10.0f);
            make.top.equalTo(currentScoreView.mas_top).offset(13.0f);
            make.bottom.equalTo(currentScoreView.mas_bottom).offset(-12.0f);
            
            make.width.mas_offset(10);
        }];
        
        currentScoreValueLabel=[[UILabel alloc] init];
        currentScoreValueLabel.textAlignment=NSTextAlignmentRight;
        currentScoreValueLabel.textColor=[UIColor colorWithRed:236.0f/255.0f green:110.0f/255.0f blue:101.0f/255.0f alpha:1];
        currentScoreValueLabel.font=[UIFont systemFontOfSize:16];
        [currentScoreView addSubview:currentScoreValueLabel];
        [currentScoreValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(currentScoreView.mas_top);
            make.bottom.equalTo(currentScoreView.mas_bottom);
            make.right.equalTo(indictionView.mas_left).offset(-5.0f);
            make.width.equalTo(100);
        }];

    }
    return self;
}
- (void)setUserDjqTicketCount:(NSString *)userDjqTicketCount{
    currentScoreValueLabel.text = [NSString stringWithFormat:@"%@",userDjqTicketCount];
}
@end
