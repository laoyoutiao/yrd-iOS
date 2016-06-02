//
//  QMTradeRecordCell.m
//  MotherMoney
//
//  Created by   on 14-8-9.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMTradeRecordCell.h"

@implementation QMTradeRecordCell {
    UILabel *tradeNameLabel;
    UILabel *tradeDateLabel;
    
    UILabel *tradeValueLabel;
    
    UIImageView *mHorizontalLine;
}
@synthesize horizontalLine = mHorizontalLine;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        tradeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 160, 16)];
        tradeNameLabel.font = [UIFont systemFontOfSize:14];
        tradeNameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:tradeNameLabel];
        
        tradeDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(tradeNameLabel.frame), CGRectGetMaxY(tradeNameLabel.frame) + 2, CGRectGetWidth(tradeNameLabel.frame), 14)];
        tradeDateLabel.font = [UIFont systemFontOfSize:12];
        tradeDateLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        [self.contentView addSubview:tradeDateLabel];
        
        tradeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - 95, 0, 80, CGRectGetHeight(frame))];
        tradeValueLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:tradeValueLabel];
        
        // 分割线
        self.horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        self.horizontalLine.frame = CGRectMake(15, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame) - 2 * 15, 1);
        self.horizontalLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:self.horizontalLine];
    }
    
    return self;
}

- (void)configureCellWithTradeInfo:(QMTradeInfo *)tradeInfo {
    if (!QM_IS_STR_NIL(tradeInfo.tradeName)) {
        // card id
        if ([tradeInfo.tradeName length] >= 4) {
            NSString *tailStr = [tradeInfo.tradeName substringFromIndex:(tradeInfo.tradeName.length - 4)];
            tradeNameLabel.text = [NSString stringWithFormat:QMLocalizedString(@"qm_bank_card_detail_text", @"尾号%@"), tailStr];
        }else {
            tradeNameLabel.text = @"";
        }
    }else {
        tradeNameLabel.text = @"";
    }

    if (!QM_IS_STR_NIL(tradeInfo.logtime)) {
        tradeDateLabel.text = tradeInfo.logtime;
    }else {
        tradeDateLabel.text = @"";
    }
    
    CGFloat value = [tradeInfo.amount floatValue];
    if (value >= 0) {
        tradeValueLabel.textColor = QM_THEME_COLOR;
    }else {
        tradeValueLabel.textColor = [UIColor colorWithRed:82.0f / 255.0f green:157.0f / 255.0f blue:200.0f / 255.0f alpha:1.0f];
    }
    
    tradeValueLabel.text = tradeInfo.amount;
}

- (void)reset {
    tradeNameLabel.text = @"";
    tradeDateLabel.text = @"";
    tradeValueLabel.text = @"";
}

+ (CGFloat)getCellHeightForTradeInfo:(QMTradeInfo *)tradeInfo {
    return 50.0f;
}

@end
