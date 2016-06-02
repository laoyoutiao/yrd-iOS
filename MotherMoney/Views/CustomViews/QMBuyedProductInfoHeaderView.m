//
//  QMBuyedProductInfoHeaderView.m
//  MotherMoney
//
//  Created by   on 14-8-9.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMBuyedProductInfoHeaderView.h"

@implementation QMBuyedProductInfoHeaderView {
    UILabel *mProductNameLabel;
    UILabel *mPrincipalLabel;
    UILabel *mEarningsLabel;
    
    UIImageView *separatorLine;
}
@synthesize productNameLabel = mProductNameLabel;
@synthesize principalLabel = mPrincipalLabel;
@synthesize earningsLabel = mEarningsLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        CGFloat horizontalPadding = 10;
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImageCenterPart]];
        backgroundView.frame = CGRectMake(10, 0, CGRectGetWidth(frame) - 2 * 10, CGRectGetHeight(frame));
        [self addSubview:backgroundView];
        
        // line
        separatorLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        [self addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView.mas_left).offset(horizontalPadding);
            make.top.equalTo(self.mas_bottom).offset(-1.0f);
            make.right.equalTo(backgroundView.mas_right).offset(-1.0f * horizontalPadding);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        // 产品名称
        mProductNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mProductNameLabel.textAlignment = NSTextAlignmentCenter;
        mProductNameLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mProductNameLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        mProductNameLabel.font = [UIFont systemFontOfSize:11];
        mProductNameLabel.text = QMLocalizedString(@"qm_myfund_product_name_title", @"产品名称");
        [self addSubview:mProductNameLabel];
        [mProductNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(separatorLine.mas_left);
            make.top.equalTo(backgroundView.mas_top);
            make.bottom.equalTo(backgroundView.mas_bottom);
            make.width.equalTo(separatorLine.mas_width).dividedBy(3.0f);
        }];
        
        // 本金
        mPrincipalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mPrincipalLabel.textAlignment = NSTextAlignmentCenter;
        mPrincipalLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mPrincipalLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        mPrincipalLabel.font = [UIFont systemFontOfSize:11];
        mPrincipalLabel.text = QMLocalizedString(@"qm_myfund_product_principal_title", @"本金");
        [self addSubview:mPrincipalLabel];
        [mPrincipalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mProductNameLabel.mas_right);
            make.top.equalTo(mProductNameLabel.mas_top);
            make.width.equalTo(mProductNameLabel.mas_width);
            make.height.equalTo(mProductNameLabel.mas_height);
        }];
        
        // 收益
        mEarningsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mEarningsLabel.textAlignment = NSTextAlignmentCenter;
        mEarningsLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mEarningsLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        mEarningsLabel.font = [UIFont systemFontOfSize:11];
        mEarningsLabel.text = QMLocalizedString(@"qm_myfund_product_earnings_title", @"收益");
        [self addSubview:mEarningsLabel];
        [mEarningsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mPrincipalLabel.mas_right);
            make.top.equalTo(mPrincipalLabel.mas_top);
            make.width.equalTo(mPrincipalLabel.mas_width);
            make.height.equalTo(mPrincipalLabel.mas_height);
        }];
    }
    
    return self;
}

+ (CGFloat)getProductInfoHeaderHeight {
    return 35.0f;
}


@end
