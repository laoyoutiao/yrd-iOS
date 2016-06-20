//
//  QMIdentityAuthenticationViewController.m
//  MotherMoney
//

//

#import "QMIdentityAuthenticationViewController.h"
#import "QMNumberFormatPromptView.h"
#import "QMAddBankViewController.h"
#import "QMSelectLocationViewControllerV2.h"
#import "QMSelectLocationViewController.h"
#import "QMBankInfo.h"
#import "QMBankBranchInfo.h"
#import "QMBankBranchInfoViewController.h"
#import "QMTokenInfo.h"

@interface QMIdentityAuthenticationViewController ()<UITextFieldDelegate, QMSelectItemViewControllerDelegate>

@end

@implementation QMIdentityAuthenticationViewController {
    UILabel *promptLabel;
    
    UITextField *realNameField;
    
    UITextField *idCardField;
    
    // login button
    UIButton *identifyBtn;
    
    NSArray *locationInfo;
    
    UIScrollView *containerView;
    
    UIButton *selectBankBtn;
    
    UIButton *selectProvinceBtn;
    
    UIButton *selectCityBtn;
    
    UITextField *reseveredPhoneField;
    
    UITextField *bankCardIdField;
    
    UITextField *bankDetailInfoField;
    
//    QMOrderModel *mOrderModel;
    
    QMBankInfo *currentBankInfo;
    
    QMBankBranchInfo *branchInfo;
    
    QMNumberFormatPromptView *bankCardIdPromptView;
    
    QMNumberFormatPromptView *idCardPromptView;
    
//    QMNumberFormatPromptView *phoneNumberPromptView;
    
    QMSearchItem *provinceItem;
    
    QMSearchItem *cityitem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNextBtnState) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    
    // tap gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tap];
}

- (void)handleTextDidChangeNotification:(NSNotification *)noti {
    [self updateNextBtnState];
    
    NSObject *object = noti.object;
    if (object == bankCardIdField) {
        NSString *string = bankCardIdField.text;
        [bankCardIdPromptView updateWithText:[QMStringUtil formattedBankCardIdFromCardId:string]];
        
        BOOL bankPreviousHidden = bankCardIdPromptView.hidden;
        //文本框为空或者文本框不在第一个响应bankNowHidden都是为yes
        BOOL bankNowHidden = QM_IS_STR_NIL(bankCardIdField.text) || !(bankCardIdField.isFirstResponder);
        
        bankCardIdPromptView.hidden = bankNowHidden;
        
        if (bankPreviousHidden != bankNowHidden) {
//            bankCardIdPromptView.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame), CGRectGetWidth(bankCardIdField.frame), 40.0f);
            [self updateSubViewsFrameAnimated:YES];
        }else {
            [self updateSubViewsFrameAnimated:NO];
        }
        
    }else if(object == idCardField)
    {
        NSString *string = idCardField.text;
        [idCardPromptView updateWithText:[QMStringUtil formattedIdCardIdFromCardId:string]];
        
        BOOL idCardPreviousHidden = idCardPromptView.hidden;
        //文本框为空或者文本框不在第一个响应bankNowHidden都是为yes
        BOOL idCardNowHidden = QM_IS_STR_NIL(idCardField.text) || !(idCardField.isFirstResponder);
        
        idCardPromptView.hidden = idCardNowHidden;
        
        if (idCardPreviousHidden != idCardNowHidden) {
//            bankCardIdPromptView.frame = CGRectMake(CGRectGetMinX(idCardField.frame), CGRectGetMaxY(idCardField.frame), CGRectGetWidth(idCardField.frame), 40.0f);
            [self updateSubViewsFrameAnimated:YES];
        }else {
            [self updateSubViewsFrameAnimated:NO];
        }
        
    }
}

- (UIBarButtonItem *)leftBarButtonItem {
    return [QMNavigationBarItemFactory createNavigationBackItemWithTarget:self selector:@selector(goBack)];
}

