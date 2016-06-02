//
//  QMProductInfoNumberCell.m
//  MotherMoney
//
//  Created by   on 14-8-16.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMProductInfoNumberCell.h"

@implementation QMProductInfoNumberCell {
    QMNumView *moneyValue; // 融资金额
    QMNumView *buyPeopleNum; // 购买人数
    QMNumView *startMoney; // 起购金额
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImageCenterPart]];
        
        CGFloat itemWidth = (CGRectGetWidth(frame) - 2 * 15) / 3.0f;
        
        // 融资金额
        moneyValue = [[QMNumView alloc] initWithFrame:CGRectMake(15, 0, itemWidth, CGRectGetHeight(frame))];
        [self.contentView addSubview:moneyValue];
        
        // 分割线
        UIImageView *verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(moneyValue.frame), (CGRectGetHeight(frame) - 20.0f) / 2.0f, 1, 20)];
        verticalLine.backgroundColor = [UIColor colorWithRed:229.0f / 255.0f green:229.0f / 255.0f blue:229.0f / 255.0f alpha:1.0f];
        [self.contentView addSubview:verticalLine];
        
        // 购买人数
        buyPeopleNum = [[QMNumView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(verticalLine.frame), 0, itemWidth, CGRectGetHeight(frame))];
        [self.contentView addSubview:buyPeopleNum];
        
        // 分割线
        verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buyPeopleNum.frame), (CGRectGetHeight(frame) - 20.0f) / 2.0f, 1, 20)];
        verticalLine.backgroundColor = [UIColor colorWithRed:229.0f / 255.0f green:229.0f / 255.0f blue:229.0f / 255.0f alpha:1.0f];
        [self.contentView addSubview:verticalLine];
        
        // 起购金额
        startMoney = [[QMNumView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(verticalLine.frame), 0, itemWidth, CGRectGetHeight(frame))];
        [self.contentView addSubview:startMoney];
        
//        UIImageView *horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
//        horizontalLine.frame = CGRectMake(15, CGRectGetHeight(frame) - 1, CGRectGetWidth(frame) - 2 * 15, 1);
//        [self.contentView addSubview:horizontalLine];
    }
    
    return self;
}

- (void)configureCellWithProductInfo:(QMProductInfo *)info {
    // 融资金额
    moneyValue.titleLabel.text = QMLocalizedString(@"qm_product_info_finance_money", @"融资金额");
    moneyValue.numberLabel.text = [NSString stringWithFormat:@"%@", [CMMUtility formatterNumberWithComma:info.totalAmount]];
    
    // 购买人数
    buyPeopleNum.titleLabel.text = QMLocalizedString(@"qm_product_info_page_buy_number_title", @"购买人数");
    buyPeopleNum.numberLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:[info.totalBuyNumber integerValue]]];
    
    // 起购金额
    startMoney.titleLabel.text = QMLocalizedString(@"qm_product_info_page_purchaseAmountLimit_title", @"起购金额");
    startMoney.numberLabel.text = [NSString stringWithFormat:@"%@", [CMMUtility formatterNumberWithComma:info.calculateMinAmount]];
}

+ (CGFloat)getCellHeightForProductInfo:(QMProductInfo *)info {
    return 64.0f;
}

@end
