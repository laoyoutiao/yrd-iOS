//
//  QMMyFundAbstractCell.m
//  MotherMoney
//
//  Created by   on 14-8-9.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMMyFundAbstractCell.h"

@implementation QMMyFundAbstractCell {
    
    // 今日收益
    UILabel *dayEarningsTitleLbael;
    UILabel *dayEarningsValueLabel;
    
    // 总资产
    UILabel *totalFundTitleLabel;
    UILabel *totalFundValueLabel;
    
    // 累计收益
    UILabel *totalEarningsTitleLabel;
    UILabel *totalEarningsValueLabel;
    
    // 可用余额
    UILabel *availableFundTitleLabel;
    UILabel *availableFundValueLabel;
    
    UIImageView *totalItemContainerView;
    
    NSTimer* timer;
    
    NSString* todayEarningNumber;
    
}
//@synthesize viewGoodsListBtn = mViewGoodsListBtn;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundView = [[UIImageView alloc] initWithImage:nil];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundView.clipsToBounds = YES;
        
        // 总资产
        totalFundTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(frame), 13)];
        totalFundTitleLabel.font = [UIFont systemFontOfSize:14];
        totalFundTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        totalFundTitleLabel.text = @"总资产(元)";
        totalFundTitleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:totalFundTitleLabel];
        
        totalFundValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(totalFundTitleLabel.frame) + 8, CGRectGetWidth(totalFundTitleLabel.frame), 44)];
        
        totalFundValueLabel.text=@"财富积累从今天开始";
        totalFundValueLabel.font = [UIFont boldSystemFontOfSize:20];
        totalFundValueLabel.textColor = [UIColor whiteColor];
        totalFundValueLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:totalFundValueLabel];
        
        
        // 水平分割线
        UIImageView *horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        horizontalLine.frame = CGRectMake(10, CGRectGetMaxY(totalFundValueLabel.frame) + 20 + 13 + 8, CGRectGetWidth(frame) - 2 * 10, 1);
        [self.contentView addSubview:horizontalLine];
        horizontalLine.hidden = YES;
        
        UIImage *navBackgroundImage = [[UIImage imageNamed:nil] stretchableImageWithLeftCapWidth:2 topCapHeight:32];
        UIImageView *topBgView = [[UIImageView alloc] initWithImage:navBackgroundImage];
        topBgView.backgroundColor=[UIColor colorWithRed:243.0f/255.0f green:169.0f/255.0f blue:62.0f/255.0f alpha:1];
        UIImageView *maskImageView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImageTopPart]];
        maskImageView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetMaxY(horizontalLine.frame));
        topBgView.layer.mask = maskImageView.layer;
        
        [self.backgroundView addSubview:topBgView];
        [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backgroundView.mas_left);
            make.top.equalTo(self.backgroundView.mas_top);
            make.right.equalTo(self.backgroundView.mas_right);
            make.bottom.equalTo(horizontalLine.mas_top);
        }];
        
        totalItemContainerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(horizontalLine.frame), CGRectGetWidth(frame), 75)];
        totalItemContainerView.userInteractionEnabled = YES;
        totalItemContainerView.image = [QMImageFactory commonBackgroundImageTopPart];
        
        // 累计收益
        totalEarningsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, CGRectGetWidth(totalFundTitleLabel.frame) / 3, 25)];
        totalEarningsValueLabel.font = [UIFont systemFontOfSize:17];
        totalEarningsValueLabel.textColor =[UIColor colorWithRed:87.0f/255.0f green:87.0f/255.0f blue:87.0f/255.0f alpha:1];
        totalEarningsValueLabel.textAlignment = NSTextAlignmentCenter;
        [totalItemContainerView addSubview:totalEarningsValueLabel];
        
        totalEarningsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(totalEarningsValueLabel.frame), CGRectGetWidth(totalFundTitleLabel.frame) / 3.0f, 13)];
        totalEarningsTitleLabel.text = @"累计收益(元)";
        totalEarningsTitleLabel.textColor =[UIColor colorWithRed:143.0f/255.0f green:143.0f/255.0f blue:143.0f/255.0f alpha:1];
        totalEarningsTitleLabel.textAlignment = NSTextAlignmentCenter;
        totalEarningsTitleLabel.font = [UIFont systemFontOfSize:11];
        [totalItemContainerView addSubview:totalEarningsTitleLabel];
        
        // vertical line left
        UIImageView *verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalFundTitleLabel.frame) / 3, 0,0.5, CGRectGetHeight(frame))];
        verticalLine.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
        [totalItemContainerView addSubview:verticalLine];
        
        dayEarningsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalFundValueLabel.frame) / 3, CGRectGetMinY(totalEarningsValueLabel.frame), CGRectGetWidth(totalEarningsValueLabel.frame), CGRectGetHeight(totalEarningsValueLabel.frame))];
        dayEarningsValueLabel.font = [UIFont systemFontOfSize:17];
        dayEarningsValueLabel.textColor =[UIColor colorWithRed:87.0f/255.0f green:87.0f/255.0f blue:87.0f/255.0f alpha:1];
        dayEarningsValueLabel.textAlignment = NSTextAlignmentCenter;
        [totalItemContainerView addSubview:dayEarningsValueLabel];
        
        dayEarningsTitleLbael = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalFundValueLabel.frame) / 3, CGRectGetMaxY(totalEarningsValueLabel.frame), CGRectGetWidth(totalFundTitleLabel.frame) / 3.0f, 13)];
        dayEarningsTitleLbael.text = @"昨日收益(元)";
        dayEarningsTitleLbael.textColor =[UIColor colorWithRed:143.0f/255.0f green:143.0f/255.0f blue:143.0f/255.0f alpha:1];
        dayEarningsTitleLbael.textAlignment = NSTextAlignmentCenter;
        dayEarningsTitleLbael.font = [UIFont systemFontOfSize:11];
        [totalItemContainerView addSubview:dayEarningsTitleLbael];
        
        // vertical line right
        UIImageView *verticalLinet = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalFundTitleLabel.frame) / 3 * 2, 0,0.5, CGRectGetHeight(frame))];
        verticalLinet.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
        [totalItemContainerView addSubview:verticalLinet];
        
        // 可用余额
        availableFundValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalFundTitleLabel.frame) / 3 * 2, CGRectGetMinY(totalEarningsValueLabel.frame), CGRectGetWidth(totalEarningsValueLabel.frame), CGRectGetHeight(totalEarningsValueLabel.frame))];
        availableFundValueLabel.textAlignment = NSTextAlignmentCenter;
        availableFundValueLabel.font = [UIFont systemFontOfSize:17];
        availableFundValueLabel.textColor = [UIColor colorWithRed:87.0f/255.0f green:87.0f/255.0f blue:87.0f/255.0f alpha:1];
        [totalItemContainerView addSubview:availableFundValueLabel];
        
        availableFundTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalFundTitleLabel.frame) / 3 * 2, CGRectGetMinY(totalEarningsTitleLabel.frame), CGRectGetWidth(totalEarningsTitleLabel.frame), CGRectGetHeight(totalEarningsTitleLabel.frame))];
        availableFundTitleLabel.text = QMLocalizedString(@"qm_account_balance_left_format", nil);
        availableFundTitleLabel.textAlignment = NSTextAlignmentCenter;
        availableFundTitleLabel.textColor = [UIColor colorWithRed:143.0f/255.0f green:143.0f/255.0f blue:143.0f/255.0f alpha:1];
        availableFundTitleLabel.font = [UIFont systemFontOfSize:11];
        [totalItemContainerView addSubview:availableFundTitleLabel];
        
        [self.contentView addSubview:totalItemContainerView];
        [totalItemContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(horizontalLine.mas_top);
            make.height.equalTo(75.0f);
        }];
        
        
    }
    
    return self;
}

