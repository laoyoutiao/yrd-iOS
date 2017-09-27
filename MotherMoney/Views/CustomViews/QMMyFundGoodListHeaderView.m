//
//  QMMyFundGoodListHeaderView.m
//  MotherMoney
//
//  Created by liuyanfang on 15/8/12.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMMyFundGoodListHeaderView.h"

@implementation QMMyFundGoodListHeaderView
{
    UIImageView* currentScoreView;
    UIImageView* upLineView;
    UIImageView* downLineView;
    UIImageView* moneyIcon;
    UILabel* currentScoreValueLabel;
    UILabel* currentScoreTitleLabel;
    UILabel* currentWillTimeOutScoreValueLabel;
    UILabel* currentWillTimeOutScoreTitleLabel;
    UIImageView* indictionView;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame]) {
        upLineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 1)];
        upLineView.backgroundColor=[UIColor colorWithRed:184.0f/255.0f green:184.0f/255.0f blue:184.0f/255.0f alpha:1];
        [self addSubview:upLineView];
        currentScoreView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 11, frame.size.width, 80)];
        currentScoreView.backgroundColor=[UIColor whiteColor];
        currentScoreView.userInteractionEnabled=YES;
        self.tapGes=[[UITapGestureRecognizer alloc] init];
        [self.tapGes setNumberOfTouchesRequired:1];
        [currentScoreView addGestureRecognizer:self.tapGes];
        [self addSubview:currentScoreView];
       
        
        downLineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 91, frame.size.width, 1)];
        downLineView.backgroundColor=[UIColor colorWithRed:184.0f/255.0f green:184.0f/255.0f blue:184.0f/255.0f alpha:1];
        [self addSubview:downLineView];
        moneyIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bean_icon"]];
        [currentScoreView addSubview:moneyIcon];
        [moneyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(currentScoreView.mas_left).offset(10.0f);
            make.top.equalTo(currentScoreView.mas_top).offset(30.0f);
            make.size.mas_offset(CGSizeMake(20, 20));
        }];
        
        currentScoreTitleLabel=[[UILabel alloc] init];
        currentScoreTitleLabel.text=@"当前积分";
        currentScoreTitleLabel.textColor=[UIColor colorWithRed:95.0f/255.0f green:95.0f/255.0f blue:95.0f/255.0f alpha:1];
        currentScoreTitleLabel.textAlignment=NSTextAlignmentLeft;
        currentScoreTitleLabel.font=[UIFont systemFontOfSize:15];
        [currentScoreView addSubview:currentScoreTitleLabel];
        [currentScoreTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moneyIcon.mas_right).offset(5.0f);
            make.top.equalTo(currentScoreView.mas_top);
            make.bottom.equalTo(currentScoreView.mas_centerY);
            make.width.mas_offset(100);
        }];
        
        currentWillTimeOutScoreTitleLabel=[[UILabel alloc] init];
        currentWillTimeOutScoreTitleLabel.text=[NSString stringWithFormat:@"到期的积分"];
        currentWillTimeOutScoreTitleLabel.textColor=[UIColor colorWithRed:95.0f/255.0f green:95.0f/255.0f blue:95.0f/255.0f alpha:1];
        currentWillTimeOutScoreTitleLabel.textAlignment=NSTextAlignmentLeft;
        currentWillTimeOutScoreTitleLabel.font=[UIFont systemFontOfSize:15];
        [currentScoreView addSubview:currentWillTimeOutScoreTitleLabel];
        [currentWillTimeOutScoreTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moneyIcon.mas_right).offset(5.0f);
            make.top.equalTo(currentScoreView.mas_centerY);
            make.bottom.equalTo(currentScoreView.mas_bottom);
            make.width.mas_offset(200);
        }];
        
        
        indictionView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"click_icon"]];
        [currentScoreView addSubview:indictionView];
        [indictionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(currentScoreView.mas_right).offset(-10.0f);
            make.top.equalTo(currentScoreView.mas_top).offset(33.0f);
            make.bottom.equalTo(currentScoreView.mas_bottom).offset(-32.0f);
            
            make.width.mas_offset(10);
        }];
        
        currentScoreValueLabel=[[UILabel alloc] init];
        currentScoreValueLabel.textAlignment=NSTextAlignmentRight;
        currentScoreValueLabel.textColor=[UIColor colorWithRed:236.0f/255.0f green:110.0f/255.0f blue:101.0f/255.0f alpha:1];
        currentScoreValueLabel.text = @"0";
        currentScoreValueLabel.font=[UIFont systemFontOfSize:16];
        [currentScoreView addSubview:currentScoreValueLabel];
        [currentScoreValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(currentScoreView.mas_top);
            make.bottom.equalTo(currentScoreView.mas_centerY);
            make.right.equalTo(indictionView.mas_left).offset(-5.0f);
            make.width.equalTo(100);
        }];
        
        currentWillTimeOutScoreValueLabel=[[UILabel alloc] init];
        currentWillTimeOutScoreValueLabel.textAlignment=NSTextAlignmentRight;
        currentWillTimeOutScoreValueLabel.textColor=[UIColor colorWithRed:236.0f/255.0f green:110.0f/255.0f blue:101.0f/255.0f alpha:1];
        currentWillTimeOutScoreValueLabel.text = @"0";
        currentWillTimeOutScoreValueLabel.font=[UIFont systemFontOfSize:16];
        [currentScoreView addSubview:currentWillTimeOutScoreValueLabel];
        [currentWillTimeOutScoreValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(currentScoreView.mas_centerY);
            make.bottom.equalTo(currentScoreView.mas_bottom);
            make.right.equalTo(indictionView.mas_left).offset(-5.0f);
            make.width.equalTo(100);
        }];
    }
    
    return self;
    
}
-(void)configCurrentScoreValue:(NSString *)currentScoreValue :(NSString *)currentWillTimeOutScoreValue :(NSString *)willEndTime
{
    
    currentScoreValueLabel.text=[NSString stringWithFormat:@"%@",currentScoreValue];

    if (currentWillTimeOutScoreValue) {
        currentWillTimeOutScoreValueLabel.text = [NSString stringWithFormat:@"%@",currentWillTimeOutScoreValue];
    }
    
    if (willEndTime) {
        currentWillTimeOutScoreTitleLabel.text=[NSString stringWithFormat:@"%@ 到期的积分",willEndTime];
    }
  
}
@end