- (void)goBack {
    if (self.isModel) {
        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     
                                 }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setUpSubViews {
    
    
    containerView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    containerView.alwaysBounceVertical = YES;
    if (self.view.frame.size.height < 600) {
        [containerView setContentSize:CGSizeMake(0, 800)];
    }
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:containerView];
    
    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, CGRectGetWidth(self.view.frame) - 2 * 20, 50.0f)];
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.numberOfLines = 2;
    promptLabel.textColor = QM_COMMON_TEXT_COLOR;
    promptLabel.text = QMLocalizedString(@"qm_identify_prompt_text", @"监管部门规定,购买理财产品需提供实名信息以确保投资安全");
    [containerView addSubview:promptLabel];
    
    // 真是姓名
    realNameField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(promptLabel.frame) + 10, CGRectGetWidth(self.view.frame) - 2 * 15, 35)];
    [realNameField setBackground:[QMImageFactory commonBackgroundImage]];
    UIView *nameleftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(realNameField.frame))];
    realNameField.leftView = nameleftView;
    realNameField.placeholder = QMLocalizedString(@"qm_identify_realname_field_text", @"请填写您的真实姓名");
    realNameField.leftViewMode = UITextFieldViewModeAlways;
    [containerView addSubview:realNameField];
    
    // 身份证号
    idCardField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(realNameField.frame), CGRectGetMaxY(realNameField.frame) + 10, CGRectGetWidth(realNameField.frame), CGRectGetHeight(realNameField.frame))];
    nameleftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(idCardField.frame))];
    [idCardField setBackground:[QMImageFactory commonBackgroundImage]];
    idCardField.leftView = nameleftView;
    idCardField.delegate = self;
    idCardField.keyboardType = UIKeyboardTypeASCIICapable;
    idCardField.leftViewMode = UITextFieldViewModeAlways;
    idCardField.placeholder = QMLocalizedString(@"qm_identify_idcard_field_text", @"请填写身份证号码");
    [idCardField addTarget:self action:@selector(upPhoneslope:) forControlEvents:UIControlEventEditingDidBegin];
    [idCardField addTarget:self action:@selector(downPhoneslope) forControlEvents:UIControlEventEditingDidEnd];
    [containerView addSubview:idCardField];
    
    idCardPromptView = [[QMNumberFormatPromptView alloc] initWithFrame:CGRectMake(CGRectGetMinX(idCardField.frame), CGRectGetMaxY(idCardField.frame), CGRectGetWidth(idCardField.frame), 40.0f)];
    idCardPromptView.hidden = YES;
    [containerView addSubview:idCardPromptView];
    
    promptLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(idCardPromptView.frame), CGRectGetMaxY(idCardField.frame) + 15, CGRectGetWidth(self.view.frame) - 2 * CGRectGetMinX(idCardPromptView.frame), 13)];
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
    [bankCardIdField addTarget:self action:@selector(upPhoneslope:) forControlEvents:UIControlEventEditingDidBegin];
    [bankCardIdField addTarget:self action:@selector(downPhoneslope) forControlEvents:UIControlEventEditingDidEnd];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(bankCardIdField.frame))];
    bankCardIdField.leftView = leftView;
    bankCardIdField.delegate = self;
    bankCardIdField.leftViewMode = UITextFieldViewModeAlways;
    [containerView addSubview:bankCardIdField];
    
    bankCardIdPromptView = [[QMNumberFormatPromptView alloc] initWithFrame:CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame), CGRectGetWidth(bankCardIdField.frame), 40.0f)];
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
    QMTokenInfo *tokenInfo = [QMTokenInfo sharedInstance];
    reseveredPhoneField.text = tokenInfo.phoneNumber;
    
    reseveredPhoneField.leftView = leftView;
    reseveredPhoneField.leftViewMode = UITextFieldViewModeAlways;
    [reseveredPhoneField addTarget:self action:@selector(upPhoneslope:) forControlEvents:UIControlEventEditingDidBegin];
    [reseveredPhoneField addTarget:self action:@selector(downPhoneslope) forControlEvents:UIControlEventEditingDidEnd];
    [containerView addSubview:reseveredPhoneField];
    
