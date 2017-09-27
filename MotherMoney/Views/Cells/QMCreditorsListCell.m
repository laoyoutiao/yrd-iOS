//
//  QMCreditorsListCell.m
//  MotherMoney
//
//  Created by cgt cgt on 2017/6/13.
//  Copyright © 2017年 cgt cgt. All rights reserved.
//

#import "QMCreditorsListCell.h"
#import "QMProgressView.h"

CGFloat expectYearEarningTitleValueGapT = 4;

@implementation QMCreditorsListCell{
    UILabel *mProductNameLabel;
    UILabel *mCreditorsBuyedPeopleNumber;
    UILabel *mCreditorsNotBuyeNumber;
    
    UILabel *settlementTypeLabel;
    UILabel *pricePercentagelabel;
    UIImageView *horizontalLineView;
    
    UILabel *mExpectYearRateTitleLabel;// 预期年化标题
    UILabel *mExpectYearRateValueLabel; // 预期年化率值
    UILabel *mExpectYearRateSubValueLabel;
    
    UIView *flexibleView1;
    // 中间竖线
    UIImageView *verticalLineView;
    UIView *flexibleView2;
    UIView *diamondone;
    UIView *diamondtwo;
    UIView *diamondthere;
    UIView *diamondfour;
    
    UILabel *remainingDayLabel; // 投资期限
    UILabel *mTransferPrincipalLabel; // 起购金额
    
    // 融资率
    UILabel *mFinancingRateLabel;
    
    UIFont *productNameFont;
    UIFont *expectYearEarningTitleFont;
    UIFont *expectYearEarningValueFont;
    QMProgressView *mFinancingRateProgress;
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
            make.top.equalTo(superView.mas_top);
            make.size.equalTo(CGSizeMake(250.0f, 35.0f));
        }];
        
        // 标记
        flagImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:flagImageView];
        [flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView.mas_top).offset(6);
            make.right.equalTo(superView.mas_right).offset(-6.0f);
            make.size.equalTo(CGSizeMake(27, 26));
        }];
        
        // 水平线
        UIImage *horizontalImage = [QMImageFactory commonHorizontalLineImage];
        horizontalLineView = [[UIImageView alloc] initWithImage:horizontalImage];
        [self.contentView addSubview:horizontalLineView];
        [horizontalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mProductNameLabel.mas_left);
            make.top.equalTo(mProductNameLabel.mas_bottom).offset(-1.0f);
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
            make.left.equalTo(mProductNameLabel.mas_left);
            make.top.equalTo(horizontalLineView.mas_bottom).offset(5.0f);
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
        
        
        
        CGFloat expectYearRateValueTopY = 45;
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
        //verticalLineView.backgroundColor = [UIColor colorWithRed:229.0f / 255.0f green:229.0f / 255.0f blue:229.0f / 255.0f alpha:1.0f];
        [self.contentView addSubview:verticalLineView];
        [verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(flexibleView1.mas_right);
            make.top.equalTo(expectYearRateValueTopY);
            make.size.equalTo(CGSizeMake(1.0f, 50.0f));
        }];
        
