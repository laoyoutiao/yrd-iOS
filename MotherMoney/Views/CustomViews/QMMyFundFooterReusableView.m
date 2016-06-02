//
//  QMMyFundFooterReusableView.m
//  MotherMoney
//
//  Created by liuyanfang on 15/8/12.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMMyFundFooterReusableView.h"

@implementation QMMyFundFooterReusableView
{
    UIImageView* safeIcon;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame]) {
        
        
        // 资金安全
//        self.productSecureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.productSecureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [self.productSecureBtn setTitleColor:[UIColor colorWithRed:40.0f / 255.0f green:153.0f / 255.0f blue:0 alpha:1.0f] forState:UIControlStateNormal];
////        [self.productSecureBtn setTitle:QMLocalizedString(@"qm_product_info_page_secure_btn_title", @"账户资金安全由平安保险全额承保") forState:UIControlStateNormal];
//        [self addSubview:self.productSecureBtn];
//        [self.productSecureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset(10.0f);
//            make.right.equalTo(self.mas_right).offset(-10.0f);
//            make.top.mas_offset(21.0f);
//            make.height.equalTo(40.0f);
//            
//        }];
//        
//        //safeIcon
//        safeIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_safe"]];
//        [self.productSecureBtn addSubview:safeIcon];
//        [safeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            UILabel* label=(UILabel*)self.productSecureBtn.subviews[0];
//            make.right.equalTo(label.mas_left).offset(-5.0f);
//            make.top.equalTo(label.mas_top);
//            make.bottom.equalTo(label.mas_bottom);
//            make.width.mas_offset(15.0f);
//        }];
        
        
        
        //actionBtn
        self.actionBtn= [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(frame) - 2 * 15, 40) title:QMLocalizedString(@"qm_start_earning_money", @"开始赚钱") target:self selector:nil];
        
        [self addSubview:self.actionBtn];
        [self.actionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15.0f);
            make.right.equalTo(self.mas_right).offset(-15.0f);
            make.top.mas_offset(40.0f);
            
        }];
        
    }
    return self;
    
    
}
@end