//    phoneNumberPromptView = [[QMNumberFormatPromptView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(reseveredPhoneField.frame), 40.0f)];
//    phoneNumberPromptView.hidden = YES;
//    [containerView addSubview:phoneNumberPromptView];
    
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
    [bankDetailInfoField addTarget:self action:@selector(upBankDetailslope) forControlEvents:UIControlEventEditingDidBegin];
    [bankDetailInfoField addTarget:self action:@selector(downBankDetailslope) forControlEvents:UIControlEventEditingDidEnd];
    [containerView addSubview:bankDetailInfoField];
    
    identifyBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(idCardField.frame), 40.0f) title:QMLocalizedString(@"qm_identify_identity_btn_title", @"认证")
                                                  target:self
                                                selector:@selector(identifyBtnClicked:)];
    CGRect frame = idCardField.frame;
    frame.origin = CGPointMake(CGRectGetMinX(idCardField.frame), CGRectGetMaxY(bankDetailInfoField.frame) + 30);
    identifyBtn.frame = frame;
    [containerView addSubview:identifyBtn];
    
    [self updateNextBtnState];
    [self updateBtnTitles];
    
}

- (void)updateBtnTitles {
    [selectBankBtn setTitle:QMLocalizedString(@"qm_add_bankcard_selectbank_text", @"请选择银行") forState:UIControlStateNormal];
    
    if (!QM_IS_STR_NIL(provinceItem.itemTitle)) { // 省份信息
        [selectProvinceBtn setTitle:provinceItem.itemTitle forState:UIControlStateNormal];
    }else {
        [selectProvinceBtn setTitle:@"请选择省份信息" forState:UIControlStateNormal];
    }
    
    if (!QM_IS_STR_NIL(cityitem.itemTitle)) {
        [selectCityBtn setTitle:cityitem.itemTitle forState:UIControlStateNormal];
    }else {
        [selectCityBtn setTitle:@"请选择城市信息" forState:UIControlStateNormal];
    }
}

- (void)updateNextBtnState {
    if (!QM_IS_STR_NIL(currentBankInfo.bankCode) &&
        !QM_IS_STR_NIL([self getBankCardNumber]) &&
        !QM_IS_STR_NIL([self getProvinceString]) &&
        !QM_IS_STR_NIL([self getCityString]) &&
        !QM_IS_STR_NIL([self getNameString]) &&
        !QM_IS_STR_NIL([self getIdCardString]) &&
        !QM_IS_STR_NIL([self getPhoneString]) &&
        !QM_IS_STR_NIL([self getBankDetailString]))
    {
        identifyBtn.enabled = YES;
    }else {
        identifyBtn.enabled = NO;
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
        bankCardIdPromptView.hidden = NO;
    }else if (textField == idCardField){
        idCardPromptView.hidden = NO;
    }
    
    [self updateSubViewsFrameAnimated:YES];
}

// did end editing
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == bankCardIdField) {
        bankCardIdPromptView.hidden = YES;
    }else if (textField == idCardField){
        idCardPromptView.hidden = YES;
    }
    
    [self updateSubViewsFrameAnimated:YES];
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

