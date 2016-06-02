//
//  QMBuyedProductRecordInfoHeaderView.m
//  MotherMoney
#import "QMBuyedProductRecordInfoHeaderView.h"

@implementation QMBuyedProductRecordInfoHeaderView {
    UILabel *mProductNameLabel;
    UILabel *mPrincipalLabel;
    UILabel *mEarningsLabel;
    UILabel *mBankCardLabel;
    
    UIImageView *separatorLine;
}
@synthesize productNameLabel = mProductNameLabel;
@synthesize principalLabel = mPrincipalLabel;
@synthesize earningsLabel = mEarningsLabel;
@synthesize bankCardLabel = mBankCardLabel;

- (id)initWithFrame:(CGRect)frame
{
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
            make.bottom.equalTo(backgroundView.mas_bottom);
            make.height.equalTo(1.0f);
            make.right.equalTo(backgroundView.mas_right).offset(-1.0f * horizontalPadding);
        }];
        
        // 产品名称
        mProductNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mProductNameLabel.textAlignment = NSTextAlignmentCenter;
        mProductNameLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mProductNameLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        mProductNameLabel.font = [UIFont systemFontOfSize:11];
        mProductNameLabel.text = QMLocalizedString(@"qm_product_buy_date_title", @"购买时间");
        [self addSubview:mProductNameLabel];
        [mProductNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(separatorLine.mas_left);
            make.top.equalTo(backgroundView.mas_top);
            make.width.equalTo(separatorLine.mas_width).dividedBy(4.0f);
            make.bottom.equalTo(backgroundView.mas_bottom);
        }];
        
        // 本金
        mPrincipalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mPrincipalLabel.textAlignment = NSTextAlignmentCenter;
        mPrincipalLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mPrincipalLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        mPrincipalLabel.font = [UIFont systemFontOfSize:11];
        mPrincipalLabel.text = QMLocalizedString(@"qm_product_buy_base_money_title", @"本金(元)");
        [self addSubview:mPrincipalLabel];
        [mPrincipalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mProductNameLabel.mas_right);
            make.top.equalTo(mProductNameLabel.mas_top);
            make.width.equalTo(mProductNameLabel.mas_width);
            make.bottom.equalTo(mProductNameLabel.mas_bottom);
        }];
        
        // 收益
        mEarningsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mEarningsLabel.textAlignment = NSTextAlignmentCenter;
        mEarningsLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mEarningsLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        mEarningsLabel.font = [UIFont systemFontOfSize:11];
        mEarningsLabel.text = QMLocalizedString(@"qm_product_buy_earning_title", @"收益(元)");
        [self addSubview:mEarningsLabel];
        [mEarningsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mPrincipalLabel.mas_right);
            make.top.equalTo(mPrincipalLabel.mas_top);
            make.width.equalTo(mPrincipalLabel.mas_width);
            make.bottom.equalTo(mPrincipalLabel.mas_bottom);
        }];
        
        // 银行卡
        mBankCardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mBankCardLabel.textAlignment = NSTextAlignmentCenter;
        mBankCardLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mBankCardLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        mBankCardLabel.font = [UIFont systemFontOfSize:11];
        mBankCardLabel.text = QMLocalizedString(@"qm_product_buy_state_title", @"状态");
        [self addSubview:mBankCardLabel];
        [mBankCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mEarningsLabel.mas_right);
            make.top.equalTo(mEarningsLabel.mas_top);
            make.width.equalTo(mEarningsLabel.mas_width);
            make.bottom.equalTo(mEarningsLabel.mas_bottom);
        }];
    }
    
    return self;
}

+ (CGFloat)getProductInfoHeaderHeight {
    return 35.0f;
}

@end

