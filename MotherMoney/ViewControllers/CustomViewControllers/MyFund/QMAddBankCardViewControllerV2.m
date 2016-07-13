//
//  QMAddBankCardViewControllerV2.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/13.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMAddBankCardViewControllerV2.h"
#import "QMAddBankCardViewController.h"
#import "QMSelectLocationViewController.h"
#import "QMConfirmBuyProductViewController.h"
#import "QMAddBankViewController.h"
#import "QMBankInfo.h"
#import "QMNumberFormatPromptView.h"
#import "QMSelectLocationViewControllerV2.h"
#import "QMBankBranchInfoViewController.h"
#import "QMTokenInfo.h"

@interface QMAddBankCardViewControllerV2 ()<UITextFieldDelegate, QMSelectItemViewControllerDelegate>

@end

@implementation QMAddBankCardViewControllerV2 {
    UILabel *promptLabel;//提示
    
    UIButton *selectBankBtn; // 选择银行
    UITextField *bankCardIdField; // 输入银行卡
    UITextField *reseveredPhoneField; //预留手机号
    UIButton *selectProvinceBtn;//省选择按钮
    UIButton *selectCityBtn;//市选择按钮
    
    UITextField *bankDetailInfoField;
    
    UIButton *nextStepBtn;
    
    QMBankInfo *currentBankInfo;
    
    UIScrollView *containerView;
    
    QMNumberFormatPromptView *bankCardIdPromptView;
    
    QMNumberFormatPromptView *phoneNumberPromptView;
    
    QMSearchItem *provinceItem;
    QMSearchItem *cityitem;
    QMBankBranchInfo *branchInfo;
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
    }
    
    BOOL bankPreviousHidden = bankCardIdPromptView.hidden;
    //文本框为空或者文本框不在第一个响应bankNowHidden都是为yes
    BOOL bankNowHidden = QM_IS_STR_NIL(bankCardIdField.text) || !(bankCardIdField.isFirstResponder);
    
    bankCardIdPromptView.hidden = bankNowHidden;
    
    if (bankPreviousHidden != bankNowHidden) {
        bankCardIdPromptView.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame), CGRectGetWidth(bankCardIdField.frame), 40.0f);
        [self updateSubViewsFrameAnimated:YES];
    }else {
        [self updateSubViewsFrameAnimated:NO];
    }
    
}

- (void)updateFrames {
    if (NO == bankCardIdPromptView.hidden) {
        //改动
//        if (bankCardIdPromptView.hidden == NO) {
//            bankCardIdPromptView.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame), CGRectGetWidth(bankCardIdField.frame), 40.0f);
//        }
        
        bankCardIdPromptView.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame), CGRectGetWidth(bankCardIdField.frame), 40.0f);
        
        reseveredPhoneField.frame = CGRectMake(CGRectGetMinX(bankCardIdPromptView.frame), CGRectGetMaxY(bankCardIdPromptView.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
        
    }else {
        reseveredPhoneField.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
       
    }
    
    // 选择省市
    selectProvinceBtn.frame = CGRectMake(CGRectGetMinX(reseveredPhoneField.frame), CGRectGetMaxY(reseveredPhoneField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
    
    selectCityBtn.frame = CGRectMake(CGRectGetMinX(selectProvinceBtn.frame), CGRectGetMaxY(selectProvinceBtn.frame), CGRectGetWidth(selectProvinceBtn.frame), CGRectGetHeight(selectProvinceBtn.frame));
    
    // 支行信息
    bankDetailInfoField.frame = CGRectMake(CGRectGetMinX(selectCityBtn.frame), CGRectGetMaxY(selectCityBtn.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
    
    // 绑定
    CGRect frame = nextStepBtn.frame;
    frame.origin = CGPointMake(CGRectGetMinX(bankDetailInfoField.frame), CGRectGetMaxY(bankDetailInfoField.frame) + 20);
    nextStepBtn.frame = frame;
}

//更新添加银行卡界面的布局
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
        !QM_IS_STR_NIL([self getProvinceString]) &&
        !QM_IS_STR_NIL([self getCityString]) &&
        !QM_IS_STR_NIL([self getBankLocationString]) &&
        !QM_IS_STR_NIL([self getPhoneNumber])) {
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
    }
    
    [self updateSubViewsFrameAnimated:YES];
}

// did end editing
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == bankCardIdField) {
        bankCardIdPromptView.hidden = YES;
    }
    
    [self updateSubViewsFrameAnimated:YES];
}

