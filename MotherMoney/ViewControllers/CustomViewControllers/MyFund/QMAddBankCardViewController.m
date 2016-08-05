//
//  QMAddBankCardViewController.m
//  MotherMoney
//

#import "QMAddBankCardViewController.h"
#import "QMSelectLocationViewController.h"
#import "QMConfirmBuyProductViewController.h"
#import "QMAddBankViewController.h"
#import "QMBankInfo.h"
#import "QMNumberFormatPromptView.h"
#import "QMSelectLocationViewControllerV2.h"

@interface QMAddBankCardViewController () <UITextFieldDelegate, QMSelectItemViewControllerDelegate>

@end

@implementation QMAddBankCardViewController {
    UILabel *promptLabel;
    
    UIButton *selectBankBtn; // 选择银行
    UITextField *bankCardIdField; // 输入银行卡
    
    UIButton *selectProvinceBtn;
    UIButton *selectCityBtn;
    UITextField *reseveredPhoneField;
    
    UITextField *bankDetailInfoField;
    
    UIButton *nextStepBtn;
    
    NSArray *locationInfo;
    
    NSInteger provinceIndex;
    NSInteger cityIndex;
    
    QMOrderModel *mOrderModel;
    
    QMBankInfo *currentBankInfo;
    
    UIScrollView *containerView;
    
    QMNumberFormatPromptView *bankCardIdPromptView;
    QMNumberFormatPromptView *phoneNumberPromptView;
    
    QMSearchItem *provinceItem;
    QMSearchItem *cityitem;
}

- (id)initViewControllerWithOrder:(QMOrderModel *)model {
    if (self = [super init]) {
        mOrderModel = model;
    }
    
    return self;
}

- (UIBarButtonItem *)leftBarButtonItem {
    return [QMNavigationBarItemFactory createNavigationBackItemWithTarget:self selector:@selector(goBack)];
}

- (void)goBack {
    if (self.isModel) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self initDataSource];
    [self setUpSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)handleTextDidChangeNotification:(NSNotification *)noti {
    [self updateNextBtnState];
    
    NSObject *object = noti.object;
    if (object == bankCardIdField) {
        NSString *string = bankCardIdField.text;
        [bankCardIdPromptView updateWithText:[QMStringUtil formattedBankCardIdFromCardId:string]];
    }else if(object == reseveredPhoneField) {
        NSString *string = reseveredPhoneField.text;
        [phoneNumberPromptView updateWithText:[QMStringUtil formattedPhoneNumberFromPhoneNumber:string]];
    }
    
    BOOL bankPreviousHidden = bankCardIdPromptView.hidden;
    BOOL phonePreviousHidden = phoneNumberPromptView.hidden;
    
    BOOL bankNowHidden = QM_IS_STR_NIL(bankCardIdField.text) || !(bankCardIdField.isFirstResponder);
    BOOL phoneNowHidden = QM_IS_STR_NIL(reseveredPhoneField.text) || !(reseveredPhoneField.isFirstResponder);
    
    bankCardIdPromptView.hidden = bankNowHidden;
    phoneNumberPromptView.hidden = phoneNowHidden;
    
    if (bankPreviousHidden != bankNowHidden || phoneNowHidden != phonePreviousHidden) {
        bankCardIdPromptView.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame), CGRectGetWidth(bankCardIdField.frame), 40.0f);
        phoneNumberPromptView.frame = CGRectMake(CGRectGetMinX(reseveredPhoneField.frame), CGRectGetMaxY(reseveredPhoneField.frame), CGRectGetWidth(reseveredPhoneField.frame), 40.0f);
        
        [self updateSubViewsFrameAnimated:YES];
    }else {
        [self updateSubViewsFrameAnimated:NO];
    }
}