//        flexibleView2 = [[UIView alloc] initWithFrame:CGRectZero];
//        flexibleView2.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:flexibleView2];
//        [flexibleView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(verticalLineView);
//            make.top.equalTo(verticalLineView.mas_top);
//            make.width.equalTo(flexibleView1.mas_width);
//            make.bottom.equalTo(verticalLineView.mas_bottom);
//        }];
        
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
        remainingDayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        remainingDayLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        remainingDayLabel.textColor = [UIColor colorWithRed:140.0f / 255.0f green:140.0f / 255.0f blue:140.0f / 255.0f alpha:1.0f];
        remainingDayLabel.font = investmentPeriodFont;
        [self.contentView addSubview:remainingDayLabel];
        [remainingDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(flexibleView2.mas_right);
            make.top.equalTo(verticalLineView.mas_top).offset(-2.0f);
//            make.right.equalTo(10.0f);
            make.size.equalTo(CGSizeMake(100, investmentPeriodFont.lineHeight));
        }];
        
        diamondone = [[UIView alloc] initWithFrame:CGRectZero];
        diamondone.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:diamondone];
        [diamondone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(remainingDayLabel.mas_left).offset(-10.0f);
            make.centerY.equalTo(remainingDayLabel.mas_centerY);
            make.size.equalTo(CGSizeMake(5,5));
        }];
        
        // 起购金额
        mTransferPrincipalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mTransferPrincipalLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mTransferPrincipalLabel.textColor = [UIColor colorWithRed:140.0f / 255.0f green:140.0f / 255.0f blue:140.0f / 255.0f alpha:1.0f];
        mTransferPrincipalLabel.font = [UIFont systemFontOfSize:13];
        mTransferPrincipalLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:mTransferPrincipalLabel];
        [mTransferPrincipalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(remainingDayLabel.mas_left);
            make.top.equalTo(remainingDayLabel.mas_bottom).offset(expectYearEarningTitleValueGapT);
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
            make.height.equalTo(remainingDayLabel.mas_height);
        }];
        
        diamondtwo = [[UIView alloc] initWithFrame:CGRectZero];
        diamondtwo.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:diamondtwo];
        [diamondtwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(mTransferPrincipalLabel.mas_left).offset(-10.0f);
            make.centerY.equalTo(mTransferPrincipalLabel.mas_centerY);
            make.size.equalTo(CGSizeMake(5,5));
        }];
        
        settlementTypeLabel = [[UILabel alloc] init];
        settlementTypeLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        settlementTypeLabel.font = [UIFont systemFontOfSize:13];
        settlementTypeLabel.textColor =[UIColor colorWithRed:140.0f / 255.0f green:140.0f / 255.0f blue:140.0f / 255.0f alpha:1.0f];
        [self.contentView addSubview:settlementTypeLabel];
        [settlementTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mTransferPrincipalLabel.mas_left);
            make.top.equalTo(mTransferPrincipalLabel.mas_bottom).offset(expectYearEarningTitleValueGapT);
            make.width.equalTo(mTransferPrincipalLabel.mas_width);
            make.height.equalTo(mTransferPrincipalLabel.mas_height);
        }];
        
        pricePercentagelabel = [[UILabel alloc] init];
        pricePercentagelabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        pricePercentagelabel.font = [UIFont systemFontOfSize:13];
        pricePercentagelabel.textColor =[UIColor colorWithRed:140.0f / 255.0f green:140.0f / 255.0f blue:140.0f / 255.0f alpha:1.0f];
        [self.contentView addSubview:pricePercentagelabel];
        [pricePercentagelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(settlementTypeLabel.mas_left);
            make.top.equalTo(settlementTypeLabel.mas_bottom).offset(expectYearEarningTitleValueGapT);
            make.width.equalTo(settlementTypeLabel.mas_width);
            make.height.equalTo(settlementTypeLabel.mas_height);
        }];
        
        diamondthere = [[UIView alloc] initWithFrame:CGRectZero];
        diamondthere.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:diamondthere];
        [diamondthere mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(settlementTypeLabel.mas_left).offset(-10.0f);
            make.centerY.equalTo(settlementTypeLabel.mas_centerY);
            make.size.equalTo(CGSizeMake(5,5));
        }];
        
        diamondfour = [[UIView alloc] initWithFrame:CGRectZero];
        diamondfour.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:diamondfour];
        [diamondfour mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(pricePercentagelabel.mas_left).offset(-10.0f);
            make.centerY.equalTo(pricePercentagelabel.mas_centerY);
            make.size.equalTo(CGSizeMake(5,5));
        }];
        
        mFinancingRateProgress = [[QMProgressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * 8 - 2 * 15, 12.0f)];
        [self.contentView addSubview:mFinancingRateProgress];
        [mFinancingRateProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15.0f);
            make.top.equalTo(mExpectYearRateTitleLabel.mas_bottom).offset(30.0f);
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
            make.height.equalTo(9.0f);
        }];
        
        
        // 已售
        mCreditorsBuyedPeopleNumber = [[UILabel alloc] initWithFrame:CGRectZero];
        mCreditorsBuyedPeopleNumber.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mCreditorsBuyedPeopleNumber.textAlignment = NSTextAlignmentLeft;
        mCreditorsBuyedPeopleNumber.textColor = QM_COMMON_TEXT_COLOR;
        mCreditorsBuyedPeopleNumber.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:mCreditorsBuyedPeopleNumber];
        [mCreditorsBuyedPeopleNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(superView.mas_bottom);
            make.top.equalTo(mFinancingRateProgress.mas_bottom);
            make.left.equalTo(superView.mas_left).offset(15.0f);
            make.width.equalTo(100.0f);
        }];
        
        mCreditorsNotBuyeNumber = [[UILabel alloc] initWithFrame:CGRectZero];
        mCreditorsNotBuyeNumber.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mCreditorsNotBuyeNumber.textAlignment = NSTextAlignmentRight;
        mCreditorsNotBuyeNumber.textColor = QM_COMMON_TEXT_COLOR;
        mCreditorsNotBuyeNumber.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:mCreditorsNotBuyeNumber];
        [mCreditorsNotBuyeNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(superView.mas_bottom);
            make.top.equalTo(mFinancingRateProgress.mas_bottom);
            make.right.equalTo(superView.mas_right).offset(-15.0f);
            make.width.equalTo(100.0f);
        }];
        
    }
    
    return self;
}

