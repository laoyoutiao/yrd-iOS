//
//  QMMyFundAbstractCell.m
//  MotherMoney
//
//  Created by   on 14-8-9.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMMyFundAbstractCell.h"

@implementation QMMyFundAbstractCell {
    UILabel *dayEarningsTitleLabel; // 今日收益
    UILabel *dayEarningsValueLabel;//今日收益值
    
    
    UIImageView *totalItemContainerView;
    
    // 总资产
    UILabel *totalFundTitleLabel;
    UILabel *totalFundValueLabel;
    
    // 累计收益
    UILabel *totalEarningsTitleLabel;
    UILabel *totalEarningsValueLabel;
    
    NSTimer* timer;
    
    NSString* todayEarningNumber;
    
}
//@synthesize viewGoodsListBtn = mViewGoodsListBtn;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundView = [[UIImageView alloc] initWithImage:nil];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundView.clipsToBounds = YES;
        
        // 今日收益
        dayEarningsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(frame), 13)];
        dayEarningsTitleLabel.font = [UIFont systemFontOfSize:11];
        dayEarningsTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        dayEarningsTitleLabel.text = @"昨日收益(元)";
        dayEarningsTitleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:dayEarningsTitleLabel];
        
        dayEarningsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dayEarningsTitleLabel.frame) + 8, CGRectGetWidth(dayEarningsTitleLabel.frame), 44)];
        
        dayEarningsValueLabel.text=@"财富积累从今天开始";
        dayEarningsValueLabel.font = [UIFont boldSystemFontOfSize:20];
        dayEarningsValueLabel.textColor = [UIColor whiteColor];
        dayEarningsValueLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:dayEarningsValueLabel];
        
        
        // 水平分割线
        UIImageView *horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        horizontalLine.frame = CGRectMake(10, CGRectGetMaxY(dayEarningsValueLabel.frame) + 20 + 13 + 8, CGRectGetWidth(frame) - 2 * 10, 1);
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
        totalFundValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, CGRectGetWidth(frame) / 2, 25)];
        totalFundValueLabel.font = [UIFont systemFontOfSize:17];
        totalFundValueLabel.textColor =[UIColor colorWithRed:87.0f/255.0f green:87.0f/255.0f blue:87.0f/255.0f alpha:1];
        totalFundValueLabel.textAlignment = NSTextAlignmentCenter;
        [totalItemContainerView addSubview:totalFundValueLabel];
        
        
        totalFundTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(totalFundValueLabel.frame), CGRectGetWidth(frame) / 2.0f, 13)];
        totalFundTitleLabel.text = @"累计收益(元)";
        
        totalFundTitleLabel.textColor =[UIColor colorWithRed:143.0f/255.0f green:143.0f/255.0f blue:143.0f/255.0f alpha:1];
        totalFundTitleLabel.textAlignment = NSTextAlignmentCenter;
        totalFundTitleLabel.font = [UIFont systemFontOfSize:11];
        [totalItemContainerView addSubview:totalFundTitleLabel];
        
        // vertical line
        UIImageView *verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(frame), 0,0.5, CGRectGetHeight(frame))];
        verticalLine.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
        [totalItemContainerView addSubview:verticalLine];
        
        // 总收益
        totalEarningsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(frame), CGRectGetMinY(totalFundValueLabel.frame), CGRectGetWidth(frame) / 2.0f, CGRectGetHeight(totalFundValueLabel.frame))];
        totalEarningsValueLabel.textAlignment = NSTextAlignmentCenter;
        totalEarningsValueLabel.font = [UIFont systemFontOfSize:17];
        totalEarningsValueLabel.textColor = [UIColor colorWithRed:87.0f/255.0f green:87.0f/255.0f blue:87.0f/255.0f alpha:1];
        [totalItemContainerView addSubview:totalEarningsValueLabel];
        
        totalEarningsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(frame), CGRectGetMinY(totalFundTitleLabel.frame)-5, CGRectGetWidth(totalEarningsValueLabel.frame), CGRectGetHeight(totalFundValueLabel.frame))];
        totalEarningsTitleLabel.text = QMLocalizedString(@"qm_account_balance_left_format", nil);
        totalEarningsTitleLabel.textAlignment = NSTextAlignmentCenter;
        totalEarningsTitleLabel.textColor = [UIColor colorWithRed:143.0f/255.0f green:143.0f/255.0f blue:143.0f/255.0f alpha:1];
        totalEarningsTitleLabel.font = [UIFont systemFontOfSize:11];
        [totalItemContainerView addSubview:totalEarningsTitleLabel];
        
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
    totalFundValueLabel.text = [CMMUtility formatterNumberWithComma:info.totalEarnings];
    
    // 账户余额
    totalEarningsValueLabel.text = [CMMUtility formatterNumberWithComma:info.totalAssets];
    
    // 今日收益
    
    if ([[CMMUtility formatterNumberWithComma:info.todayTotalEarnings] isEqualToString:@"0.00"]) {
        dayEarningsValueLabel.text = @"积累财富从今天开始";
        dayEarningsValueLabel.font = [UIFont boldSystemFontOfSize:20];
        dayEarningsValueLabel.textColor = [UIColor whiteColor];
        dayEarningsValueLabel.textAlignment = NSTextAlignmentCenter;

        [timer invalidate];
    }
      else
    {
        
        dayEarningsValueLabel.font = [UIFont boldSystemFontOfSize:42];
        NSLog(@"todayEarning=%@",info.todayTotalEarnings);
        
        [self startTimer:info.todayTotalEarnings];
    }

    
        
}
-(void)startTimer:(NSString*)string
{
    todayEarningNumber=[NSString stringWithString:string];
    timer=[NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
         [timer setFireDate:[NSDate date]];
}
-(void)timerAction
{
    float dayEarningValue=[todayEarningNumber floatValue];
    static float number=0.05;
    if (number>dayEarningValue) {
        [timer invalidate];
        dayEarningsValueLabel.text=[NSString stringWithFormat:@"%.2f",dayEarningValue];
        
    }else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.01];
        dayEarningsValueLabel.text=[NSString stringWithFormat:@"%.2f",number];
        [UIView commitAnimations];
        number=number+0.55;
    }

}
+ (CGFloat)getAbstractViewHeightForFundInfo:(QMMyFundModel *)info {
    return 210.0f;
}

@end
