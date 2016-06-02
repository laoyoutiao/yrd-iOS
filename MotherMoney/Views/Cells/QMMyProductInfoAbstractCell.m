//
//  QMMyProductInfoAbstractCell.m
//  MotherMoney

#import "QMMyProductInfoAbstractCell.h"
#import "QMBankInfoView.h"

@implementation QMMyProductInfoAbstractCell {
    UILabel *dayEarningsTitleLabel; // 今日收益
    UILabel *dayEarningsValueLabel;
    
    // container view
    UIView *totalItemContainerView;
    
    QMBankInfoView *bankInfoView;
    
    // 产品本金
    UILabel *totalFundTitleLabel;
    UILabel *totalFundValueLabel;
    
    // 产品累计收益
    UILabel *totalEarningsTitleLabel;
    UILabel *totalEarningsValueLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImageTopPart]];
        self.layer.cornerRadius=5.0f;
        self.layer.masksToBounds=YES;
        // 昨日收益
        dayEarningsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(frame), 13)];
        dayEarningsTitleLabel.font = [UIFont systemFontOfSize:11];
        dayEarningsTitleLabel.textAlignment = NSTextAlignmentCenter;
        dayEarningsTitleLabel.text = @"昨日收益（元）";
        dayEarningsTitleLabel.textColor = [UIColor colorWithRed:86.0f/255.0f green:86.0f/255.0f blue:86.0f/255.0f alpha:1];
        [self.contentView addSubview:dayEarningsTitleLabel];
        
        dayEarningsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dayEarningsTitleLabel.frame) + 8, CGRectGetWidth(dayEarningsTitleLabel.frame), 44)];
        dayEarningsValueLabel.font = [UIFont boldSystemFontOfSize:42];
        dayEarningsValueLabel.textAlignment = NSTextAlignmentCenter;
        dayEarningsValueLabel.textColor=[UIColor colorWithRed:236.0f/255.0f green:71.0f/255.0f blue:59.0f/255.0f alpha:1];
        [self.contentView addSubview:dayEarningsValueLabel];
        
        // 查看交易记录
        bankInfoView = [[QMBankInfoView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - 40 - 15, CGRectGetMaxY(dayEarningsValueLabel.frame), 45, 20)];
        [self.contentView addSubview:bankInfoView];
        
        // 水平分割线
        UIImageView *horizontalLine = [[UIImageView alloc] init];
        horizontalLine.frame = CGRectMake(0, CGRectGetMinY(bankInfoView.frame) + 13 + 8, CGRectGetWidth(frame),0.5);
        horizontalLine.backgroundColor=QM_COMMON_BACKGROUND_COLOR;
        [self.contentView addSubview:horizontalLine];
        
        totalItemContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(horizontalLine.frame), CGRectGetWidth(frame), 75)];
        
        // 总资产
        totalFundValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, CGRectGetWidth(frame) / 2, 25)];
        totalFundValueLabel.font = [UIFont systemFontOfSize:23];
        totalFundValueLabel.textColor = [UIColor blackColor];
        totalFundValueLabel.textAlignment = NSTextAlignmentCenter;
        [totalItemContainerView addSubview:totalFundValueLabel];
        
        totalFundTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(totalFundValueLabel.frame), CGRectGetWidth(frame) / 2.0f, 13)];
        totalFundTitleLabel.text = QMLocalizedString(@"qm_product_base_money", @"产品本金(元)");
        
        totalFundTitleLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        totalFundTitleLabel.textAlignment = NSTextAlignmentCenter;
        totalFundTitleLabel.font = [UIFont systemFontOfSize:11];
        [totalItemContainerView addSubview:totalFundTitleLabel];
        
        // vertical line
        UIImageView *verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(frame), 0, 0.5, 75)];
        verticalLine.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
        [totalItemContainerView addSubview:verticalLine];
        
        // 总收益
        totalEarningsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(frame), CGRectGetMinY(totalFundValueLabel.frame), CGRectGetWidth(frame) / 2.0f, CGRectGetHeight(totalFundValueLabel.frame))];
        totalEarningsValueLabel.textAlignment = NSTextAlignmentCenter;
        totalEarningsValueLabel.font = [UIFont systemFontOfSize:23];
        totalEarningsValueLabel.textColor = [UIColor colorWithRed:221.0f / 255.0f green:46.0f / 255.0f blue:28.0f / 255.0f alpha:1.0f];
        [totalItemContainerView addSubview:totalEarningsValueLabel];

        totalEarningsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(frame), CGRectGetMinY(totalFundTitleLabel.frame), CGRectGetWidth(totalEarningsValueLabel.frame), CGRectGetHeight(totalFundValueLabel.frame))];
        totalEarningsTitleLabel.text = QMLocalizedString(@"qm_product_total_earnings", @"产品累计收益(元)");
        totalEarningsTitleLabel.textAlignment = NSTextAlignmentCenter;
        totalEarningsTitleLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        totalEarningsTitleLabel.font = [UIFont systemFontOfSize:11];
        [totalItemContainerView addSubview:totalEarningsTitleLabel];
        
        [self.contentView addSubview:totalItemContainerView];
        
        
    }
    return self;
}

- (void)configureWithFundInfo:(QMBuyedProductInfo *)info {
    totalFundValueLabel.text = [CMMUtility formatterNumberWithComma:info.totalBuyAmount];
    
    totalEarningsValueLabel.text = [CMMUtility formatterNumberWithComma:info.totalEarnings];
    
    dayEarningsValueLabel.text = [CMMUtility formatterFourNumberWithComma:info.todayTotalEarnings];
    
    
    
    [bankInfoView configureWithBankCardInfo:info.bandInfo];
}

+ (CGFloat)getAbstractViewHeightForFundInfo:(QMBuyedProductInfo *)info {
    return 190.0f;
}

@end
