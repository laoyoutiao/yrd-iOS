//
//  QMWithDrawRecordCell.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/13.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMWithDrawRecordCell.h"

@implementation QMWithDrawRecordCell {
    UILabel *titleLabel;
    UILabel *amountLabel;
    UILabel *timeLabel;
    UILabel *statusLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImage]];
        
        // image view
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:titleLabel];
        titleLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        titleLabel.font = [UIFont systemFontOfSize:13];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10.0f);
            make.top.equalTo(self.contentView.mas_top).offset(5.0f);
        }];
        
        amountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        amountLabel.font = [UIFont systemFontOfSize:13];
        amountLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        amountLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:amountLabel];
        [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_top);
            make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        }];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_left);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.0f);
        }];
        
        // title
        statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        statusLabel.textAlignment = NSTextAlignmentRight;
        statusLabel.font = [UIFont systemFontOfSize:13];
        statusLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        [self.contentView addSubview:statusLabel];
        [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeLabel.mas_top);
            make.right.equalTo(amountLabel.mas_right);
        }];
    }
    
    return self;
}



+ (CGFloat)getCellHeightForWithDrawItem:(QMWithDrawRecordItem *)info {
    return 60;
}

- (void)configureCellWithItemInfo:(QMWithDrawRecordItem *)info {
    titleLabel.text = @"提现";
    
    CGFloat amount = [info.amount floatValue];
    amountLabel.text = [NSString stringWithFormat:@"%.2f", amount];
    
    timeLabel.text = info.applyTime;
    statusLabel.text = info.statusValue;
}

@end



