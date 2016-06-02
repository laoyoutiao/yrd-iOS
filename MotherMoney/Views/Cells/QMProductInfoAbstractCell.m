//
//  QMProductInfoAbstractCell.m
//  MotherMoney
//
//  Created by   on 14-8-16.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMProductInfoAbstractCell.h"
#import "QMProgressView.h"
#import "CMMUtility.h"

#define CELL_CONTENT_RIGHT_PADDING 15
#define CELL_CONTENT_LEFT_PADDING 15

@implementation QMProductInfoAbstractCell {
    UILabel *mProductNameLabel;
    UILabel *mExpectYearRateTitleLabel;// 预期年化标题
    UILabel *mExpectYearRateValueLabel; // 预期年化率值
    UILabel *mExpectYearRateSubValueLabel;
    
    QMProgressView *mFinancingRateProgress;
    
    UILabel *leftMoney;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImageTopPart]];
        
        // 产品名称
        mProductNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mProductNameLabel.textAlignment = NSTextAlignmentRight;
        mProductNameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:mProductNameLabel];
        
        // 预期年化率
        mExpectYearRateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CELL_CONTENT_LEFT_PADDING, CGRectGetMinY(mProductNameLabel.frame) - 4, 70, 26)];
        mExpectYearRateValueLabel.font = [UIFont systemFontOfSize:24.0f];
        mExpectYearRateValueLabel.textColor = QM_THEME_COLOR;
        [self.contentView addSubview:mExpectYearRateValueLabel];
        [mExpectYearRateValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(CELL_CONTENT_LEFT_PADDING);
            make.top.equalTo(25);
            make.height.equalTo(@26);
        }];
        
        mExpectYearRateSubValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mExpectYearRateSubValueLabel.font = [UIFont systemFontOfSize:14.0f];
        mExpectYearRateSubValueLabel.textColor = QM_THEME_COLOR;
        [self.contentView addSubview:mExpectYearRateSubValueLabel];
        [mExpectYearRateSubValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mExpectYearRateValueLabel.mas_right);
            make.centerY.equalTo(mExpectYearRateValueLabel.mas_centerY).offset(3.0f);
        }];
        
        [mProductNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mExpectYearRateSubValueLabel.mas_right).offset(5.0f);
            make.right.equalTo(self.contentView.mas_right).offset(-1.0f * CELL_CONTENT_RIGHT_PADDING);
            make.top.equalTo(25);
        }];
        
        mExpectYearRateTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mExpectYearRateTitleLabel.textColor = QM_COMMON_TEXT_COLOR;
        mExpectYearRateTitleLabel.font = [UIFont systemFontOfSize:13];
        mExpectYearRateTitleLabel.text = QMLocalizedString(@"qm_product_list_expected_year_earnings", @"预期年化率");
        [self.contentView addSubview:mExpectYearRateTitleLabel];
        [mExpectYearRateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mExpectYearRateValueLabel.mas_left);
            make.top.equalTo(mExpectYearRateValueLabel.mas_bottom).offset(4.0f);
        }];
        
        // progress
        mFinancingRateProgress = [[QMProgressView alloc] initWithFrame:CGRectMake(CELL_CONTENT_LEFT_PADDING, 120, CGRectGetWidth(frame) - 2 * CELL_CONTENT_LEFT_PADDING, 12)];
        [self.contentView addSubview:mFinancingRateProgress];
        
        // 剩余份额
        leftMoney = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - 150 - CELL_CONTENT_RIGHT_PADDING, CGRectGetMaxY(mFinancingRateProgress.frame) + 4, 150, 13)];
        leftMoney.font = [UIFont systemFontOfSize:11];
        leftMoney.textColor = QM_COMMON_TEXT_COLOR;
        leftMoney.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:leftMoney];
        
        UIImageView *horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        horizontalLine.frame = CGRectMake(CELL_CONTENT_LEFT_PADDING, CGRectGetHeight(frame) - 1, CGRectGetWidth(frame) - CELL_CONTENT_LEFT_PADDING - CELL_CONTENT_RIGHT_PADDING, 1);
        [self.contentView addSubview:horizontalLine];
    }
    
    return self;
}

- (void)configureCellWithProductInfo:(QMProductInfo *)info {
    if (!QM_IS_STR_NIL(info.productName)) {
        mProductNameLabel.text = info.productName;
    }else {
        mProductNameLabel.text = @"";
    }

    mExpectYearRateValueLabel.text = [NSString stringWithFormat:@"%.1f%%", [info.normalInterest floatValue]];
    if (!QM_IS_STR_NIL(info.awardInterest) && [info.awardInterest floatValue] > 0) {
        mExpectYearRateSubValueLabel.text = [NSString stringWithFormat:@"+%.1f%%", [info.awardInterest floatValue]];
    }

    [mFinancingRateProgress setCurrentProgress:[info.finishRatio floatValue] / 100.0f];

//    leftMoney.text = [NSString stringWithFormat:QMLocalizedString(@"qm_remain_money_amount_text", @"剩余金额:%@元"), [CMMUtility formatterNumberWithComma:info.remainingAmount]];
    if ([info.productChannelId isEqualToString:@"1"]) {
        leftMoney.text = [NSString stringWithFormat:QMLocalizedString(@"qm_remain_money_amount_text", @"剩余金额:%@元"), [CMMUtility formatterNumberWithComma:info.remainingAmount]];
    }else if ([info.productChannelId isEqualToString:@"2"]) {
        leftMoney.text = [NSString stringWithFormat:QMLocalizedString(@"qm_remain_money_copies_text", @"剩余份额:%@份"), [NSNumber numberWithInteger:[info.remainingAmount integerValue]]];
    }
}

+ (CGFloat)getCellHeightForProductInfo:(QMProductInfo *)info {
    return 162.0f;
}

@end

