//
//  QMProductListCell.m
//  MotherMoney
//
//  Created by   on 14-8-6.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMProductListCell.h"
//产品列表cell
CGFloat productNameExpectYearEarningGap = 20;
CGFloat expectYearEarningTitleValueGap = 4;

CGFloat selledProductRateViewWidth = 60;
CGFloat selledProductRateViewHeight = 60;
CGFloat selledProductRateViewRightPadding = 30;

@implementation QMProductListCell {
    UILabel *mProductNameLabel;
    UILabel *mProductBuyedPeopleNumber;
    UILabel *productType;
    UIImageView *horizontalLineView;
    
    UILabel *mExpectYearRateTitleLabel;// 预期年化标题
    UILabel *mExpectYearRateValueLabel; // 预期年化率值
    UILabel *mExpectYearRateSubValueLabel;
    
    UIView *flexibleView1;
    // 中间竖线
    UIImageView *verticalLineView;
    UIView *flexibleView2;
    
    UILabel *mInvestmentPeriodLabel; // 投资期限
    UILabel *mPurchaseAmountLimitLabel; // 起购金额
    
    // 融资率
    UILabel *mFinancingRateLabel;
    
    UIFont *productNameFont;
    UIFont *expectYearEarningTitleFont;
    UIFont *expectYearEarningValueFont;
    
    // 产品类型标记
    UIImageView *flagImageView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImage]];
        self.backgroundView = backgroundView;
        
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImagePressed]];
        
        UIView *superView = self.contentView;
        // 产品名称
        productNameFont = [UIFont boldSystemFontOfSize:13];
        mProductNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mProductNameLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mProductNameLabel.textColor = QM_COMMON_TEXT_COLOR;
        mProductNameLabel.font = productNameFont;
        [self.contentView addSubview:mProductNameLabel];
        [mProductNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.mas_left).offset(15.0f);
            make.bottom.equalTo(superView.mas_bottom);
            make.size.equalTo(CGSizeMake([UIApplication sharedApplication].keyWindow.frame.size.width > 320? 200.0f:170.0f, 35.0f));
        }];
        
        // 购买人数
        mProductBuyedPeopleNumber = [[UILabel alloc] initWithFrame:CGRectZero];
        mProductBuyedPeopleNumber.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mProductBuyedPeopleNumber.textAlignment = NSTextAlignmentRight;
        mProductBuyedPeopleNumber.textColor = QM_COMMON_TEXT_COLOR;
        mProductBuyedPeopleNumber.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:mProductBuyedPeopleNumber];
        [mProductBuyedPeopleNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mProductNameLabel.mas_top);
            make.height.equalTo(mProductNameLabel.mas_height);
            make.right.equalTo(superView.mas_right).offset(-30.0f);
            make.width.equalTo(100.0f);
        }];
        
        // 水平线
        UIImage *horizontalImage = [QMImageFactory commonHorizontalLineImage];
        horizontalLineView = [[UIImageView alloc] initWithImage:horizontalImage];
        [self.contentView addSubview:horizontalLineView];
        [horizontalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mProductNameLabel.mas_left);
            make.top.equalTo(mProductNameLabel.mas_top).offset(-1.0f);
            make.right.equalTo(superView.mas_right).offset(-15.0f);
            make.height.equalTo(1.0f);
        }];
        
        // 预期年化标题
        UIFont *expectYearRateValueFont = [UIFont systemFontOfSize:24];
        mExpectYearRateValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mExpectYearRateValueLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mExpectYearRateValueLabel.font = expectYearRateValueFont;
        mExpectYearRateValueLabel.textColor = QM_THEME_COLOR;
        [self.contentView addSubview:mExpectYearRateValueLabel];
        [mExpectYearRateValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mProductNameLabel.mas_left).offset(-2.0f);
            make.top.equalTo(15.0f);
            make.height.equalTo(@42.0f);
        }];
        
        
        mExpectYearRateSubValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mExpectYearRateSubValueLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mExpectYearRateSubValueLabel.font = [UIFont systemFontOfSize:17];
        mExpectYearRateSubValueLabel.textColor = QM_THEME_COLOR;
        [self.contentView addSubview:mExpectYearRateSubValueLabel];
        [mExpectYearRateSubValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mExpectYearRateValueLabel.mas_right);
            make.centerY.equalTo(mExpectYearRateValueLabel.mas_centerY).offset(2);
        }];
        
        
        
        CGFloat expectYearRateValueTopY = 20;
        UIFont *expectYearRateTitleFont = [UIFont systemFontOfSize:13];
        mExpectYearRateTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mExpectYearRateTitleLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mExpectYearRateTitleLabel.textColor = QM_THEME_COLOR;
        mExpectYearRateTitleLabel.font = expectYearRateTitleFont;
        [self.contentView addSubview:mExpectYearRateTitleLabel];
        [mExpectYearRateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mProductNameLabel.mas_left);
            make.top.equalTo(mExpectYearRateValueLabel.mas_bottom).offset(3.0f);
            make.width.equalTo(mExpectYearRateValueLabel.mas_width);
            make.height.equalTo(expectYearRateTitleFont.lineHeight);
        }];
        
        flexibleView1 = [[UIView alloc] initWithFrame:CGRectZero];
        flexibleView1.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:flexibleView1];
        [flexibleView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mExpectYearRateSubValueLabel.mas_right);
            make.top.equalTo(expectYearRateValueTopY);
            make.height.equalTo(@10);
        }];
        
        // 中间竖线
        verticalLineView = [[UIImageView alloc] initWithFrame:CGRectZero];
        verticalLineView.backgroundColor = [UIColor colorWithRed:229.0f / 255.0f green:229.0f / 255.0f blue:229.0f / 255.0f alpha:1.0f];
        [self.contentView addSubview:verticalLineView];
        [verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(flexibleView1.mas_right);
            make.top.equalTo(expectYearRateValueTopY);
            make.size.equalTo(CGSizeMake(1.0f, 50.0f));
        }];
        
        flexibleView2 = [[UIView alloc] initWithFrame:CGRectZero];
        flexibleView2.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:flexibleView2];
        [flexibleView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(verticalLineView);
            make.top.equalTo(verticalLineView.mas_top);
            make.width.equalTo(flexibleView1.mas_width);
            make.bottom.equalTo(verticalLineView.mas_bottom);
        }];
        
        // 投资期限
        UIFont *investmentPeriodFont = [UIFont systemFontOfSize:13];
        mInvestmentPeriodLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mInvestmentPeriodLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mInvestmentPeriodLabel.textColor = [UIColor colorWithRed:140.0f / 255.0f green:140.0f / 255.0f blue:140.0f / 255.0f alpha:1.0f];
        mInvestmentPeriodLabel.font = investmentPeriodFont;
        [self.contentView addSubview:mInvestmentPeriodLabel];
        [mInvestmentPeriodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(flexibleView2.mas_right);
            make.top.equalTo(verticalLineView.mas_top).offset(-2.0f);
            make.size.equalTo(CGSizeMake(100, investmentPeriodFont.lineHeight));
        }];
        
        // 起购金额
        mPurchaseAmountLimitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mPurchaseAmountLimitLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mPurchaseAmountLimitLabel.textColor = [UIColor colorWithRed:140.0f / 255.0f green:140.0f / 255.0f blue:140.0f / 255.0f alpha:1.0f];
        mPurchaseAmountLimitLabel.font = [UIFont systemFontOfSize:13];
        mPurchaseAmountLimitLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:mPurchaseAmountLimitLabel];
        [mPurchaseAmountLimitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mInvestmentPeriodLabel.mas_left);
            make.top.equalTo(mInvestmentPeriodLabel.mas_bottom).offset(expectYearEarningTitleValueGap);
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
            make.height.equalTo(mInvestmentPeriodLabel.mas_height);
        }];
        
        // 融资率
        mFinancingRateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mFinancingRateLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mFinancingRateLabel.font = [UIFont systemFontOfSize:13];
        mFinancingRateLabel.textColor = [UIColor colorWithRed:140.0f / 255.0f green:140.0f / 255.0f blue:140.0f / 255.0f alpha:1.0f];
        [self.contentView addSubview:mFinancingRateLabel];
        [mFinancingRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mPurchaseAmountLimitLabel.mas_left);
            make.top.equalTo(mPurchaseAmountLimitLabel.mas_bottom).offset(expectYearEarningTitleValueGap);
            make.width.equalTo(mPurchaseAmountLimitLabel.mas_width);
            make.height.equalTo(mPurchaseAmountLimitLabel.mas_height);
        }];
        productType = [[UILabel alloc] init];
        productType.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        productType.font = [UIFont systemFontOfSize:13];
        productType.textColor =[UIColor colorWithRed:140.0f / 255.0f green:140.0f / 255.0f blue:140.0f / 255.0f alpha:1.0f];
        [self.contentView addSubview:productType];
        [productType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mFinancingRateLabel.mas_left);
            make.top.equalTo(mFinancingRateLabel.mas_bottom).offset(expectYearEarningTitleValueGap);
            make.width.equalTo(mFinancingRateLabel.mas_width);
            make.height.equalTo(mFinancingRateLabel.mas_height);
        }];
        // 标记
        flagImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:flagImageView];
        [flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView.mas_top).offset(6);
            make.right.equalTo(superView.mas_right).offset(-6.0f);
            make.size.equalTo(CGSizeMake(27, 26));
        }];
    }
    
    return self;
}

