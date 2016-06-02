//
//  QMProductBuyResultViewController.m
//  MotherMoney

#import "QMProductBuyResultViewController.h"
#import "MyFundViewController.h"

@interface QMProductBuyResultViewController ()

@end

@implementation QMProductBuyResultViewController {
    UIImageView *containerView;
    QMOrderModel *mOrderModel;
    NSError *mError;
}

- (id)initViewControllerWithOrder:(QMOrderModel *)order
                           result:(NSError *)error {
    if (self = [super init]) {
        mOrderModel = order;
        mError = error;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews {
    containerView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImage]];
    containerView.frame = CGRectMake(8, 8, CGRectGetWidth(self.view.frame) - 2 * 8, 100);
    [self.view addSubview:containerView];
    
    if (nil == mError) {
        [self setUpSuccessSubViews];
    }else {
        [self setUpFailureSubViews];
    }

    // 确认按钮
    UIButton *confirmBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 2 * 20, 40) title:QMLocalizedString(@"qm_confirm_btn_title", @"确认") target:self selector:@selector(confirmBtnClicked:)];
    confirmBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    CGRect frame = confirmBtn.frame;
    frame.origin = CGPointMake(20, CGRectGetHeight(self.view.frame) - 10 - 40);
    confirmBtn.frame = frame;
    [self.view addSubview:confirmBtn];
}

- (void)confirmBtnClicked:(UIButton *)btn {
    if (nil != self.navigationController.presentingViewController) {
        // present 出来的
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
                            

- (void)setUpSuccessSubViews {
    // 购买结果
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 16, 16)];
    iconImageView.image = [UIImage imageNamed:@"real_name_authentication.png"];
    [containerView addSubview:iconImageView];
    
    UILabel *productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(iconImageView.frame), CGRectGetMaxY(iconImageView.frame) + 8, CGRectGetWidth(containerView.frame) - 2 * 15, 13)];
    productNameLabel.font = [UIFont systemFontOfSize:11];
    productNameLabel.textColor = [UIColor colorWithRed:0x33 / 255.0f green:0x33 / 255.0f blue:0x33 / 255.0f alpha:1.0f];
    productNameLabel.text = [NSString stringWithFormat:QMLocalizedString(@"qm_product_buy_success_text", @"成功下单%@"), mOrderModel.productName];
    [containerView addSubview:productNameLabel];
    
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(productNameLabel.frame), CGRectGetMaxY(productNameLabel.frame) + 2, 200, 18)];
    amountLabel.font = [UIFont systemFontOfSize:16];
    amountLabel.textColor = [UIColor colorWithRed:0xdd / 255.0f green:0x2e / 255.0f blue:0x1c / 255.0f alpha:1.0f];
    //购买金额
    amountLabel.text = [NSString stringWithFormat:@"%@元", mOrderModel.amount];
    [containerView addSubview:amountLabel];
    
    NSString *resultStr = QMLocalizedString(@"qm_product_buy_success_detail", @"交易已提交，稍等10秒，此笔资金可以在稳盈货贷资产列表中查看");
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10], NSFontAttributeName, nil];
    CGSize size = [resultStr boundingRectWithSize:CGSizeMake(CGRectGetWidth(containerView.frame) - 2 * 15, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(amountLabel.frame), CGRectGetMaxY(amountLabel.frame) + 6, size.width, size.height)];
    resultLabel.font = [UIFont systemFontOfSize:10];
    resultLabel.textColor = [UIColor colorWithRed:0x99 / 255.0f green:0x99 / 255.0f blue:0x99 / 255.0f alpha:1.0f];
    resultLabel.numberOfLines = 2;
    resultLabel.text = resultStr;
    [containerView addSubview:resultLabel];
    
    UIImageView *horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
    horizontalLine.frame = CGRectMake(CGRectGetMinX(resultLabel.frame), CGRectGetMaxY(resultLabel.frame) + 12, CGRectGetWidth(containerView.frame) - 2 * 15, 1);
    [containerView addSubview:horizontalLine];
    
    
    // 计算收益
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(horizontalLine.frame), CGRectGetMaxY(horizontalLine.frame) + 12, 16, 16)];
    iconImageView.image = [UIImage imageNamed:@"income_calculation.png"];
    [containerView addSubview:iconImageView];
    
    UILabel *calculateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(iconImageView.frame), CGRectGetMaxY(iconImageView.frame) + 8, CGRectGetWidth(containerView.frame) - 2 * 15, 13)];
    calculateLabel.font = [UIFont systemFontOfSize:11];
    calculateLabel.textColor = [UIColor colorWithRed:0x33 / 255.0f green:0x33 / 255.0f blue:0x33 / 255.0f alpha:1.0f];
    calculateLabel.text = QMLocalizedString(@"qm_product_begin_earning", @"开始计算收益");
    [containerView addSubview:calculateLabel];
    
    
    resultStr = QMLocalizedString(@"qm_product_begin_earning_detail", @"募集成功后次日开始计算收益，以实际情况为准");
    dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10], NSFontAttributeName, nil];
    size = [resultStr boundingRectWithSize:CGSizeMake(CGRectGetWidth(containerView.frame) - 2 * 15, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(calculateLabel.frame), CGRectGetMaxY(calculateLabel.frame) + 6, size.width, size.height)];
    resultLabel.font = [UIFont systemFontOfSize:10];
    resultLabel.textColor = [UIColor colorWithRed:0x99 / 255.0f green:0x99 / 255.0f blue:0x99 / 255.0f alpha:1.0f];
    resultLabel.text = resultStr;
    [containerView addSubview:resultLabel];
    
    horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
    horizontalLine.frame = CGRectMake(CGRectGetMinX(resultLabel.frame), CGRectGetMaxY(resultLabel.frame) + 12, CGRectGetWidth(containerView.frame) - 2 * 15, 1);
    [containerView addSubview:horizontalLine];
    
    // 查看收益
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(horizontalLine.frame), CGRectGetMaxY(horizontalLine.frame) + 12, 16, 16)];
    iconImageView.image = [UIImage imageNamed:@"income_see.png"];
    [containerView addSubview:iconImageView];
    
    UILabel *viewEarningLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(iconImageView.frame), CGRectGetMaxY(iconImageView.frame) + 8, CGRectGetWidth(containerView.frame) - 2 * 15, 13)];
    viewEarningLabel.font = [UIFont systemFontOfSize:11];
    viewEarningLabel.textColor = [UIColor colorWithRed:0x33 / 255.0f green:0x33 / 255.0f blue:0x33 / 255.0f alpha:1.0f];
    viewEarningLabel.text = QMLocalizedString(@"qm_product_view_earning", @"查看收益");
    [containerView addSubview:viewEarningLabel];
    
    
    resultStr = QMLocalizedString(@"qm_product_view_earning_detail", @"计算收益日次日可以查看收益，以实际情况为准");
    dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10], NSFontAttributeName, nil];
    size = [resultStr boundingRectWithSize:CGSizeMake(CGRectGetWidth(containerView.frame) - 2 * 15, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(viewEarningLabel.frame), CGRectGetMaxY(viewEarningLabel.frame) + 6, size.width, size.height)];
    resultLabel.font = [UIFont systemFontOfSize:10];
    resultLabel.textColor = [UIColor colorWithRed:0x99 / 255.0f green:0x99 / 255.0f blue:0x99 / 255.0f alpha:1.0f];
    resultLabel.text = resultStr;
    [containerView addSubview:resultLabel];
    
    containerView.frame = CGRectMake(8, 8, CGRectGetWidth(self.view.frame) - 2 * 8, CGRectGetMaxY(resultLabel.frame) + 12);
}