- (void)updateFrames {
    if (NO == bankCardIdPromptView.hidden) {
        bankCardIdPromptView.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame), CGRectGetWidth(bankCardIdField.frame), 40.0f);
        
        reseveredPhoneField.frame = CGRectMake(CGRectGetMinX(bankCardIdPromptView.frame), CGRectGetMaxY(bankCardIdPromptView.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
        
    }else if(NO == idCardPromptView.hidden)
    {
        idCardPromptView.frame = CGRectMake(CGRectGetMinX(idCardField.frame), CGRectGetMaxY(idCardField.frame), CGRectGetWidth(idCardField.frame), 40.0f);
        
        promptLabel.frame = CGRectMake(CGRectGetMinX(idCardPromptView.frame), CGRectGetMaxY(idCardPromptView.frame) + 10, CGRectGetWidth(promptLabel.frame), CGRectGetHeight(promptLabel.frame));
        
        selectBankBtn.frame = CGRectMake(CGRectGetMinX(promptLabel.frame), CGRectGetMaxY(promptLabel.frame) + 10, CGRectGetWidth(selectBankBtn.frame), CGRectGetHeight(selectBankBtn.frame));
        
        bankCardIdField.frame = CGRectMake(CGRectGetMinX(selectBankBtn.frame), CGRectGetMaxY(selectBankBtn.frame), CGRectGetWidth(bankCardIdField.frame), CGRectGetHeight(bankCardIdField.frame));
        
        reseveredPhoneField.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
        
    }else
    {
        promptLabel.frame = CGRectMake(CGRectGetMinX(idCardField.frame), CGRectGetMaxY(idCardField.frame) + 10, CGRectGetWidth(promptLabel.frame), CGRectGetHeight(promptLabel.frame));
        
        selectBankBtn.frame = CGRectMake(CGRectGetMinX(promptLabel.frame), CGRectGetMaxY(promptLabel.frame) + 10, CGRectGetWidth(selectBankBtn.frame), CGRectGetHeight(selectBankBtn.frame));
        
        bankCardIdField.frame = CGRectMake(CGRectGetMinX(selectBankBtn.frame), CGRectGetMaxY(selectBankBtn.frame), CGRectGetWidth(bankCardIdField.frame), CGRectGetHeight(bankCardIdField.frame));
        
        reseveredPhoneField.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
    }
    
    // 选择省市
    selectProvinceBtn.frame = CGRectMake(CGRectGetMinX(reseveredPhoneField.frame), CGRectGetMaxY(reseveredPhoneField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
    
    selectCityBtn.frame = CGRectMake(CGRectGetMinX(selectProvinceBtn.frame), CGRectGetMaxY(selectProvinceBtn.frame), CGRectGetWidth(selectProvinceBtn.frame), CGRectGetHeight(selectProvinceBtn.frame));
    
    // 支行信息
    bankDetailInfoField.frame = CGRectMake(CGRectGetMinX(selectCityBtn.frame), CGRectGetMaxY(selectCityBtn.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
    
    // 绑定
    CGRect frame = identifyBtn.frame;
    frame.origin = CGPointMake(CGRectGetMinX(bankDetailInfoField.frame), CGRectGetMaxY(bankDetailInfoField.frame) + 20);
    identifyBtn.frame = frame;
}

#pragma mark --
#pragma mark Get TextField Text

- (NSString *)getBankCardNumber {
    return [bankCardIdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)getProvinceString {
    return [[selectProvinceBtn titleForState:UIControlStateNormal] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)getCityString {
    return [[selectCityBtn titleForState:UIControlStateNormal] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)getNameString {
    return [realNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)getIdCardString {
    return [idCardField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)getPhoneString {
    return [reseveredPhoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)getBankDetailString {
    return [bankDetailInfoField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


#pragma --
#pragma mark TextField Edit ChangeContainerView

- (void)upBankDetailslope
{
    
    if (self.view.frame.size.height < 600) {
        containerView.contentOffset = CGPointMake(0, 400);
    }else
    {
        containerView.frame = CGRectMake(containerView.frame.origin.x, containerView.frame.origin.y - 220, containerView.frame.size.width, containerView.frame.size.height);
    }
}

- (void)downBankDetailslope
{
    if (self.view.frame.size.height < 600) {
        containerView.contentOffset = CGPointMake(0, 0);
    }else
    {
        containerView.frame = CGRectMake(containerView.frame.origin.x, containerView.frame.origin.y + 220, containerView.frame.size.width, containerView.frame.size.height);
    }
}

- (void)upPhoneslope:(UITextField *)textField
{
    if (self.view.frame.size.height < 600) {
        containerView.contentOffset = CGPointMake(0, CGRectGetMinY(textField.frame) - 70);
    }
}

- (void)downPhoneslope
{
    if (self.view.frame.size.height < 600) {
        containerView.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark --
#pragma mark TextField ResignFirstResponder
- (void)hideKeyBoard {
    [realNameField resignFirstResponder];
    [idCardField resignFirstResponder];
    [bankDetailInfoField resignFirstResponder];
    [reseveredPhoneField resignFirstResponder];
}

- (void)handleTapGesture:(UIGestureRecognizer *)tap {
    [realNameField resignFirstResponder];
    [idCardField resignFirstResponder];
    [reseveredPhoneField resignFirstResponder];
    [bankDetailInfoField resignFirstResponder];
}

#pragma mark -- 
#pragma mark Select Option Method

// 选择银行
- (void)selectBankBtnClicked:(UIButton *)btn {
    QMOrderModel *mOrderModel = [[QMOrderModel alloc] init];
    mOrderModel.productChannelId = @"2";
    
    QMAddBankViewController *con = [[QMAddBankViewController alloc] initViewControllerWithProduct:mOrderModel];
    con.delegate = self;
    con.isModel = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

// 选择省份
- (void)selectProvinceBtnClicked:(UIButton *)btn {
    QMSelectLocationViewControllerV2 *con = [[QMSelectLocationViewControllerV2 alloc] initViewControllerWithType:QMSelectLocationTypeV2_Province];
    con.isModel = YES;
    con.delegate = self;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

// 选择城市
- (void)selectCityBtnClicked:(UIButton *)btn {
    if (QM_IS_STR_NIL(provinceItem.itemCode)) { // 还没有选择省份
        [CMMUtility showNote:@"请先选择省份信息"];
        
        return;
    }
    
    QMSelectLocationViewControllerV2 *con = [[QMSelectLocationViewControllerV2 alloc] initViewControllerWithType:QMSelectLocationTypeV2_City];
    con.isModel = YES;
    con.provinceCode = provinceItem.itemCode;
    con.delegate = self;
    
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark --
#pragma mark Authentication

- (BOOL)isIDCardValid {
    NSString *idCard = [idCardField text];
    
    BOOL result = [CMMUtility checkIdNumber:idCard] && [self getPhoneString].length == 11;
    
    return result;
}

- (void)identifyBtnClicked:(UIButton *)btn {
    // 验证身份证和手机号码是否合法
    btn.enabled = NO;
    if ([self isIDCardValid]) {
        // 请求服务器接口
        NSDictionary *dict = @{@"idCardNumber":[self getIdCardString],
                               @"realName":[self getNameString],
                               @"bankCardNum":[self getBankCardNumber],
                               @"mobile":[self getPhoneString],
                               @"bankId":currentBankInfo.bankCardId,
                               @"provinceCode":provinceItem.itemCode,
                               @"cityCode":cityitem.itemCode,
                               @"province":[self getProvinceString],
                               @"city":[self getCityString],
                               @"branch":bankDetailInfoField.text,
                               @"productChannelId":@"2",};
        
        [self checkUserValidate:dict];
    }else {
        // 身份证号码或手机号码不合法
        btn.enabled = YES;
        [CMMUtility showNote:QMLocalizedString(@"qm_idcard_number_invalid", @"身份证号码或手机号码不合法")];
    }
}

- (void)checkUserValidate:(NSDictionary *)dict {
    if (QM_IS_STR_NIL(currentBankInfo.bankCardId)
        || QM_IS_STR_NIL([self getBankCardNumber])
        || QM_IS_STR_NIL(provinceItem.itemCode)
        || QM_IS_STR_NIL([self getCityString])
        || QM_IS_STR_NIL(bankDetailInfoField.text)
        || QM_IS_STR_NIL([self getPhoneString])
        )
    {
        return;
    }
    
    [[NetServiceManager sharedInstance] authDictionary:dict
                                            delegate:self success:^(id responseObject) {
                                                [self handleRealNameAuthSuccess:responseObject];
                                            } failure:^(NSError *error) {
                                                [self handleRealNameAuthFailure:error];
                                            }];
}

- (void)handleRealNameAuthSuccess:(id)response {
    [CMMUtility showNote:@"认证成功"];
    [self goBack];
    if (QM_IS_DELEGATE_RSP_SEL(self.delegate, authenticationViewController:didAuthenticateWithRealName:idCard:)) {
        [self.delegate authenticationViewController:self didAuthenticateWithRealName:[realNameField text] idCard:[idCardField text]];
    }
}

- (void)handleRealNameAuthFailure:(NSError *)error {
    identifyBtn.enabled = YES;
    [CMMUtility showNoteWithError:error];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark QMSelectItemViewControllerDelegate
- (void)viewController:(QMSelectItemViewController *)controller didSelectItem:(QMSearchItem *)item {
    if ([controller isKindOfClass:[QMSelectLocationViewControllerV2 class]]) {
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
    }else if ([controller isKindOfClass:[QMBankBranchInfoViewController class]]) {
        branchInfo = (QMBankBranchInfo *)item;
        
        //  更新支行名称
        if (!QM_IS_STR_NIL(branchInfo.branchName)) {
            bankDetailInfoField.text = branchInfo.branchName;
        }
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_identify_nav_title", @"身份信息确认");
}

@end
