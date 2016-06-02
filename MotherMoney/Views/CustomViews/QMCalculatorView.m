//
//  QMCalculatorView.m
//  MotherMoney
//

#import "QMCalculatorView.h"

@implementation QMCalculatorView {
    UIImageView *containerView;
    
    // close btn
    UIButton *closeBtn;
    
    // 理财金额
    UILabel *financeValueLabel;
    UITextField *financeValueField;
    
    // 计算结果
    UILabel *calculatorResultLabel;
    
    UIButton *calculateBtn;
    
    // 预期收益
    UILabel *expectedEarningTitleLabel;
    UILabel *expectedEarningValueLabel;
    
    // 银行收益
    UILabel *bankEarningTitleLabel;
    UILabel *bankEarningValueLabel;
 
    QMProductInfo *mProductInfo;
    UILabel *compareResultLabel;
    UILabel *subTitleLabel;
    
    CGFloat normalTopPadding;
}

- (id)initWithFrame:(CGRect)frame andProductInfo:(QMProductInfo *)info {
    self = [super initWithFrame:frame];
    if (self) {
        normalTopPadding = 90.0;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        
        mProductInfo = info;
        
        UIColor *itemTitleColor = [UIColor colorWithRed:90.0f / 255.0f green:90.0f / 255.0f blue:90.0f / 255.0f alpha:1.0f];
        UIColor *horizontalLineColor = [UIColor colorWithRed:229.0f / 255.0f green:229.0f / 255.0f blue:229.0f / 255.0f alpha:1.0f];
        
        // container view
        containerView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImage]];
        containerView.userInteractionEnabled = YES;
        containerView.frame = CGRectMake(20, CGRectGetHeight(frame), CGRectGetWidth(frame) - 2 * 20, 400.0f);
        [self addSubview:containerView];
        
        // close btn
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(CGRectGetWidth(containerView.frame) - 40.0f, 0, 40.0f, 40.0f);
        [closeBtn setImage:[UIImage imageNamed:@"delete_icon.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:closeBtn];
        
        // 标题
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(containerView.frame), 19)];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.font = [UIFont boldSystemFontOfSize:17];
        headerLabel.textColor = [UIColor blackColor];
        headerLabel.text = QMLocalizedString(@"qm_calculator_header_title", @"计算预期收益");
        [containerView addSubview:headerLabel];
        
        // 分割线
        UILabel *horizontalLine = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(headerLabel.frame) + 20, CGRectGetWidth(containerView.frame) - 2 * 20, 1)];
        horizontalLine.backgroundColor = horizontalLineColor;
        [containerView addSubview:horizontalLine];
        
        // 理财金额
        financeValueLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(horizontalLine.frame), CGRectGetMaxY(horizontalLine.frame), 100, 40.0f)];
        financeValueLabel.font = [UIFont systemFontOfSize:13];
        financeValueLabel.textColor = itemTitleColor;
        financeValueLabel.text = QMLocalizedString(@"qm_calculator_finance_value", @"理财金额(元)");
        
        financeValueField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(horizontalLine.frame) - 150, CGRectGetMinY(financeValueLabel.frame), 150, 40.0f)];
        financeValueField.textAlignment = NSTextAlignmentRight;
        financeValueField.textColor = QM_COMMON_TEXT_COLOR;
        financeValueField.font = [UIFont systemFontOfSize:18];
        financeValueField.autocorrectionType = UITextAutocorrectionTypeNo;
        financeValueField.keyboardType = UIKeyboardTypeNumberPad;
        [containerView addSubview:financeValueLabel];
        [containerView addSubview:financeValueField];
        
        // 分割线
        horizontalLine = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(horizontalLine.frame), CGRectGetMaxY(financeValueLabel.frame), CGRectGetWidth(horizontalLine.frame), 1)];
        horizontalLine.backgroundColor = horizontalLineColor;
        [containerView addSubview:horizontalLine];
        
        // 分割线
        horizontalLine = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(horizontalLine.frame), CGRectGetMaxY(financeValueLabel.frame), CGRectGetWidth(horizontalLine.frame), 1)];
        horizontalLine.backgroundColor = horizontalLineColor;
        [containerView addSubview:horizontalLine];
        
        // 计算按钮
        calculateBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(horizontalLine.frame), 40.0f) title:QMLocalizedString(@"qm_calculator_btn_title", @"计算") target:self selector:@selector(calculateBtnClicked:)];
        calculateBtn.frame = CGRectMake(CGRectGetMinX(horizontalLine.frame), CGRectGetMaxY(horizontalLine.frame) + 5, CGRectGetWidth(horizontalLine.frame), 40.0f);
        calculateBtn.enabled = NO;
        [containerView addSubview:calculateBtn];
        
        // 分割线
        horizontalLine = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(horizontalLine.frame), CGRectGetMaxY(calculateBtn.frame) + 15.0f, CGRectGetWidth(horizontalLine.frame), 1)];
        horizontalLine.backgroundColor = horizontalLineColor;
        [containerView addSubview:horizontalLine];
        
        // 预期收益
        expectedEarningTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(horizontalLine.frame), CGRectGetMaxY(horizontalLine.frame), 100, 40.0f)];
        expectedEarningTitleLabel.textColor = itemTitleColor;
        expectedEarningTitleLabel.text = QMLocalizedString(@"qm_expected_earning_title", @"预计活期收益");
        expectedEarningTitleLabel.font = [UIFont systemFontOfSize:13];
        [containerView addSubview:expectedEarningTitleLabel];
        
        expectedEarningValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(horizontalLine.frame) - 150.0f, CGRectGetMaxY(horizontalLine.frame), 150.0f, 40.0f)];
        expectedEarningValueLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        expectedEarningValueLabel.textColor = QM_COMMON_TEXT_COLOR;
        [containerView addSubview:expectedEarningValueLabel];
        
        // 分割线
        horizontalLine = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(horizontalLine.frame), CGRectGetMaxY(expectedEarningTitleLabel.frame), CGRectGetWidth(horizontalLine.frame), 1)];
        horizontalLine.backgroundColor = horizontalLineColor;
        [containerView addSubview:horizontalLine];
        
        // 银行收益
        bankEarningTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(horizontalLine.frame), CGRectGetMaxY(horizontalLine.frame), 100, 40.0f)];
        bankEarningTitleLabel.textColor = itemTitleColor;
        bankEarningTitleLabel.font = [UIFont systemFontOfSize:13];
        bankEarningTitleLabel.text = QMLocalizedString(@"qm_bank_earning_title", @"银行活期收益");
        [containerView addSubview:bankEarningTitleLabel];
        
        bankEarningValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(horizontalLine.frame) - 150.0f, CGRectGetMaxY(horizontalLine.frame), 150.0f, 40.0f)];
        bankEarningValueLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        bankEarningValueLabel.textColor = QM_COMMON_TEXT_COLOR;
        [containerView addSubview:bankEarningValueLabel];
        
        // 分割线
        horizontalLine = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(bankEarningTitleLabel.frame), CGRectGetMaxY(bankEarningTitleLabel.frame), CGRectGetWidth(horizontalLine.frame), 1)];
        horizontalLine.backgroundColor = horizontalLineColor;
        [containerView addSubview:horizontalLine];
        
        //
        compareResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(horizontalLine.frame), CGRectGetMaxY(horizontalLine.frame) + 20, CGRectGetWidth(horizontalLine.frame), 15.0f)];
        compareResultLabel.textAlignment = NSTextAlignmentCenter;
        compareResultLabel.font = [UIFont systemFontOfSize:13.0f];
        compareResultLabel.textColor = QM_COMMON_TEXT_COLOR;
        [containerView addSubview:compareResultLabel];
        
        subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(horizontalLine.frame), CGRectGetMaxY(compareResultLabel.frame) + 10, CGRectGetWidth(horizontalLine.frame), 12.0f)];
        subTitleLabel.font = [UIFont systemFontOfSize:10.0f];
        subTitleLabel.textColor = itemTitleColor;
        subTitleLabel.text = QMLocalizedString(@"qm_expect_bank_compare_sub_title", @"此收益结果仅供参考，不代表实际收益");
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [containerView addSubview:subTitleLabel];
        
        // register notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)handleTextDidChangeNotification:(NSNotification *)noti {
    NSString *money = [[financeValueField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (QM_IS_STR_NIL(money)) {
        calculateBtn.enabled = NO;
    }else {
        calculateBtn.enabled = YES;
    }
}

- (CGFloat)calculateResultWithRate:(CGFloat)rate money:(CGFloat)money date:(NSInteger)date {
    return money * (pow(1 + rate, date) - 1);
}

- (void)calculateBtnClicked:(UIButton *)btn {
    [self hideKeyboard];
    
    // 填写计算结果
    NSString *money = [[financeValueField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSInteger intMoney = [money integerValue];
    
    if ([mProductInfo.productChannelId isEqualToString:QM_DEFAULT_CHANNEL_ID]) { // 从服务器计算
//        getProductCountInterestWithProductId
        [[NetServiceManager sharedInstance] getProductCountInterestWithProductId:mProductInfo.product_id amount:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:intMoney]] delegate:self success:^(id responseObject) {
            NSLog(@"response:%@", responseObject);
            double bankInterest = [[responseObject objectForKey:@"bankInterest"] doubleValue];
            double productInterest = [[responseObject objectForKey:@"productInterest"] doubleValue];
            
            bankEarningValueLabel.text = [NSString stringWithFormat:@"%.2f", bankInterest];
            expectedEarningValueLabel.text = [NSString stringWithFormat:@"%.2f", productInterest];

            if (productInterest != 0 && bankInterest != 0) {
                compareResultLabel.text = [NSString stringWithFormat:QMLocalizedString(@"qm_expect_bank_compare_title", @"产品预期收益是银行活期收益的%.2f倍"), productInterest / bankInterest];
            }

        } failure:^(NSError *error) {
            [CMMUtility showNoteWithError:error];
        }];
    }else {
        NSInteger intDate = mProductInfo.maturityDurationValue;
        
        CGFloat rate = [mProductInfo expectedRateForCalculator];
        if (rate <= 0) {
            rate = 0.12;
        }
        CGFloat bankEarning = [self calculateResultWithRate:(0.0035 / 365) money:intMoney date:intDate];
        CGFloat myEarning = [self calculateResultWithRate: rate / 365 money:intMoney date:intDate];
        
        expectedEarningValueLabel.text = [NSString stringWithFormat:@"%.2f", myEarning];
        bankEarningValueLabel.text = [NSString stringWithFormat:@"%.2f", bankEarning];
        
        if (myEarning != 0) {
            compareResultLabel.text = [NSString stringWithFormat:QMLocalizedString(@"qm_expect_bank_compare_title", @"产品预期收益是银行活期收益的%.2f倍"), myEarning / bankEarning];
        }
    }
}

#pragma mark -
#pragma mark Action
- (void)closeBtnClicked:(UIButton *)btn {
    [self hide];
}

- (void)hideKeyboard {
    [financeValueField resignFirstResponder];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    CGPoint location = [tap locationInView:self];
    
    CGRect financeValueLabelRectInView = [financeValueLabel convertRect:financeValueLabel.bounds toView:self];
    
    if (CGRectContainsPoint(financeValueLabelRectInView, location)) {
        [financeValueField becomeFirstResponder];
    }else {
        [self hideKeyboard];
    }
}

- (void)handleKeyboardWillShowNotification:(NSNotification *)noti {
    CGRect endRect = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect calculateBtnFrame = [calculateBtn convertRect:calculateBtn.bounds toView:self];
    if (CGRectGetMaxY(calculateBtnFrame) < (CGRectGetMinY(endRect) - 10)) {
        // 不需要修改frame
    }else {
        // 需要修改frame
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = containerView.frame;
            frame.origin.y = normalTopPadding - (CGRectGetMaxY(calculateBtnFrame) - CGRectGetMinY(endRect)) - 10.0f;
            containerView.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)noti {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = containerView.frame;
        frame.origin.y = normalTopPadding;
        containerView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    CGRect frame = containerView.frame;
    
    [UIView animateWithDuration:0.3f animations:^{
        containerView.frame = CGRectMake(CGRectGetMinX(frame), normalTopPadding, CGRectGetWidth(frame), CGRectGetHeight(frame));
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    CGRect frame = containerView.frame;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [UIView animateWithDuration:0.3f animations:^{
        containerView.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetHeight(keyWindow.frame), CGRectGetWidth(frame), CGRectGetHeight(frame));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

@end