- (void)initDataSource {
}

- (void)setUpSubViews {
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    containerView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    containerView.alwaysBounceVertical = YES;
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:containerView];
    //添加提示信息
    promptLabel  = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, CGRectGetWidth(self.view.frame) - 2 * 20, 13)];
    promptLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
    promptLabel.font = [UIFont systemFontOfSize:11];
    promptLabel.text = QMLocalizedString(@"qm_add_bankcard_prompt_text", @"确认银行卡信息，如需修改请直接编辑");
    [containerView addSubview:promptLabel];
    
    //选择银行按钮
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
    //输入银行号文本框
    bankCardIdField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(selectBankBtn.frame), CGRectGetMaxY(selectBankBtn.frame), CGRectGetWidth(selectBankBtn.frame), CGRectGetHeight(selectBankBtn.frame))];
    //设置代理，实现代理方法
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
    //初始化隐藏提示视图
    bankCardIdPromptView.hidden = YES;
    [containerView addSubview:bankCardIdPromptView];
    
    reseveredPhoneField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame) + 10, CGRectGetWidth(bankCardIdField.frame), CGRectGetHeight(bankCardIdField.frame))];
    reseveredPhoneField.delegate = self;
    reseveredPhoneField.keyboardType = UIKeyboardTypeNumberPad;
    reseveredPhoneField.textColor = QM_COMMON_TEXT_COLOR;
    [reseveredPhoneField setBackground:[QMImageFactory commonTextFieldImage]];
    reseveredPhoneField.font = [UIFont systemFontOfSize:13];
    reseveredPhoneField.placeholder = QMLocalizedString(@"qm_input_resevered_phone_number_text", @"请输入预留手机号码");
//    QMTokenInfo *tokenInfo = [QMTokenInfo sharedInstance];
//    reseveredPhoneField.text = tokenInfo.phoneNumber;
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(bankCardIdField.frame))];
    reseveredPhoneField.leftView = leftView;
    reseveredPhoneField.leftViewMode = UITextFieldViewModeAlways;
//    [reseveredPhoneField addTarget:self action:@selector(upPhoneslope) forControlEvents:UIControlEventEditingDidBegin];
//    [reseveredPhoneField addTarget:self action:@selector(downPhoneslope) forControlEvents:UIControlEventEditingDidEnd];
    [containerView addSubview:reseveredPhoneField];
    
    phoneNumberPromptView = [[QMNumberFormatPromptView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(reseveredPhoneField.frame), 40.0f)];
    phoneNumberPromptView.hidden = YES;
    [containerView addSubview:phoneNumberPromptView];
    
    //选择省按钮
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
    //选择市按钮
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
    bankDetailInfoField.placeholder = @"请输入支行全名";
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(bankCardIdField.frame))];
    bankDetailInfoField.leftView = leftView;
    bankDetailInfoField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 35)];
    rightView.backgroundColor = [UIColor clearColor];
    
    //银行支行信息搜索按钮