- (void)setUpFailureSubViews {
    // icon
    UIImageView *errorIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buy_failed.png"]];
    errorIconImageView.frame = CGRectMake((CGRectGetWidth(containerView.frame) - 35) / 2.0f, 35, 35, 35);
    [containerView addSubview:errorIconImageView];
    
    // product name
    UILabel *productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(errorIconImageView.frame) + 12, CGRectGetWidth(containerView.frame), 13)];
    productNameLabel.font = [UIFont systemFontOfSize:11];
    productNameLabel.textColor = [UIColor colorWithRed:0x33 / 255.0f green:0x33 / 255.0f blue:0x33 / 255.0f alpha:1.0f];
    productNameLabel.textAlignment = NSTextAlignmentCenter;
    productNameLabel.text = [NSString stringWithFormat:QMLocalizedString(@"qm_product_buy_error_text", @"下单%@失败"), mOrderModel.productName];
    [containerView addSubview:productNameLabel];
    
    // horizontal line
    UIImageView *horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
    horizontalLine.frame = CGRectMake(15, CGRectGetMaxY(productNameLabel.frame) + 35, CGRectGetWidth(containerView.frame) - 2 * 15, 1);
    [containerView addSubview:horizontalLine];
    
    // error message
    UILabel *errMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(horizontalLine.frame), CGRectGetWidth(containerView.frame), 40.0f)];
    errMsgLabel.font = [UIFont systemFontOfSize:11];
    errMsgLabel.textColor = [UIColor colorWithRed:0x99 / 255.0f green:0x99 / 255.0f blue:0x99 / 255.0f alpha:1.0f];
    errMsgLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *errorMessage = [[mError userInfo] objectForKey:kNetWorErrorMsg];
    if ([CMMUtility isStringOk:errorMessage]) {
        errMsgLabel.text = errorMessage;
    }else {
        errMsgLabel.text = QMLocalizedString(@"qm_network_error_message", @"请检查网络原因");
    }
    
    [containerView addSubview:errMsgLabel];
    
    containerView.frame = CGRectMake(8, 8, CGRectGetWidth(self.view.frame) - 2 * 8, CGRectGetMaxY(errMsgLabel.frame));
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    if (nil == mError) {
        return QMLocalizedString(@"qm_product_buy_success_nav_title", @"购买下单成功");
    }else {
        return QMLocalizedString(@"qm_product_buy_failure_nav_title", @"购买下单失败");
    }
}

@end
