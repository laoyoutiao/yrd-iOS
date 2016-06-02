//
//  QMProductInfoCell.m
//  MotherMoney
//
//  Created by   on 14-8-7.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMProductInfoCell.h"

@implementation QMProductInfoCell {
    UILabel *expectYearEarningsTitleLabel;
    UILabel *expectedYearEarningsValueLabel;
    UILabel *buyNumberTitleLabel;
    UILabel *buyNumberValueLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 预期年化收益title
        expectYearEarningsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
        expectYearEarningsTitleLabel.text = QMLocalizedString(@"qm_product_info_page_expectedYearEarning_title", @"预期年化收益");
        [self.contentView addSubview:expectYearEarningsTitleLabel];
        
        // 预期年化收益value
        expectedYearEarningsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(expectYearEarningsTitleLabel.frame), CGRectGetMaxY(expectYearEarningsTitleLabel.frame) + 10, 160, 60)];
        expectedYearEarningsValueLabel.font = [UIFont boldSystemFontOfSize:50];
        expectedYearEarningsValueLabel.textColor = QM_THEME_COLOR;
        expectedYearEarningsValueLabel.text = @"10.00%";
        [self.contentView addSubview:expectedYearEarningsValueLabel];
        
        // 购买人数title
        buyNumberTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(expectedYearEarningsValueLabel.frame) + 10, CGRectGetMinY(expectedYearEarningsValueLabel.frame), 100, 20)];
        buyNumberTitleLabel.text = QMLocalizedString(@"qm_product_info_page_buy_number_title", @"购买人数");
        buyNumberTitleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:buyNumberTitleLabel];
        
        // 购买人数value
        buyNumberValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(buyNumberTitleLabel.frame), CGRectGetMaxY(buyNumberTitleLabel.frame) + 5, CGRectGetWidth(buyNumberTitleLabel.frame), 20)];
        buyNumberValueLabel.text = @"13058人";
        buyNumberValueLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:buyNumberValueLabel];
        
    }
    return self;
}

- (void)configureProductInfoCellWithProductInfo:(QMProductInfo *)info {
    
}

+ (CGFloat)getCellHeightForProduct:(QMProductInfo *)product {
    return 150;
}

@end
