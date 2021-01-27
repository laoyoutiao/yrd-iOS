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
            make.edges.equalTo(UIEdgeInsetsMake(8, 0, 0, 0));
        }];
        
        // 产品名称
        mProductNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mProductNameLabel.textAlignment = NSTextAlignmentLeft;
        mProductNameLabel.textColor = [UIColor blackColor];
        mProductNameLabel.numberOfLines = 1;
        [backgroundImageView addSubview:mProductNameLabel];
        
        [mProductNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundImageView.mas_left).offset(CONTENT_LEFT_PADDING);
            make.right.equalTo(backgroundImageView.mas_right).offset(-1.0f * CONTENT_RIGHT_PADDING);
            make.top.equalTo(backgroundImageView.mas_top).offset(10);
            make.height.equalTo(IS_IPHONE_6_PLUS? 40:20);
        }];
        
        UIImage *image = [UIImage imageNamed:@"product_home_icon"];
        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
        [backgroundImageView addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backgroundImageView.mas_right).offset(-1.0f * CONTENT_RIGHT_PADDING);
            make.top.equalTo(backgroundImageView.mas_top);
            make.width.equalTo(IS_IPHONE_6_PLUS? image.size.height + 8 : image.size.width);
            make.height.equalTo(IS_IPHONE_6_PLUS? image.size.height + 13 : image.size.height - 5);
        }];
        
        //分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor grayColor];
        [backgroundImageView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundImageView.mas_left).offset(CONTENT_LEFT_PADDING);
            make.top.equalTo(mProductNameLabel.mas_bottom).offset(10);
            make.right.equalTo(backgroundImageView.mas_right).offset(-1.0f * CONTENT_RIGHT_PADDING);
            make.height.equalTo(1.0f);
        }];
        
        // 预期年化率
        mExpectYearRateValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mExpectYearRateValueLabel.font = [UIFont systemFontOfSize:40.0f];
        mExpectYearRateValueLabel.textColor = QM_THEME_COLOR;
        [backgroundImageView addSubview:mExpectYearRateValueLabel];
        [mExpectYearRateValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundImageView.mas_left).offset(CONTENT_LEFT_PADDING + 30);
            make.top.equalTo(mProductNameLabel.mas_bottom).offset(20);
            make.height.equalTo(40);
            make.width.equalTo(110);
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
        
        
        mExpectYearRateTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        mExpectYearRateTitleLabel.textColor = [UIColor colorWithRed:108 / 255.0f green:108.0f / 255.0f blue:108.0f / 255.0f alpha:1.0f];
        mExpectYearRateTitleLabel.textColor = QM_COMMON_TEXT_COLOR;
        mExpectYearRateTitleLabel.font = [UIFont systemFontOfSize:20];
        mExpectYearRateTitleLabel.text = QMLocalizedString(@"qm_product_list_expected_year_earnings", @"预期年化率");
        [backgroundImageView addSubview:mExpectYearRateTitleLabel];
        [mExpectYearRateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundImageView.mas_left).offset(CONTENT_LEFT_PADDING + 30);
            make.top.equalTo(mExpectYearRateValueLabel.mas_bottom).offset(10);
            make.width.equalTo(mExpectYearRateValueLabel.mas_width);
            make.height.equalTo(15.0f);
        }];
        
        mFinancingRateProgress = [[QMProgressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * 8 - 2 * 15, 12.0f)];
        [backgroundImageView addSubview:mFinancingRateProgress];
        [mFinancingRateProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mExpectYearRateTitleLabel.mas_left).offset(-30);
            make.top.equalTo(mExpectYearRateTitleLabel.mas_bottom).offset(10.0f);
            make.right.equalTo(backgroundImageView.mas_right).offset(-1.0f * CONTENT_RIGHT_PADDING);
            make.height.equalTo(12.0f);
        }];
        
        mFinancingRateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mFinancingRateLabel.textColor = QM_COMMON_TEXT_COLOR;
        mFinancingRateLabel.font = [UIFont systemFontOfSize:13];
