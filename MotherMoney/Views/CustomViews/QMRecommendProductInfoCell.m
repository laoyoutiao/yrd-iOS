//
//  QMRecommendProductInfoView.m
//  MotherMoney
//
//  Created by   on 14-8-6.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMRecommendProductInfoCell.h"
#import "QMProgressView.h"

#define CONTENT_RIGHT_PADDING 15
#define CONTENT_LEFT_PADDING 15

@implementation QMRecommendProductInfoCell {
    UIImageView *backgroundImageView;
    
    UILabel *mProductNameLabel;
    UILabel *mExpectYearRateTitleLabel;// 预期年化标题
    UILabel *mExpectYearRateValueLabel; // 预期年化率值
    UILabel *mExpectYearRateSubValueLabel;
    
    UILabel *mInvestmentAndPurchaseLabel; // 投资期限和起购金额
    
    UILabel *mProductBuyedPeopleNumber;
    
    // 融资率
    UILabel *mFinancingRateLabel;
    // 已经融资
    QMProgressView *mFinancingRateProgress;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
        
        backgroundImageView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImage]];
        backgroundImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:backgroundImageView];
        [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(8, 8, 0, 8));
        }];
        
        // 产品名称
        mProductNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mProductNameLabel.textAlignment = NSTextAlignmentRight;
        mProductNameLabel.textColor = [UIColor blackColor];
        mProductNameLabel.numberOfLines = 0;
        [backgroundImageView addSubview:mProductNameLabel];
        
        // 预期年化率
        mExpectYearRateValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mExpectYearRateValueLabel.font = [UIFont systemFontOfSize:24.0f];
        mExpectYearRateValueLabel.textColor = QM_THEME_COLOR;
        [backgroundImageView addSubview:mExpectYearRateValueLabel];
        [mExpectYearRateValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundImageView.mas_left).offset(CONTENT_LEFT_PADDING);
            make.top.equalTo(mProductNameLabel.mas_top).offset(-4);
            make.height.equalTo(26);
            make.width.equalTo(70);
        }];
        
        mExpectYearRateSubValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mExpectYearRateSubValueLabel.font = [UIFont systemFontOfSize:14];
        mExpectYearRateSubValueLabel.textColor = QM_THEME_COLOR;
        [backgroundImageView addSubview:mExpectYearRateSubValueLabel];
        [mExpectYearRateSubValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mExpectYearRateValueLabel.mas_right);
            make.centerY.equalTo(mExpectYearRateValueLabel.mas_centerY).offset(2);
            make.width.equalTo(65);
        }];
        
        [mProductNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mExpectYearRateSubValueLabel.mas_right).offset(5.0f);
            make.right.equalTo(backgroundImageView.mas_right).offset(-1.0f * CONTENT_RIGHT_PADDING);
            make.top.equalTo(backgroundImageView.mas_top).offset(20);
            make.height.equalTo(50);
        }];
        
        mExpectYearRateTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mExpectYearRateTitleLabel.textColor = [UIColor colorWithRed:108 / 255.0f green:108.0f / 255.0f blue:108.0f / 255.0f alpha:1.0f];
        mExpectYearRateTitleLabel.font = [UIFont systemFontOfSize:13];
        mExpectYearRateTitleLabel.text = QMLocalizedString(@"qm_product_list_expected_year_earnings", @"预期年化率");
        [backgroundImageView addSubview:mExpectYearRateTitleLabel];
        [mExpectYearRateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundImageView.mas_left).offset(CONTENT_LEFT_PADDING);
            make.top.equalTo(mExpectYearRateValueLabel.mas_bottom).offset(5);
            make.width.equalTo(mExpectYearRateValueLabel.mas_width);
            make.height.equalTo(15.0f);
        }];
        
        mFinancingRateProgress = [[QMProgressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * 8 - 2 * 15, 12.0f)];
        [backgroundImageView addSubview:mFinancingRateProgress];
        [mFinancingRateProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mExpectYearRateTitleLabel.mas_left);
            make.top.equalTo(mExpectYearRateTitleLabel.mas_bottom).offset(40.0f);
            make.right.equalTo(backgroundImageView.mas_right).offset(-1.0f * CONTENT_RIGHT_PADDING);
            make.height.equalTo(12.0f);
        }];
        
        mFinancingRateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mFinancingRateLabel.textColor = QM_COMMON_TEXT_COLOR;
        mFinancingRateLabel.font = [UIFont systemFontOfSize:13];
        mFinancingRateLabel.text = QMLocalizedString(@"qm_recommendation_finance_already", @"已经融资");
        [backgroundImageView addSubview:mFinancingRateLabel];
        [mFinancingRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mFinancingRateProgress.mas_left);
            make.top.equalTo(mFinancingRateProgress.mas_bottom).offset(5);
            make.size.equalTo(CGSizeMake(100, 15));
        }];
        
        // 水平分割线
        UIImageView *horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        [backgroundImageView addSubview:horizontalLine];
        [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mFinancingRateLabel.mas_left);
            make.top.equalTo(mFinancingRateLabel.mas_bottom).offset(9);
            make.width.equalTo(mFinancingRateProgress.mas_width);
            make.height.equalTo(1.0f);
        }];
        
        // 投资期限和起购金额
        mInvestmentAndPurchaseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mInvestmentAndPurchaseLabel.font = [UIFont systemFontOfSize:13];
        mInvestmentAndPurchaseLabel.textColor = QM_COMMON_TEXT_COLOR;
        [backgroundImageView addSubview:mInvestmentAndPurchaseLabel];
        [mInvestmentAndPurchaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(horizontalLine.mas_left);
            make.top.equalTo(horizontalLine.mas_bottom);
            make.width.equalTo(horizontalLine.mas_width);
            make.height.equalTo(15 + 13 + 15);
        }];
        
        // 水平分割线
        horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        [backgroundImageView addSubview:horizontalLine];
        [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mInvestmentAndPurchaseLabel.mas_left);
            make.top.equalTo(mInvestmentAndPurchaseLabel.mas_bottom);
            make.width.equalTo(mFinancingRateProgress.mas_width);
            make.height.equalTo(1.0f);
        }];
        
        // 已购买人数
        mProductBuyedPeopleNumber = [[UILabel alloc] initWithFrame:CGRectZero];
        mProductBuyedPeopleNumber.font = [UIFont systemFontOfSize:13];
        [backgroundImageView addSubview:mProductBuyedPeopleNumber];
        [mProductBuyedPeopleNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(horizontalLine.mas_left);
            make.top.equalTo(horizontalLine.mas_bottom);
            make.width.equalTo(horizontalLine.mas_width);
            make.height.equalTo(15 + 13 + 15);
        }];
        
        // 水平分割线
        horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        [backgroundImageView addSubview:horizontalLine];
        [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mProductBuyedPeopleNumber.mas_left);
            make.top.equalTo(mProductBuyedPeopleNumber.mas_bottom);
            make.width.equalTo(mProductBuyedPeopleNumber.mas_width);
            make.height.equalTo(1.0f);
        }];
        
        // 购买按钮
        self.actionBtn = [QMControlFactory commonButtonWithSize:CGSizeZero title:QMLocalizedString(@"qm_recommendation_buy_btn_title", @"购买") target:nil selector:nil];
        [backgroundImageView addSubview:_actionBtn];
        [_actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(horizontalLine.mas_left);
            make.top.equalTo(horizontalLine.mas_bottom).offset(10.0f);
            make.width.equalTo(horizontalLine.mas_width);
            make.height.equalTo(40.0f);
        }];
    }
    
    return self;
}