- (void)configureWithFundInfo:(QMMyFundModel *)info {
    // 总收益
    totalEarningsValueLabel.text = [CMMUtility formatterNumberWithComma:info.totalEarnings];
    
    // 账户余额
    availableFundValueLabel.text = [CMMUtility formatterNumberWithComma:info.ableWithdrawalAmount];
    
    // 总资产
    totalFundValueLabel.text = [CMMUtility formatterNumberWithComma:info.totalAssets];
    
    // 今日收益
    dayEarningsValueLabel.text = [CMMUtility formatterNumberWithComma:info.todayTotalEarnings];
    
//    if ([[CMMUtility formatterNumberWithComma:info.todayTotalEarnings] isEqualToString:@"0.00"]) {
//        [timer invalidate];
//        totalFundValueLabel.text = @"积累财富从今天开始";
//        totalFundValueLabel.font = [UIFont boldSystemFontOfSize:20];
//        totalFundValueLabel.textColor = [UIColor whiteColor];
//        totalFundValueLabel.textAlignment = NSTextAlignmentCenter;
//    }
//      else
//    {
//        
//        totalFundValueLabel.font = [UIFont boldSystemFontOfSize:42];
//        NSLog(@"todayEarning=%@",info.todayTotalEarnings);
//        
//        [self startTimer:info.todayTotalEarnings];
//    }
}

-(void)startTimer:(NSString*)string
{
//    todayEarningNumber=[NSString stringWithString:string];
//    timer=[NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//         [timer setFireDate:[NSDate date]];
}

-(void)timerAction
{
//    float dayEarningValue=[todayEarningNumber floatValue];
//    static float number=0.05;
//    if (number>dayEarningValue) {
//        [timer invalidate];
//        totalFundValueLabel.text=[NSString stringWithFormat:@"%.2f",dayEarningValue];
//        
//    }else
//    {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.01];
//        totalFundValueLabel.text=[NSString stringWithFormat:@"%.2f",number];
//        [UIView commitAnimations];
//        number=number+0.55;
//    }

}

+ (CGFloat)getAbstractViewHeightForFundInfo:(QMMyFundModel *)info {
    return 210.0f;
}

@end
