//
//  QMBuyedProductInfoCell2.m
//  MotherMoney
//
//  Created by liuyanfang on 15/8/14.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMBuyedProductInfoCell.h"


@implementation QMBuyedProductInfoCell {
    UILabel *mProductNameLabel;
    UILabel *mPrincipalLabel;
    UILabel* mPrincipalValueLabel;
    UILabel *mEarningLabel;
    UILabel* mEarningValueLabel;
    UILabel*mRemaningTime;//剩余时间
    UIImageView* topImageView;
    UIImageView* leftImageView;
    UIImageView* rightImageView;
    UIImageView* timeLog;//时间图片
}
@synthesize productNameLabel = mProductNameLabel;
@synthesize principalLabel = mPrincipalLabel;
@synthesize earningsLabel = mEarningLabel;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius=5.0f;
        self.layer.masksToBounds=YES;
        self.backgroundColor=QM_COMMON_BACKGROUND_COLOR;
        topImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 26)];
        topImageView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:topImageView];
        // 产品名称
        mProductNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mProductNameLabel.numberOfLines = 2;
        mProductNameLabel.textAlignment = NSTextAlignmentLeft;
        mProductNameLabel.font = [UIFont systemFontOfSize:11];
        mProductNameLabel.textColor = [UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1];
        [topImageView addSubview:mProductNameLabel];
        [mProductNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topImageView.mas_top).offset(3.0f);
            make.left.equalTo(topImageView.mas_left).offset(10.0f);
            make.size.mas_offset(CGSizeMake(120, 22));
        }];
        
        mRemaningTime=[[UILabel alloc] init];
        mRemaningTime.textAlignment=NSTextAlignmentLeft;
        mRemaningTime.font=[UIFont systemFontOfSize:11];
        [topImageView addSubview:mRemaningTime];
        [mRemaningTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topImageView.mas_top).offset(3.0f);
            make.right.equalTo(topImageView.mas_right);
            make.size.mas_offset(CGSizeMake(70, 22));
            
        }];
        timeLog=[[UIImageView alloc] init];
        timeLog.image=[UIImage imageNamed:@"list_clock"];
        [topImageView addSubview:timeLog];
        [timeLog mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topImageView.mas_top).offset(8.0f);
            make.right.equalTo(mRemaningTime.mas_left);
            make.size.mas_offset(CGSizeMake(13, 13));
        }];
        
        leftImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 27, frame.size.width/2-0.5, 68)];
        leftImageView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:leftImageView];
        
        // 本金
        mPrincipalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mPrincipalLabel.textAlignment = NSTextAlignmentCenter;
        mPrincipalLabel.text=@"本金（元）";
        mPrincipalLabel.font = [UIFont systemFontOfSize:13];
        mPrincipalLabel.textColor =[UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1];
        [leftImageView addSubview:mPrincipalLabel];
        [mPrincipalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(leftImageView.mas_top).offset(6.0f);
            make.left.equalTo(leftImageView.mas_left).offset(20.0f);
            make.size.mas_offset(CGSizeMake(leftImageView.frame.size.width-25, 24));
        }];
        
        mPrincipalValueLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        mPrincipalValueLabel.textColor=[UIColor colorWithRed:105.0f/255.0f green:105.0f/255.0f blue:105.0f/255.0f alpha:1];
        mPrincipalValueLabel.textAlignment=NSTextAlignmentCenter;
        mPrincipalValueLabel.font=[UIFont systemFontOfSize:15];
        [leftImageView addSubview:mPrincipalValueLabel];
        [mPrincipalValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mPrincipalLabel.mas_bottom);
            make.left.equalTo(leftImageView.mas_left);
            make.right.equalTo(leftImageView.mas_right);
            make.height.mas_offset(24);
            
        }];
        
        rightImageView=[[UIImageView alloc] init];
        rightImageView.backgroundColor=[UIColor whiteColor];
        [self addSubview:rightImageView];
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topImageView.mas_bottom).offset(1.0f);
            make.right.equalTo(self.mas_right);
            make.left.equalTo(leftImageView.mas_right).offset(1.0f);
            make.height.mas_offset(68);
        }];
        // 收益
        mEarningLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mEarningLabel.textAlignment = NSTextAlignmentCenter;
        mEarningLabel.textColor = [UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1];
        mEarningLabel.font = [UIFont systemFontOfSize:13];
        mEarningLabel.text=@"累积收益（元）";
        [rightImageView addSubview:mEarningLabel];
        [mEarningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rightImageView.mas_top).offset(6.0f);
            make.left.equalTo(rightImageView.mas_left);
            make.right.equalTo(rightImageView.mas_right);
            make.height.mas_offset(24.0f);
            
        }];
        mEarningValueLabel=[[UILabel alloc] init];
        mEarningValueLabel.textColor=[UIColor colorWithRed:236.0f/255.0f green:101.0f/255.0f blue:110.0f/255.0f alpha:1];
        mEarningValueLabel.textAlignment=NSTextAlignmentCenter;
        [rightImageView addSubview:mEarningValueLabel];
        [mEarningValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mEarningLabel.mas_bottom);
            make.left.equalTo(rightImageView.mas_left);
            make.right.equalTo(rightImageView.mas_right);
            make.height.mas_offset(24.0f);
        }];
        
    }
    
    return self;
}

- (void)configureCellWithProductInfo:(QMBuyedProductInfo *)info {
    if (!QM_IS_STR_NIL(info.productName)) {
        mProductNameLabel.text = info.productName;
    }else {
        mProductNameLabel.text = @"";
    }
    //本金
    mPrincipalValueLabel.text = info.totalBuyAmount;
    //累积收益
    mEarningValueLabel.text = info.totalEarnings;
    //剩余时间
    NSMutableAttributedString* str=[[NSMutableAttributedString alloc] initWithString:@"剩余XXX天"];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1] range:NSMakeRange(0, 2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:236.0f/255.0f green:101.0f/255.0f blue:110.0f/255.0f alpha:1] range:NSMakeRange(2, str.length-3)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1] range:NSMakeRange(str.length-1, 1)];
    mRemaningTime.attributedText=str;
}

+ (CGFloat)getCellHeightForProductInfo:(QMBuyedProductInfo *)info {
    return 96.0f;
}

@end