+ (CGFloat)getCellHeightForProductInfo:(QMProductInfo *)product {
    return 320 + 16;
}

- (void)configureCellWithProductionInfo:(QMProductInfo *)product {
    if (!QM_IS_STR_NIL(product.productName)) {
        mProductNameLabel.text = product.productName;
    }else {
        mProductNameLabel.text = @"";
    }
    
    mExpectYearRateValueLabel.text = [NSString stringWithFormat:@"%.1f%%", [product.normalInterest floatValue]];
    if (!QM_IS_STR_NIL(product.awardInterest) && [product.awardInterest floatValue] > 0) {
        mExpectYearRateSubValueLabel.text = [NSString stringWithFormat:@"+%.1f%%", [product.awardInterest floatValue]];
    }
    
    CGFloat progress = [product.finishRatio floatValue] / 100.0f;
    [mFinancingRateProgress setCurrentProgress:progress];
    
    NSString *maturityAndUnit = product.maturityDuration;
    if (![CMMUtility isStringOk:maturityAndUnit]) {
        maturityAndUnit = @"";
    }

    NSString *investText = [NSString stringWithFormat:@"期限 %@", maturityAndUnit];
    NSString *baseText = [NSString stringWithFormat:@"每份%@元", [CMMUtility formatterNumberWithComma:product.baseAmount]];
    NSString *purchaseText = [NSString stringWithFormat:@"%@份起购", [NSNumber numberWithInteger:[product.minAmount integerValue]]];
    mInvestmentAndPurchaseLabel.text = [NSString stringWithFormat:@"%@ %@ %@", investText, baseText, purchaseText];
    
    NSString *plainString = [NSString stringWithFormat:QMLocalizedString(@"qm_recommendation_buyed_people_count", @"已购买人数%d人"), [product.saleAmount integerValue]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:plainString];
    [attrString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, QM_COMMON_TEXT_COLOR, NSForegroundColorAttributeName, nil] range:NSMakeRange(0, 5)];
    [attrString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, QM_THEME_COLOR, NSForegroundColorAttributeName, nil] range:NSMakeRange(5, plainString.length - 5)];
    mProductBuyedPeopleNumber.attributedText = attrString;
}

@end