- (void)configureCellWithProductionInfo:(QMProductInfo *)info {
    productType.text = [NSString stringWithFormat:@"资产类型:%@",info.descriptionTitle];
    if (nil == info || ![info isKindOfClass:[QMProductInfo class]]) {
        return;
    }
    
    // 产品名称
    NSString *productName = info.productName;
    if (!QM_IS_STR_NIL(productName)) {
        mProductNameLabel.text = productName;
    }else {
        mProductNameLabel.text = @"";
    }
    
    // 购买人数
    mProductBuyedPeopleNumber.text = [NSString stringWithFormat:QMLocalizedString(@"qm_product_list_buy_people_count", @"%d 人购买"), [info.saleAmount integerValue]];
    
    // 预期年化率
    mExpectYearRateTitleLabel.text = QMLocalizedString(@"qm_product_list_expected_year_earnings", @"预期年化率");
    mExpectYearRateValueLabel.text = [NSString stringWithFormat:@"%.1f%%", [info.normalInterest floatValue]];
    if (!QM_IS_STR_NIL(info.awardInterest) && [info.awardInterest floatValue] > 0) {
        mExpectYearRateSubValueLabel.text = [NSString stringWithFormat:@"+%.1f%%", [info.awardInterest floatValue]];
    }else {
        mExpectYearRateSubValueLabel.text = @"";
    }
    
    // 投资期限
    NSString *plainStr = [NSString stringWithFormat:QMLocalizedString(@"qm_product_list_investmentPeriod", @"期限%@"), info.maturityDuration];
    mInvestmentPeriodLabel.text = plainStr;
    
    // 起购金额
    if ([info.productChannelId isEqualToString:QM_DEFAULT_CHANNEL_ID]) { // channelId为2的产品
        NSString *purchasePlainStr = [NSString stringWithFormat:@"%@份起购，每份%@元", [NSNumber numberWithInteger:[info.minAmount integerValue]], [CMMUtility formatterNumberWithComma:info.baseAmount]];
        mPurchaseAmountLimitLabel.text = purchasePlainStr;
    }else {
        NSString *purchasePlainStr = [NSString stringWithFormat:QMLocalizedString(@"qm_product_list_purchaseAmountLimit", @"%d元起购"), [info.calculateMinAmount integerValue]];
        mPurchaseAmountLimitLabel.text = purchasePlainStr;
    }
    
    // 融资旅
    mFinancingRateLabel.text = [NSString stringWithFormat:QMLocalizedString(@"qm_product_list_finance_rate", @"已融资 %.2f%%"), [info.finishRatio floatValue]];
    
    // 产品标记
    flagImageView.image = [self flagImageForProductInfo:info];
}

- (UIImage *)flagImageForProductInfo:(QMProductInfo *)info {
    NSString *productStatus = info.cornerType;
    NSString *imageName = nil;
    if (!QM_IS_STR_NIL(productStatus)) {
        if ([productStatus isEqualToString:@"SALE_OVER"]) { // 售磬
            imageName = @"product_over_icon.png";
        }else if ([productStatus isEqualToString:@"TASTE"]) { // 体验
            imageName = @"product_taste_icon.png";
        }else if ([productStatus isEqualToString:@"ACTIVITY"]) { // 活动
            imageName = @"product_activity_icon.png";
        }else if ([productStatus isEqualToString:@"CLOSED"]) { // 完成状态
            imageName = @"products_list_sold_finish.png";
        }else if ([productStatus isEqualToString:@"LENDING"]) { // 还款状态
            imageName = @"products_list_huankuan.png";
        }else {
            imageName = @"product_activity_icon.png";      //默认活动
        }
    }
    
    if (!QM_IS_STR_NIL(imageName)) {
        return [UIImage imageNamed:imageName];
    }
    
    return nil;
}

+ (CGFloat)getCellHeightForProductInfo:(QMProductInfo *)info {
    return 130;
}

@end