- (void)configureCellWithProductionInfo:(QMCreditorsInfo *)info {
    settlementTypeLabel.text = [NSString stringWithFormat:@"还息方式:%@",info.isMonthlySettlement.integerValue? @"按月付息":@"到期还息"];

    pricePercentagelabel.text = [NSString stringWithFormat:@"折扣价/溢价:%@%%",info.pricePercentage];
    
    if (nil == info || ![info isKindOfClass:[QMCreditorsInfo class]]) {
        return;
    }
    
    diamondone.transform = CGAffineTransformMakeRotation(M_PI_4);
    diamondtwo.transform = CGAffineTransformMakeRotation(M_PI_4);
    diamondthere.transform = CGAffineTransformMakeRotation(M_PI_4);
    diamondfour.transform = CGAffineTransformMakeRotation(M_PI_4);
    
    // 产品名称
    NSString *productName = info.productName;
    if (!QM_IS_STR_NIL(productName)) {
        mProductNameLabel.text = productName;
    }else {
        mProductNameLabel.text = @"";
    }
    
    CGFloat progress = [info.progressRate floatValue] / 100.0f;
    [mFinancingRateProgress setCurrentProgress:progress];

    
    // 购买人数
    mCreditorsBuyedPeopleNumber.text = [NSString stringWithFormat:@"已转让份数: %@", info.transferredNum];
    mCreditorsNotBuyeNumber.text = [NSString stringWithFormat:@"剩余份数: %@", info.remainingNum];
    
    // 预期年化率
    mExpectYearRateTitleLabel.text = QMLocalizedString(@"qm_product_list_expected_year_earnings", @"预期年化率");
    mExpectYearRateValueLabel.text = [NSString stringWithFormat:@"%.1f%%", [info.interest floatValue]];
    
    // 投资期限
    NSString *plainStr = [NSString stringWithFormat:@"剩余天数:%@", info.remainingDay];
    remainingDayLabel.text = plainStr;
    
    // 起购金额
    NSString *purchasePlainStr = [NSString stringWithFormat:@"转让金额:%@",info.transferPrincipal];
    mTransferPrincipalLabel.text = purchasePlainStr;
    
    // 产品标记
    flagImageView.image = [self flagImageForProductInfo:info];
}

- (UIImage *)flagImageForProductInfo:(QMCreditorsInfo *)info {
    NSString *imageName = nil;
    imageName = @"product_creditors_icon.png";
    if (!QM_IS_STR_NIL(imageName)) {
        return [UIImage imageNamed:imageName];
    }
    return nil;
}

+ (CGFloat)getCellHeightForProductInfo:(QMCreditorsInfo *)info {
    return 170;
}


@end