//        mFinancingRateLabel.text = QMLocalizedString(@"qm_recommendation_finance_already", @"已经融资");
        [backgroundImageView addSubview:mFinancingRateLabel];
        [mFinancingRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mFinancingRateProgress.mas_left);
            make.top.equalTo(mFinancingRateProgress.mas_bottom).offset(5);
            make.size.equalTo(CGSizeMake(100, 0));
        }];
        
        // 投资期限和起购金额
        mInvestmentAndPurchaseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mInvestmentAndPurchaseLabel.font = [UIFont systemFontOfSize:13];
        mInvestmentAndPurchaseLabel.textColor = QM_COMMON_TEXT_COLOR;
        [backgroundImageView addSubview:mInvestmentAndPurchaseLabel];
        [mInvestmentAndPurchaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            if ([UIScreen mainScreen].bounds.size.width > 320)
            {
                make.left.equalTo(mExpectYearRateValueLabel.mas_right).offset(70);
                make.top.equalTo(mExpectYearRateValueLabel.mas_top).offset(5);
                make.right.equalTo(backgroundImageView.mas_right).offset(20);
                make.height.equalTo(60);
            }else
            {
                make.left.equalTo(mExpectYearRateValueLabel.mas_right).offset(20);
                make.top.equalTo(mExpectYearRateValueLabel.mas_top).offset(5);
                make.right.equalTo(backgroundImageView.mas_right).offset(20);
                make.height.equalTo(60);
            }
        }];
        

        
        // 已购买人数
        mProductBuyedPeopleNumber = [[UILabel alloc] initWithFrame:CGRectZero];
        mProductBuyedPeopleNumber.font = [UIFont systemFontOfSize:13];
        [backgroundImageView addSubview:mProductBuyedPeopleNumber];
        [mProductBuyedPeopleNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mFinancingRateLabel.mas_left);
            make.top.equalTo(mFinancingRateLabel.mas_bottom);
            make.right.equalTo(backgroundImageView.mas_right).offset(20);
            make.height.equalTo(30);
        }];
        
        // 水平分割线
        UIImageView *horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        [backgroundImageView addSubview:horizontalLine];
        [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mFinancingRateLabel.mas_left);
            make.top.equalTo(mProductBuyedPeopleNumber.mas_bottom).offset(0);
            make.width.equalTo(mFinancingRateProgress.mas_width);
            make.height.equalTo(1.0f);
        }];
        
        
        // 购买按钮
        self.actionBtn = [QMControlFactory commonButtonWithSize:CGSizeZero title:QMLocalizedString(@"qm_recommendation_buy_btn_title", @"购买") target:nil selector:nil];
        self.actionBtn.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE_6_PLUS? 17:14];
        [backgroundImageView addSubview:_actionBtn];
        [_actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(horizontalLine.mas_left);
            make.top.equalTo(horizontalLine.mas_bottom).offset(10.0f);
            make.width.equalTo(horizontalLine.mas_width);
            make.height.equalTo(IS_IPHONE_6_PLUS? 50.0f : 40.0f);
        }];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        label.text = @"投 资 有 风 险 , 理 财 需 谨 慎";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor grayColor];
        [backgroundImageView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(10.0f);
        }];
    }
    
    return self;
}

+ (CGFloat)getCellHeightForProductInfo:(QMProductInfo *)product {
    if (IS_IPHONE_6_PLUS) {
        return 270 + 16;
    }
    
    return 250 + 16;
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

//    NSString *investText = [NSString stringWithFormat:@"期限 %@", maturityAndUnit];
//    NSString *baseText = [NSString stringWithFormat:@"每份%@元", [CMMUtility formatterNumberWithComma:product.baseAmount]];
//    NSString *purchaseText = [NSString stringWithFormat:@"%@份起购", [NSNumber numberWithInteger:[product.minAmount integerValue]]];
    
    mInvestmentAndPurchaseLabel.numberOfLines = 3;

    if (maturityAndUnit.length == 0) {
        return;
    }
    
    NSString *investText = [NSString stringWithFormat:@"%@ 天", maturityAndUnit.length? [maturityAndUnit substringWithRange:NSMakeRange(0, maturityAndUnit.length - 1)]:maturityAndUnit];
    NSInteger basemount = product.baseAmount.integerValue;
    NSString *baseText = [NSString stringWithFormat:@"%ld 元", basemount];
    NSString *plainStr = [NSString stringWithFormat:@"%@\t\t%@\n\n期 限\t\t  起 投", investText, baseText];
    NSLog(@"%ld",plainStr.length);
    NSMutableAttributedString *purattrString = [[NSMutableAttributedString alloc] initWithString:plainStr];
    [purattrString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:22], NSFontAttributeName, QM_COMMON_TEXT_COLOR, NSForegroundColorAttributeName, nil] range:NSMakeRange(0, maturityAndUnit.length - 1)];
    [purattrString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, QM_THEME_COLOR, NSForegroundColorAttributeName, nil] range:NSMakeRange(maturityAndUnit.length, 1)];
    [purattrString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:22], NSFontAttributeName, QM_COMMON_TEXT_COLOR, NSForegroundColorAttributeName, nil] range:NSMakeRange(maturityAndUnit.length + 3, 2)];
    [purattrString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, QM_THEME_COLOR, NSForegroundColorAttributeName, nil] range:NSMakeRange(maturityAndUnit.length + 6, 1)];
    
    [purattrString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, QM_COMMON_TEXT_COLOR, NSForegroundColorAttributeName, nil] range:NSMakeRange(plainStr.length - 5, 3)];
    
    [purattrString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, QM_COMMON_TEXT_COLOR, NSForegroundColorAttributeName, nil] range:NSMakeRange(plainStr.length - 10, 3)];
    
    mInvestmentAndPurchaseLabel.attributedText = purattrString;
//    mInvestmentAndPurchaseLabel.font = [UIFont boldSystemFontOfSize:15];
    
//    NSString *plainString = [NSString stringWithFormat:QMLoc alizedString(@"qm_recommendation_buyed_people_count", @"已购买人数%d人"), [product.saleAmount integerValue]];
    
    NSString *plainString = [NSString stringWithFormat:@"已售份数:%d份\t剩余份数:%d份\t%ld元/份", [product.saleAmount intValue],[product.remainingAmount intValue],basemount];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:plainString];

    [attrString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, QM_THEME_COLOR, NSForegroundColorAttributeName, nil] range:NSMakeRange(5, product.saleAmount.length + 1)];
    [attrString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, QM_THEME_COLOR, NSForegroundColorAttributeName, nil] range:NSMakeRange(12 + product.saleAmount.length , product.remainingAmount.length + 1)];
    mProductBuyedPeopleNumber.attributedText = attrString;
}

@end
