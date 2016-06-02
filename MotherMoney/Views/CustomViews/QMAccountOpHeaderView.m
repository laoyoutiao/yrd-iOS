//
//  QMAccountOpHeaderView.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/19.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMAccountOpHeaderView.h"

@implementation QMAccountOpHeaderView {
    UILabel *titleLabel;
    UILabel *valueLabel;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        

        self.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        titleLabel.textColor = [UIColor colorWithRed:112.0f/255.0f green:112.0f/255.0f blue:112.0f/255.0f alpha:1];
        
       
        titleLabel.text = QMLocalizedString(@"qm_account_balance_left_title", nil);
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10.0f);
            make.top.equalTo(self.mas_top).offset(10.0f);
        }];
        
        valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        valueLabel.font = [UIFont boldSystemFontOfSize:28];
        valueLabel.textColor = [UIColor colorWithRed:236.0f/255.0f green:71.0f/255.0f blue:59.0f/255.0f alpha:1];
        
        
        [self addSubview:valueLabel];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10.0f);
            make.bottom.equalTo(self.mas_bottom).offset(-10.0f);
        }];
    }
    
    return self;
}

- (void)setAmount:(double)amount {
    valueLabel.text = [CMMUtility formatterNumberWithComma:[NSNumber numberWithDouble:amount]];

}

@end