//    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    infoBtn.frame = CGRectMake(0, (CGRectGetHeight(rightView.frame) - 32) / 2.0f, 32, 32);
//    [infoBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
//    [infoBtn setImage:[UIImage imageNamed:@"search.jpg"] forState:UIControlStateNormal];
//    [infoBtn addTarget:self action:@selector(getBankBranchInfo) forControlEvents:UIControlEventTouchUpInside];
//    [rightView addSubview:infoBtn];
    
    bankDetailInfoField.rightView = rightView;
    bankDetailInfoField.rightViewMode = UITextFieldViewModeAlways;
    
    [containerView addSubview:bankDetailInfoField];
    
    // 添加银行卡按钮
    nextStepBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(bankDetailInfoField.frame), CGRectGetHeight(bankDetailInfoField.frame)) title:@"添加" target:self selector:@selector(nextStepBtnClicked:)];
    CGRect frame = nextStepBtn.frame;
    frame.origin = CGPointMake(CGRectGetMinX(bankDetailInfoField.frame), CGRectGetMaxY(bankDetailInfoField.frame) + 20);
    nextStepBtn.frame = frame;
    [containerView addSubview:nextStepBtn];
    
    [self updateNextBtnState];
    [self updateBtnTitles];
}
//点击搜索按钮，获得支行信息
- (void)getBankBranchInfo {
    NSString *key = [self getBankLocationString];
    NSString *cardNumber = [self getBankCardNumber];
    NSString *cityCode = cityitem.itemCode;
    if (QM_IS_STR_NIL(key)) { // 关键字为空
        [CMMUtility showNote:@"请输入关键字搜索"];
        return;
    }else if (QM_IS_STR_NIL(cardNumber)) {
        [CMMUtility showNote:@"请输入银行卡号"];
        return;
    }else if (QM_IS_STR_NIL(cityCode)) {
        [CMMUtility showNote:@"请选择城市"];
        return;
    }
    
    QMBankBranchInfoViewController *con = [[QMBankBranchInfoViewController alloc] initViewControllerWithKeyWord:key cardNumber:cardNumber cityCode:cityCode];
    con.isModel = YES;
    

    con.delegate = self;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
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

- (NSString *)getBankCardNumber {
    return [bankCardIdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
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

- (NSString *)getPhoneNumber {
    return [reseveredPhoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

// 绑定
- (void)nextStepBtnClicked:(UIButton *)btn {
     // 打点
    nextStepBtn.enabled = NO;
    [QMUMTookKitManager event:USER_SUBMIT_BINDCARD_KEY label:@"用户提交绑卡"];
     
    NSString *bankId = currentBankInfo.bankCardId;
    NSString *bankCardNumber = [self getBankCardNumber];
    NSString *bankProvinceCode = provinceItem.itemCode;
    NSString *bankCityCode = cityitem.itemCode;;
    NSString *productChannelId = @"2";
//    NSString *prcptcd = branchInfo.prcpct;
    NSString *branchName = bankDetailInfoField.text;
    NSString *phoneNumber = reseveredPhoneField.text;
    
    NSString *errorMsg = nil;
    
    if (QM_IS_STR_NIL(bankId)) {
        errorMsg = QMLocalizedString(@"qm_bind_card_no_id", @"请选择银行");
    }else if (QM_IS_STR_NIL(bankCardNumber)) {
        errorMsg = QMLocalizedString(@"qm_bind_card_no_card_number", @"请输入银行卡号");
    }else if (QM_IS_STR_NIL(bankProvinceCode)) {
        errorMsg = QMLocalizedString(@"qm_bind_card_no_province", @"请选择省份");
    }else if (QM_IS_STR_NIL(bankCityCode)) {
        errorMsg = QMLocalizedString(@"qm_bind_card_no_city", @"请选择城市");
    }else if (QM_IS_STR_NIL(branchName)) {
        errorMsg = QMLocalizedString(@"qm_bind_card_no_branchName", @"请输入支行名称");
    }else if (bankCardNumber.length <= 10){
        errorMsg = QMLocalizedString(@"qm_bind_card_right_bankCardNumber", @"请输入正确格式的银行卡号");
    }else if (phoneNumber.length != 11)
    {
        errorMsg = QMLocalizedString(@"qm_bind_card_right_bankCardNumber", @"请输入正确格式的手机号码");
    }

    if (!QM_IS_STR_NIL(errorMsg)) {
        
        [CMMUtility showNote:errorMsg];
        return;
    }

    [[NetServiceManager sharedInstance] newAddBankCardWithChannelId:productChannelId bankId:bankId bankCardNumber:bankCardNumber provinceCode:bankProvinceCode cityCode:bankCityCode branchName:branchName phoneNumber:phoneNumber delegate:self success:^(id responseObject) {
         // 打点
         [QMUMTookKitManager event:USER_BIND_CARD_SUCCESS_KEY label:@"绑卡成功"];
         
         // 绑定成功
         [SVProgressHUD showSuccessWithStatus:QMLocalizedString(@"qm_bank_card_bind_success", @"绑定成功")];
         
         [self.navigationController dismissViewControllerAnimated:YES completion:nil];
         
         
     } failure:^(NSError *error) {
         // 绑定失败
         
         
         
         
         [CMMUtility showNoteWithError:error];
     }];
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
    return @"添加银行卡";
}

@end