- (void)updateFrames {
    if (NO == bankCardIdPromptView.hidden || NO == phoneNumberPromptView.hidden) {
        if (bankCardIdPromptView.hidden == NO) {
            bankCardIdPromptView.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame), CGRectGetWidth(bankCardIdField.frame), 40.0f);
            
            // 预留手机号
            reseveredPhoneField.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdPromptView.frame) + 10, CGRectGetWidth(bankCardIdField.frame), CGRectGetHeight(bankCardIdField.frame));
        }else {
            reseveredPhoneField.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame) + 10, CGRectGetWidth(bankCardIdField.frame), CGRectGetHeight(bankCardIdField.frame));
        }
        
        if (NO == phoneNumberPromptView.hidden) {
            phoneNumberPromptView.frame = CGRectMake(CGRectGetMinX(reseveredPhoneField.frame), CGRectGetMaxY(reseveredPhoneField.frame), CGRectGetWidth(reseveredPhoneField.frame), 40.0f);
            
            // 选择省市
            selectProvinceBtn.frame = CGRectMake(CGRectGetMinX(reseveredPhoneField.frame), CGRectGetMaxY(phoneNumberPromptView.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
        }else {
            // 选择省市
            selectProvinceBtn.frame = CGRectMake(CGRectGetMinX(reseveredPhoneField.frame), CGRectGetMaxY(reseveredPhoneField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
        }
        
        selectCityBtn.frame = CGRectMake(CGRectGetMinX(selectProvinceBtn.frame), CGRectGetMaxY(selectProvinceBtn.frame), CGRectGetWidth(selectProvinceBtn.frame), CGRectGetHeight(selectProvinceBtn.frame));
        
        // 支行信息
        bankDetailInfoField.frame = CGRectMake(CGRectGetMinX(selectCityBtn.frame), CGRectGetMaxY(selectCityBtn.frame) + 10, CGRectGetWidth(bankCardIdField.frame), CGRectGetHeight(bankCardIdField.frame));
        
        // 绑定
        CGRect frame = nextStepBtn.frame;
        frame.origin = CGPointMake(CGRectGetMinX(bankDetailInfoField.frame), CGRectGetMaxY(bankDetailInfoField.frame) + 20);
        nextStepBtn.frame = frame;
    }else {
        // 预留手机号
        reseveredPhoneField.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame) + 10, CGRectGetWidth(bankCardIdField.frame), CGRectGetHeight(bankCardIdField.frame));
        
        // 选择省市
        selectProvinceBtn.frame = CGRectMake(CGRectGetMinX(reseveredPhoneField.frame), CGRectGetMaxY(reseveredPhoneField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
        selectCityBtn.frame = CGRectMake(CGRectGetMinX(selectProvinceBtn.frame), CGRectGetMaxY(selectProvinceBtn.frame), CGRectGetWidth(selectProvinceBtn.frame), CGRectGetHeight(selectProvinceBtn.frame));
        
        // 支行信息
        bankDetailInfoField.frame = CGRectMake(CGRectGetMinX(selectCityBtn.frame), CGRectGetMaxY(selectCityBtn.frame) + 10, CGRectGetWidth(bankCardIdField.frame), CGRectGetHeight(bankCardIdField.frame));
        
        // 绑定
        CGRect frame = nextStepBtn.frame;
        frame.origin = CGPointMake(CGRectGetMinX(bankDetailInfoField.frame), CGRectGetMaxY(bankDetailInfoField.frame) + 20);
        nextStepBtn.frame = frame;
    }
}

- (void)updateSubViewsFrameAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            [self updateFrames];
        } completion:^(BOOL finished) {
            
        }];
    }else {
        [self updateFrames];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)updateNextBtnState {
    if (!QM_IS_STR_NIL(currentBankInfo.bankCode) &&
        !QM_IS_STR_NIL([self getBankCardNumber]) &&
        !QM_IS_STR_NIL([self getPhoneNumber]) &&
        !QM_IS_STR_NIL([self getProvinceString]) &&
        !QM_IS_STR_NIL([self getCityString]) &&
        !QM_IS_STR_NIL([self getBankLocationString])) {
        nextStepBtn.enabled = YES;
    }else {
        nextStepBtn.enabled = NO;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (QM_IS_STR_NIL(currentBankInfo.bankCode) && textField == bankCardIdField) {
        // 没有选择银行
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:QMLocalizedString(@"qm_add_bankcard_no_bank_alert_message", @"请先选择银行")
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:QMLocalizedString(@"qm_alertview_ok_title", @"确定"), nil];
        [alert show];
        
        return NO;
    }
    
    return YES;
}

