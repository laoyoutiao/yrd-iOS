//
//  QMMyFundTableFooterView.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/18.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMMyFundTableFooterView.h"

@implementation QMMyFundTableFooterView
{
    UILabel* noticeTitleLabel;
    UILabel* enquireNumberLabel;
    UIImageView* safeIcon;
    
    
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // 资金安全
        self.productSecureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.productSecureBtn.contentMode=UIViewContentModeCenter;
        self.productSecureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.productSecureBtn setTitleColor:[UIColor colorWithRed:40.0f / 255.0f green:153.0f / 255.0f blue:0 alpha:1.0f] forState:UIControlStateNormal];
        
        [self.productSecureBtn setTitle:@"" forState:UIControlStateNormal];
        [self addSubview:self.productSecureBtn];
        [self.productSecureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10.0f);
            make.right.equalTo(self.mas_right).offset(-10.0f);
            make.top.mas_offset(21.0f);
            make.height.equalTo(40.0f);
            
        }];
        //safeIcon
        safeIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [self.productSecureBtn addSubview:safeIcon];
        [safeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            UILabel* label=(UILabel*)self.productSecureBtn.subviews[0];
            make.right.equalTo(label.mas_left).offset(-5.0f);
            make.top.equalTo(label.mas_top);
            make.bottom.equalTo(label.mas_bottom);
            make.width.mas_offset(15);
        }];
        
        noticeTitleLabel=[[UILabel alloc] init];
        noticeTitleLabel.text=@"如有疑问请拨打客服热线";
        noticeTitleLabel.textColor=[UIColor colorWithRed:143.0f/255.0f green:143.0f/255.0f blue:143.0f/255.0f alpha:143.0f/255.0f];
        noticeTitleLabel.font=[UIFont systemFontOfSize:11];
        [self addSubview:noticeTitleLabel];
        noticeTitleLabel.textAlignment=NSTextAlignmentCenter;
        [noticeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10.0f);
            make.right.equalTo(self.mas_right).offset(-10.0f);
            make.top.mas_offset(21.0f);
            make.height.equalTo(20.0f);
        }];
        
        enquireNumberLabel=[[UILabel alloc] init];
        enquireNumberLabel.textAlignment=NSTextAlignmentCenter;
        enquireNumberLabel.text=QM_OFFICIAL_PHONE_NUMBER;
        enquireNumberLabel.font=[UIFont systemFontOfSize:12];
        enquireNumberLabel.textColor=[UIColor colorWithRed:143.0f/255.0f green:143.0f/255.0f blue:143.0f/255.0f alpha:1];
        [self addSubview:enquireNumberLabel];
        [enquireNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10.0f);
            make.right.equalTo(self.mas_right).offset(-10.0f);
            make.top.equalTo(noticeTitleLabel.mas_bottom);
            make.height.equalTo(20.0f);
        }];
        
        
        
        
    }
    
    return self;
}

@end