// did begin editing
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == bankCardIdField) {
        if (!QM_IS_STR_NIL(textField.text)) {
            bankCardIdPromptView.hidden = NO;
        }
    }else if (textField == reseveredPhoneField) {
        if (!QM_IS_STR_NIL(textField.text)) {
            phoneNumberPromptView.hidden = NO;
        }
    }
    
    [self updateSubViewsFrameAnimated:YES];
}

// did end editing
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == bankCardIdField) {
        bankCardIdPromptView.hidden = YES;
    }else if (textField == reseveredPhoneField) {
        phoneNumberPromptView.hidden = YES;
    }
    
    [self updateSubViewsFrameAnimated:YES];
}

- (void)initDataSource {
    provinceIndex = 0;
    cityIndex = 0;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    locationInfo = [[NSArray alloc] initWithContentsOfFile:filePath];
}

- (void)setUpSubViews {
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    containerView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    containerView.alwaysBounceVertical = YES;
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:containerView];
    
    promptLabel  = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, CGRectGetWidth(self.view.frame) - 2 * 20, 13)];
    promptLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
    promptLabel.font = [UIFont systemFontOfSize:11];
    promptLabel.text = QMLocalizedString(@"qm_add_bankcard_prompt_text", @"确认银行卡信息，如需修改请直接编辑");
    [containerView addSubview:promptLabel];
    
    selectBankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBankBtn.frame = CGRectMake(CGRectGetMinX(promptLabel.frame), CGRectGetMaxY(promptLabel.frame) + 10, CGRectGetWidth(promptLabel.frame), 44);
    [selectBankBtn setBackgroundImage:[QMImageFactory commonTextFieldImageTopPart] forState:UIControlStateNormal];
    [selectBankBtn setBackgroundImage:[QMImageFactory commonTextFieldImageTopPart] forState:UIControlStateHighlighted];
    [selectBankBtn setImage:[UIImage imageNamed:@"shearhead.png"] forState:UIControlStateNormal];
    selectBankBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectBankBtn setTitleColor:QM_COMMON_TEXT_COLOR forState:UIControlStateNormal];
    
    selectBankBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    selectBankBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [selectBankBtn addTarget:self action:@selector(selectBankBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    selectBankBtn.imageEdgeInsets = UIEdgeInsetsMake(0, CGRectGetWidth(selectBankBtn.frame) - 30, 0, 0);
    [containerView addSubview:selectBankBtn];
    
    bankCardIdField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(selectBankBtn.frame), CGRectGetMaxY(selectBankBtn.frame), CGRectGetWidth(selectBankBtn.frame), CGRectGetHeight(selectBankBtn.frame))];
    bankCardIdField.delegate = self;
    bankCardIdField.keyboardType = UIKeyboardTypeNumberPad;
    bankCardIdField.textColor = QM_COMMON_TEXT_COLOR;
    [bankCardIdField setBackground:[QMImageFactory commonTextFieldImageBottomPart]];
    bankCardIdField.font = [UIFont systemFontOfSize:13];
    bankCardIdField.placeholder = QMLocalizedString(@"qm_add_bankcard_selectbank_id_text", @"请输入您的银行卡");
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(bankCardIdField.frame))];
    bankCardIdField.leftView = leftView;
    bankCardIdField.leftViewMode = UITextFieldViewModeAlways;
    [containerView addSubview:bankCardIdField];
    
    bankCardIdPromptView = [[QMNumberFormatPromptView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bankCardIdField.frame), 40.0f)];
    bankCardIdPromptView.hidden = YES;
    [containerView addSubview:bankCardIdPromptView];
    
    reseveredPhoneField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame) + 10, CGRectGetWidth(bankCardIdField.frame), CGRectGetHeight(bankCardIdField.frame))];
    reseveredPhoneField.delegate = self;
    reseveredPhoneField.keyboardType = UIKeyboardTypeNumberPad;
    reseveredPhoneField.textColor = QM_COMMON_TEXT_COLOR;
    [reseveredPhoneField setBackground:[QMImageFactory commonTextFieldImage]];
    reseveredPhoneField.font = [UIFont systemFontOfSize:13];
    reseveredPhoneField.placeholder = QMLocalizedString(@"qm_input_resevered_phone_number_text", @"请输入预留手机号码");
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(bankCardIdField.frame))];
    reseveredPhoneField.leftView = leftView;
    reseveredPhoneField.leftViewMode = UITextFieldViewModeAlways;
    [containerView addSubview:reseveredPhoneField];
    
    phoneNumberPromptView = [[QMNumberFormatPromptView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(reseveredPhoneField.frame), 40.0f)];
    phoneNumberPromptView.hidden = YES;
    [containerView addSubview:phoneNumberPromptView];
    
    selectProvinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectProvinceBtn setImage:[UIImage imageNamed:@"shearhead.png"] forState:UIControlStateNormal];
    [selectProvinceBtn setBackgroundImage:[QMImageFactory commonTextFieldImageTopPart] forState:UIControlStateNormal];
    [selectProvinceBtn setBackgroundImage:[QMImageFactory commonTextFieldImageTopPart] forState:UIControlStateHighlighted];
    selectProvinceBtn.frame = CGRectMake(CGRectGetMinX(reseveredPhoneField.frame), CGRectGetMaxY(reseveredPhoneField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
    selectProvinceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectProvinceBtn setTitleColor:QM_COMMON_TEXT_COLOR forState:UIControlStateNormal];
    selectProvinceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    selectProvinceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    selectProvinceBtn.imageEdgeInsets = UIEdgeInsetsMake(0, CGRectGetWidth(selectProvinceBtn.frame) - 30, 0, 0);
    [selectProvinceBtn addTarget:self action:@selector(selectProvinceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:selectProvinceBtn];
    
    selectCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectCityBtn setBackgroundImage:[QMImageFactory commonTextFieldImageBottomPart] forState:UIControlStateNormal];
    [selectCityBtn setBackgroundImage:[QMImageFactory commonTextFieldImageBottomPart] forState:UIControlStateHighlighted];
    selectCityBtn.frame = CGRectMake(CGRectGetMinX(selectProvinceBtn.frame), CGRectGetMaxY(selectProvinceBtn.frame), CGRectGetWidth(selectProvinceBtn.frame), CGRectGetHeight(selectProvinceBtn.frame));
    [selectCityBtn setImage:[UIImage imageNamed:@"shearhead.png"] forState:UIControlStateNormal];
    selectCityBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectCityBtn setTitleColor:QM_COMMON_TEXT_COLOR forState:UIControlStateNormal];
    
    selectCityBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    selectCityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    selectCityBtn.imageEdgeInsets = UIEdgeInsetsMake(0, CGRectGetWidth(selectProvinceBtn.frame) - 30, 0, 0);
    [selectCityBtn addTarget:self action:@selector(selectCityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:selectCityBtn];
    
    
    bankDetailInfoField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(selectCityBtn.frame), CGRectGetMaxY(selectCityBtn.frame) + 10, CGRectGetWidth(bankCardIdField.frame), CGRectGetHeight(bankCardIdField.frame))];
    bankDetailInfoField.textColor = QM_COMMON_TEXT_COLOR;
    [bankDetailInfoField setBackground:[QMImageFactory commonTextFieldImage]];
    bankDetailInfoField.font = [UIFont systemFontOfSize:13];
    bankDetailInfoField.placeholder = QMLocalizedString(@"qm_input_bank_detail_info_text", @"请输入支行信息");
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(bankCardIdField.frame))];
    bankDetailInfoField.leftView = leftView;
    bankDetailInfoField.leftViewMode = UITextFieldViewModeAlways;
    [containerView addSubview:bankDetailInfoField];
    
    // 下一步
    nextStepBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(bankDetailInfoField.frame), CGRectGetHeight(bankDetailInfoField.frame)) title:QMLocalizedString(@"qm_add_bankcard_btn_tite", @"绑定") target:self selector:@selector(nextStepBtnClicked:)];
    CGRect frame = nextStepBtn.frame;
    frame.origin = CGPointMake(CGRectGetMinX(bankDetailInfoField.frame), CGRectGetMaxY(bankDetailInfoField.frame) + 20);
    nextStepBtn.frame = frame;
    [containerView addSubview:nextStepBtn];
    
    [self updateNextBtnState];
    [self updateBtnTitles];
}

- (void)updateBtnTitles {
    [selectBankBtn setTitle:QMLocalizedString(@"qm_add_bankcard_selectbank_text", @"请选择银行") forState:UIControlStateNormal];
    if (provinceIndex < [locationInfo count]) {
        NSDictionary *dict = [locationInfo objectAtIndex:provinceIndex];
        NSString *province = [dict objectForKey:@"state"];
        [selectProvinceBtn setTitle:province forState:UIControlStateNormal];
        
        NSArray *cities = [dict objectForKey:@"cities"];
        if (cityIndex < [cities count]) {
            NSString *cityName = [cities objectAtIndex:cityIndex];
            [selectCityBtn setTitle:cityName forState:UIControlStateNormal];
        }
    }
}

- (void)registerKeyBoardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unRegisterKeyBoardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)handleKeyboardWillShowNotification:(NSNotification *)noti {
    CGRect endRect = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(endRect));
    containerView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)noti {
    containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    containerView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self registerKeyBoardNotification];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self unRegisterKeyBoardNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 选择银行
- (void)selectBankBtnClicked:(UIButton *)btn {
    QMAddBankViewController *con = [[QMAddBankViewController alloc] initViewControllerWithProduct:mOrderModel];
    con.delegate = self;
    con.isModel = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

// 选择省份
- (void)selectProvinceBtnClicked:(UIButton *)btn {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (NSString *state in [locationInfo valueForKey:@"state"]) {
        QMSearchItem *item = [[QMSearchItem alloc] initWithTitle:state subTitle:nil];
        [array addObject:item];
    }
    QMSelectLocationViewController *con = [[QMSelectLocationViewController alloc] initViewControllerWithItems:array type:QMSelectLocationType_Province];
    con.isModel = YES;
    con.delegate = self;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

// 选择城市
- (void)selectCityBtnClicked:(UIButton *)btn {
    NSString *state = [selectProvinceBtn titleForState:UIControlStateNormal];
    NSDictionary *stateInfo = nil;
    if (!QM_IS_STR_NIL(state)) {
        for (NSDictionary *dict in locationInfo) {
            if ([[dict objectForKey:@"state"] isEqualToString:state]) {
                stateInfo = dict;
                break;
            }
        }
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (nil != stateInfo) {
        for (NSString *city in [stateInfo objectForKey:@"cities"]) {
            QMSearchItem *item = [[QMSearchItem alloc] initWithTitle:city subTitle:nil];
            [array addObject:item];
        }
    }
    
    QMSelectLocationViewController *con = [[QMSelectLocationViewController alloc] initViewControllerWithItems:array type:QMSelectLocationType_City];
    con.isModel = YES;
    con.delegate = self;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

- (NSString *)getBankCardNumber {
    return [bankCardIdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)getPhoneNumber {
    return [reseveredPhoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)getProvinceString {
    return [[selectProvinceBtn titleForState:UIControlStateNormal] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)getCityString {
    return [[selectCityBtn titleForState:UIControlStateNormal] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

// 支行信息
- (NSString *)getBankLocationString {
    return [bankDetailInfoField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

// 绑定
- (void)nextStepBtnClicked:(UIButton *)btn {
    // 打点
    btn.enabled = NO;
    [QMUMTookKitManager event:USER_SUBMIT_BINDCARD_KEY label:@"用户提交绑卡"];
    
    NSString *bankId = currentBankInfo.bankCardId;
    NSString *bankCardNumber = [self getBankCardNumber];
    NSString *bankCardProvince = [self getProvinceString];
    NSString *bankCardCity = [self getCityString];
    NSString *bankBranchName = [self getBankLocationString];
    NSString *reservePhoneNumber = [self getPhoneNumber];
    NSString *productChannelId = mOrderModel.productChannelId;
    
    if (QM_IS_STR_NIL(bankId)
        || QM_IS_STR_NIL(bankCardNumber)
        || QM_IS_STR_NIL(bankCardProvince)
        || QM_IS_STR_NIL(bankCardCity)
        || QM_IS_STR_NIL(bankBranchName)
        || QM_IS_STR_NIL(reservePhoneNumber)
        || QM_IS_STR_NIL(productChannelId)) {
        
        return;
    }
    
   // 执行绑定操作
    [[NetServiceManager sharedInstance] bindBankCardWithBankId:bankId
                                                bankCardNumber:bankCardNumber
                                              bankCardProvince:bankCardProvince
                                                  bankCardCity:bankCardCity
                                                bankBranchName:bankBranchName
                                            reservePhoneNumber:reservePhoneNumber
                                              productChannelId:productChannelId
                                                      delegate:self success:^(id responseObject) {
                                                          // 打点
                                                          [QMUMTookKitManager event:USER_BIND_CARD_SUCCESS_KEY label:@"绑卡成功"];
                                                          
                                                          // 绑定成功
                                                          [SVProgressHUD showSuccessWithStatus:QMLocalizedString(@"qm_bank_card_bind_success", @"绑定成功")];
                                                          [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                      } failure:^(NSError *error) {
                                                          // 绑定失败
                                                          [CMMUtility showNoteWithError:error];
                                                          
                                                          NSLog(@"%@",error);
                                                          
                                                          
                                                          
                                                      }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark QMSelectItemDelegate
- (void)viewController:(QMSelectItemViewController *)controller didSelectItem:(QMSearchItem *)item {
    if ([controller isKindOfClass:[QMSelectLocationViewController class]]) {
        QMSelectLocationViewController *con = (QMSelectLocationViewController *)controller;
        if (con.currentType == QMSelectLocationType_Province) {
            // 更新省份信息
            [selectProvinceBtn setTitle:item.itemTitle forState:UIControlStateNormal];
        }else if (con.currentType == QMSelectLocationType_City) {
            // 更新城市信息
            [selectCityBtn setTitle:item.itemTitle forState:UIControlStateNormal];
        }
    }else if ([controller isKindOfClass:[QMSelectLocationViewControllerV2 class]]) {
        QMSelectLocationViewControllerV2 *con = (QMSelectLocationViewControllerV2 *)controller;
        if (con.currentType == QMSelectLocationTypeV2_Province) {
            // 更新省份信息
            provinceItem = item;
            [selectProvinceBtn setTitle:item.itemTitle forState:UIControlStateNormal];
        }else if (con.currentType == QMSelectLocationTypeV2_City) {
            // 更新城市信息
            cityitem = item;
            [selectCityBtn setTitle:item.itemTitle forState:UIControlStateNormal];
        }
        
    }else if ([controller isKindOfClass:[QMAddBankViewController class]]) {
        QMBankInfo *info = (QMBankInfo *)item;
        if ([info isKindOfClass:[QMBankInfo class]]) {
            currentBankInfo = info;
            [selectBankBtn setTitle:currentBankInfo.bankName forState:UIControlStateNormal];
        }
    }
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_add_bankcard_nav_title", @"绑定银行卡");
}

@end
