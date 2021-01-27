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
#import "QMProvinceInfo.h"

@interface QMIdentityAuthenticationViewController ()<UITextFieldDelegate, QMSelectItemViewControllerDelegate, UIWebViewDelegate>

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
    UIButton *oldgetbankMessageCodeBtn;
    UIButton *newgetbankMessageCodeBtn;
    UITextField *reseveredPhoneField;
    UITextField *bankCardIdField;
    UITextField *oldreseveredPhoneField;
    UITextField *oldbankCardIdField;
    UITextField *oldbankCardMessageCodeField;
    UITextField *newbankCardMessageCodeField;
    
    QMBankInfo *currentBankInfo;
    QMNumberFormatPromptView *bankCardIdPromptView;
    QMNumberFormatPromptView *idCardPromptView;
    QMNumberFormatPromptView *oldbankCardIdPromptView;
    QMSearchItem *provinceItem;
    QMSearchItem *cityitem;
    
    BOOL showWebNow;
    UIWebView *responWebView;
    NSTimer *oldSmsCodeTimer;
    NSTimer *newSmsCodeTimer;
    NSInteger oldSmsCodeTime;
    NSInteger newSmsCodeTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    showWebNow = NO;
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
        
    }else if(object == oldbankCardIdField)
    {
        NSString *string = oldbankCardIdField.text;
        [oldbankCardIdPromptView updateWithText:[QMStringUtil formattedBankCardIdFromCardId:string]];
        
        BOOL oldbankCardIdPromotHidden = oldbankCardIdPromptView.hidden;
        //文本框为空或者文本框不在第一个响应bankNowHidden都是为yes
        BOOL oldbankCardIdPromotNowHidden = QM_IS_STR_NIL(oldbankCardIdField.text) || !(oldbankCardIdField.isFirstResponder);
        
        oldbankCardIdPromptView.hidden = oldbankCardIdPromotNowHidden;
        
        if (oldbankCardIdPromotHidden != oldbankCardIdPromotNowHidden) {
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
    if (showWebNow) {
        [responWebView removeFromSuperview];
        showWebNow = NO;
    }else
    {
        if (self.isModel) {
            [self dismissViewControllerAnimated:YES
                                     completion:^{
                                         
                                     }];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)setUpSubViews {
    
    
    containerView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    containerView.alwaysBounceVertical = YES;
    if (_isOpenAccount)
    {
        [containerView setContentSize:CGSizeMake(0, 800)];
    }else if (_isActivationAccount)
    {
        [containerView setContentSize:CGSizeMake(0, 700)];
    }else if (_isChangeBandCard)
    {
        [containerView setContentSize:CGSizeMake(0, 950)];
    }
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:containerView];
    
    if (_isOpenAccount == YES) {
        [self setupOpenAccount];
    }else if (_isActivationAccount == YES)
    {
        [self setupActvitionAccount];
    }else if (_isChangeBandCard == YES)
    {
        [self setupChangeBandCard];
    }
    
    [self setupPromptView];
    
    [self updateNextBtnState];
    [self updateBtnTitles];
}

- (void)setupPromptView
{
    oldbankCardIdPromptView = [[QMNumberFormatPromptView alloc] initWithFrame:CGRectMake(CGRectGetMinX(oldbankCardIdField.frame), CGRectGetMaxY(oldbankCardIdField.frame), CGRectGetWidth(oldbankCardIdField.frame), 40.0f)];
    oldbankCardIdPromptView.hidden = YES;
    [containerView addSubview:oldbankCardIdPromptView];
    
    idCardPromptView = [[QMNumberFormatPromptView alloc] initWithFrame:CGRectMake(CGRectGetMinX(idCardField.frame), CGRectGetMaxY(idCardField.frame), CGRectGetWidth(idCardField.frame), 40.0f)];
    idCardPromptView.hidden = YES;
    [containerView addSubview:idCardPromptView];
    
    bankCardIdPromptView = [[QMNumberFormatPromptView alloc] initWithFrame:CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame), CGRectGetWidth(bankCardIdField.frame), 40.0f)];
    bankCardIdPromptView.hidden = YES;
    [containerView addSubview:bankCardIdPromptView];
}

- (void)setupOpenAccount
{
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
    realNameField.text = self.userRealName;
    NSLog(@"%@",_userRealName);
    [containerView addSubview:realNameField];
    
    // 身份证号
    idCardField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(realNameField.frame), CGRectGetMaxY(realNameField.frame) + 10, CGRectGetWidth(realNameField.frame), CGRectGetHeight(realNameField.frame))];
    idCardField.text = self.userIdCard;
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
    
    promptLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(idCardField.frame), CGRectGetMaxY(idCardField.frame) + 10, CGRectGetWidth(self.view.frame) - 2 * CGRectGetMinX(idCardField.frame), 13)];
    promptLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
    promptLabel.font = [UIFont systemFontOfSize:11];
    promptLabel.text = QMLocalizedString(@"qm_add_bankcard_prompt_text", @"确认银行卡信息，如需修改请直接编辑");
    [containerView addSubview:promptLabel];
    
    [self setupPublicBtnWithAccount];
}

- (void)setupActvitionAccount
{
    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, CGRectGetWidth(self.view.frame) - 2 * 20, 50.0f)];
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.numberOfLines = 2;
    promptLabel.textColor = QM_COMMON_TEXT_COLOR;
    promptLabel.text = QMLocalizedString(@"qm_add_bankcard_prompt_text", @"确认银行卡信息，如需修改请直接编辑");
    [containerView addSubview:promptLabel];
    
    [self setupPublicBtnWithAccount];
}

- (void)setupChangeBandCard
{
    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, CGRectGetWidth(self.view.frame) - 2 * 20, 50.0f)];
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.numberOfLines = 1;
    promptLabel.textColor = QM_COMMON_TEXT_COLOR;
    promptLabel.text = @"请输入原绑定银行卡信息";
    [containerView addSubview:promptLabel];
    
    oldbankCardIdField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(promptLabel.frame), CGRectGetMaxY(promptLabel.frame) , CGRectGetWidth(promptLabel.frame), 44)];
    oldbankCardIdField.delegate = self;
    oldbankCardIdField.keyboardType = UIKeyboardTypeNumberPad;
    oldbankCardIdField.textColor = QM_COMMON_TEXT_COLOR;
    [oldbankCardIdField setBackground:[QMImageFactory commonTextFieldImage]];
    oldbankCardIdField.font = [UIFont systemFontOfSize:13];
    oldbankCardIdField.placeholder = QMLocalizedString(@"qm_add_bankcard_selectbank_id_text", @"请输入您的银行卡");
    [oldbankCardIdField addTarget:self action:@selector(upPhoneslope:) forControlEvents:UIControlEventEditingDidBegin];
    [oldbankCardIdField addTarget:self action:@selector(downPhoneslope) forControlEvents:UIControlEventEditingDidEnd];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(oldbankCardIdField.frame))];
    oldbankCardIdField.leftView = leftView;
    oldbankCardIdField.delegate = self;
    oldbankCardIdField.leftViewMode = UITextFieldViewModeAlways;
    [containerView addSubview:oldbankCardIdField];
    
    oldreseveredPhoneField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(oldbankCardIdField.frame), CGRectGetMaxY(oldbankCardIdField.frame) + 10, CGRectGetWidth(oldbankCardIdField.frame), CGRectGetHeight(oldbankCardIdField.frame))];
    oldreseveredPhoneField.delegate = self;
    oldreseveredPhoneField.keyboardType = UIKeyboardTypeNumberPad;
    oldreseveredPhoneField.textColor = QM_COMMON_TEXT_COLOR;
    [oldreseveredPhoneField setBackground:[QMImageFactory commonTextFieldImage]];
    oldreseveredPhoneField.font = [UIFont systemFontOfSize:13];
    oldreseveredPhoneField.placeholder = QMLocalizedString(@"qm_input_resevered_phone_number_text", @"请输入预留手机号码");
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(oldbankCardIdField.frame))];
    
    oldreseveredPhoneField.leftView = leftView;
    oldreseveredPhoneField.leftViewMode = UITextFieldViewModeAlways;
    [oldreseveredPhoneField addTarget:self action:@selector(upPhoneslope:) forControlEvents:UIControlEventEditingDidBegin];
    [oldreseveredPhoneField addTarget:self action:@selector(downPhoneslope) forControlEvents:UIControlEventEditingDidEnd];
    [containerView addSubview:oldreseveredPhoneField];
    
    oldbankCardMessageCodeField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(oldreseveredPhoneField.frame), CGRectGetMaxY(oldreseveredPhoneField.frame) + 10, CGRectGetWidth(oldreseveredPhoneField.frame) / 1.9, CGRectGetHeight(oldreseveredPhoneField.frame))];
    oldbankCardMessageCodeField.delegate = self;
    oldbankCardMessageCodeField.keyboardType = UIKeyboardTypeNumberPad;
    oldbankCardMessageCodeField.textColor = QM_COMMON_TEXT_COLOR;
    [oldbankCardMessageCodeField setBackground:[QMImageFactory commonTextFieldImage]];
    oldbankCardMessageCodeField.font = [UIFont systemFontOfSize:13];
    oldbankCardMessageCodeField.placeholder = @"请输入旧银行卡验证码";
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(oldbankCardIdField.frame))];
    oldbankCardMessageCodeField.leftView = leftView;
    oldbankCardMessageCodeField.leftViewMode = UITextFieldViewModeAlways;
    [oldbankCardMessageCodeField addTarget:self action:@selector(upPhoneslope:) forControlEvents:UIControlEventEditingDidBegin];
    [oldbankCardMessageCodeField addTarget:self action:@selector(downPhoneslope) forControlEvents:UIControlEventEditingDidEnd];
    [containerView addSubview:oldbankCardMessageCodeField];
    
    oldgetbankMessageCodeBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(oldreseveredPhoneField.frame) - CGRectGetWidth(oldbankCardMessageCodeField.frame) - 20, CGRectGetHeight(oldbankCardMessageCodeField.frame)) title:@"获取验证码"
                                                  target:self
                                                selector:@selector(clickGetOldBankMessageCode)];
    CGRect frame = oldgetbankMessageCodeBtn.frame;
    frame.origin = CGPointMake(CGRectGetMinX(oldbankCardMessageCodeField.frame) + CGRectGetWidth(oldbankCardMessageCodeField.frame) + 20, oldbankCardMessageCodeField.frame.origin.y);
    oldgetbankMessageCodeBtn.frame = frame;
    [containerView addSubview:oldgetbankMessageCodeBtn];

    promptLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(oldbankCardMessageCodeField.frame), CGRectGetMaxY(oldbankCardMessageCodeField.frame) + 10, CGRectGetWidth(self.view.frame) - 2 * CGRectGetMinX(oldreseveredPhoneField.frame), 20)];
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.numberOfLines = 1;
    promptLabel.textColor = QM_COMMON_TEXT_COLOR;
    promptLabel.text = @"请输入新绑定银行卡信息";
    [containerView addSubview:promptLabel];
    
    [self setupPublicBtnWithAccount];
}

- (void)setupPublicBtnWithAccount
{
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
    [reseveredPhoneField addTarget:self action:@selector(upPhoneslope:) forControlEvents:UIControlEventEditingDidBegin];
    [reseveredPhoneField addTarget:self action:@selector(downPhoneslope) forControlEvents:UIControlEventEditingDidEnd];
    [containerView addSubview:reseveredPhoneField];
    
    if (_isChangeBandCard) {
        newbankCardMessageCodeField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(reseveredPhoneField.frame), CGRectGetMaxY(reseveredPhoneField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame) / 1.9, CGRectGetHeight(reseveredPhoneField.frame))];
        newbankCardMessageCodeField.delegate = self;
        newbankCardMessageCodeField.keyboardType = UIKeyboardTypeNumberPad;
        newbankCardMessageCodeField.textColor = QM_COMMON_TEXT_COLOR;
        [newbankCardMessageCodeField setBackground:[QMImageFactory commonTextFieldImage]];
        newbankCardMessageCodeField.font = [UIFont systemFontOfSize:13];
        newbankCardMessageCodeField.placeholder = @"请输入新银行卡验证码";
        leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(bankCardIdField.frame))];
        newbankCardMessageCodeField.leftView = leftView;
        newbankCardMessageCodeField.leftViewMode = UITextFieldViewModeAlways;
        [newbankCardMessageCodeField addTarget:self action:@selector(upPhoneslope:) forControlEvents:UIControlEventEditingDidBegin];
        [newbankCardMessageCodeField addTarget:self action:@selector(downPhoneslope) forControlEvents:UIControlEventEditingDidEnd];
        [containerView addSubview:newbankCardMessageCodeField];
        
        newgetbankMessageCodeBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(reseveredPhoneField.frame) - CGRectGetWidth(newbankCardMessageCodeField.frame) - 20, CGRectGetHeight(newbankCardMessageCodeField.frame)) title:@"获取验证码"
                                                                   target:self
                                                                 selector:@selector(clickGetNewBankMessageCode)];
        CGRect frame = newgetbankMessageCodeBtn.frame;
        frame.origin = CGPointMake(CGRectGetMinX(newbankCardMessageCodeField.frame) + CGRectGetWidth(newbankCardMessageCodeField.frame) + 20, newbankCardMessageCodeField.frame.origin.y);
        newgetbankMessageCodeBtn.frame = frame;
        [containerView addSubview:newgetbankMessageCodeBtn];
    }
    
    selectProvinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectProvinceBtn setImage:[UIImage imageNamed:@"shearhead.png"] forState:UIControlStateNormal];
    [selectProvinceBtn setBackgroundImage:[QMImageFactory commonTextFieldImageTopPart] forState:UIControlStateNormal];
    [selectProvinceBtn setBackgroundImage:[QMImageFactory commonTextFieldImageTopPart] forState:UIControlStateHighlighted];
    if (_isChangeBandCard) {
        selectProvinceBtn.frame = CGRectMake(CGRectGetMinX(newbankCardMessageCodeField.frame), CGRectGetMaxY(newbankCardMessageCodeField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
    }else
    {
        selectProvinceBtn.frame = CGRectMake(CGRectGetMinX(reseveredPhoneField.frame), CGRectGetMaxY(reseveredPhoneField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
    }
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
    
    identifyBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(selectCityBtn.frame), 40.0f) title:QMLocalizedString(@"qm_identify_identity_btn_title", @"提交")
                                                  target:self
                                                selector:@selector(identifyBtnClicked:)];
    CGRect frame = identifyBtn.frame;
    frame.origin = CGPointMake(CGRectGetMinX(selectCityBtn.frame), CGRectGetMaxY(selectCityBtn.frame) + 30);
    identifyBtn.frame = frame;
    [containerView addSubview:identifyBtn];

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
    if(_isOpenAccount == YES)
    {
        if (!QM_IS_STR_NIL(currentBankInfo.bankCode) &&
            !QM_IS_STR_NIL([self getBankCardNumber]) &&
            !QM_IS_STR_NIL(provinceItem.itemCode) &&
            !QM_IS_STR_NIL([self getCityCode]) &&
            !QM_IS_STR_NIL([self getNameString]) &&
            !QM_IS_STR_NIL([self getIdCardString]) &&
            !QM_IS_STR_NIL([self getPhoneString]))
        {
            identifyBtn.enabled = YES;
        }else {
            identifyBtn.enabled = NO;
        }
    }else if (_isActivationAccount)
    {
        if (!QM_IS_STR_NIL(currentBankInfo.bankCode) &&
            !QM_IS_STR_NIL([self getBankCardNumber]) &&
            !QM_IS_STR_NIL(provinceItem.itemCode) &&
            !QM_IS_STR_NIL([self getCityCode]) &&
            !QM_IS_STR_NIL([self getPhoneString]))
        {
            identifyBtn.enabled = YES;
        }else {
            identifyBtn.enabled = NO;
        }
    }else if (_isChangeBandCard)
    {
        if (!QM_IS_STR_NIL(currentBankInfo.bankCode) &&
            !QM_IS_STR_NIL([self getOldBankCardNumber]) &&
            !QM_IS_STR_NIL([self getOldPhoneString]) &&
            !QM_IS_STR_NIL([self getBankCardNumber]) &&
            !QM_IS_STR_NIL([self getPhoneString]) &&
            !QM_IS_STR_NIL(provinceItem.itemCode) &&
            !QM_IS_STR_NIL([self getCityCode]) &&
            !QM_IS_STR_NIL([self getOldBankMessageCode]) &&
            !QM_IS_STR_NIL([self getNewBankMessageCode]))
        {
            identifyBtn.enabled = YES;
        }else {
            identifyBtn.enabled = NO;
        }
        if (QM_IS_STR_NIL([self getBankCardNumber])
            || QM_IS_STR_NIL([self getPhoneString]))
        {
            newgetbankMessageCodeBtn.enabled = NO;
        }else
        {
            newgetbankMessageCodeBtn.enabled = YES;
        }
        if (QM_IS_STR_NIL([self getOldBankCardNumber])
            || QM_IS_STR_NIL([self getOldPhoneString]))
        {
            oldgetbankMessageCodeBtn.enabled = NO;
        }else
        {
            oldgetbankMessageCodeBtn.enabled = YES;
        }
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
    }else if (textField == oldbankCardIdField)
    {
        oldbankCardIdPromptView.hidden = NO;
    }
    
    [self updateSubViewsFrameAnimated:YES];
}

// did end editing
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == bankCardIdField) {
        bankCardIdPromptView.hidden = YES;
    }else if (textField == idCardField){
        idCardPromptView.hidden = YES;
    }else if (textField == oldbankCardIdField)
    {
        oldbankCardIdPromptView.hidden = YES;
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
    if (_isOpenAccount == YES)
    {
        [self updateFramesWithOpenAccount];
    }else if (_isActivationAccount == YES)
    {
        [self updateFramesWithActivation];
    }else if (_isChangeBandCard == YES)
    {
        [self updateFramesWithChangeBankCard];
    }
}

- (void)updateFramesWithOpenAccount
{
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
        
    }
    else
    {
        promptLabel.frame = CGRectMake(CGRectGetMinX(idCardField.frame), CGRectGetMaxY(idCardField.frame) + 10, CGRectGetWidth(promptLabel.frame), CGRectGetHeight(promptLabel.frame));
        
        selectBankBtn.frame = CGRectMake(CGRectGetMinX(promptLabel.frame), CGRectGetMaxY(promptLabel.frame) + 10, CGRectGetWidth(selectBankBtn.frame), CGRectGetHeight(selectBankBtn.frame));
        
        bankCardIdField.frame = CGRectMake(CGRectGetMinX(selectBankBtn.frame), CGRectGetMaxY(selectBankBtn.frame), CGRectGetWidth(bankCardIdField.frame), CGRectGetHeight(bankCardIdField.frame));
        
        reseveredPhoneField.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
    }
    
    // 选择省市
    selectProvinceBtn.frame = CGRectMake(CGRectGetMinX(reseveredPhoneField.frame), CGRectGetMaxY(reseveredPhoneField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
    
    selectCityBtn.frame = CGRectMake(CGRectGetMinX(selectProvinceBtn.frame), CGRectGetMaxY(selectProvinceBtn.frame), CGRectGetWidth(selectProvinceBtn.frame), CGRectGetHeight(selectProvinceBtn.frame));
    
    // 绑定
    CGRect frame = identifyBtn.frame;
    frame.origin = CGPointMake(CGRectGetMinX(selectCityBtn.frame), CGRectGetMaxY(selectCityBtn.frame) + 30);
    identifyBtn.frame = frame;

}

- (void)updateFramesWithActivation
{
    if (NO == bankCardIdPromptView.hidden) {
        bankCardIdPromptView.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame), CGRectGetWidth(bankCardIdField.frame), 40.0f);
        
        reseveredPhoneField.frame = CGRectMake(CGRectGetMinX(bankCardIdPromptView.frame), CGRectGetMaxY(bankCardIdPromptView.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
        
    }else
    {
        bankCardIdField.frame = CGRectMake(CGRectGetMinX(selectBankBtn.frame), CGRectGetMaxY(selectBankBtn.frame), CGRectGetWidth(bankCardIdField.frame), CGRectGetHeight(bankCardIdField.frame));
        
        reseveredPhoneField.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
    }
    
    // 选择省市
    selectProvinceBtn.frame = CGRectMake(CGRectGetMinX(reseveredPhoneField.frame), CGRectGetMaxY(reseveredPhoneField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
    
    selectCityBtn.frame = CGRectMake(CGRectGetMinX(selectProvinceBtn.frame), CGRectGetMaxY(selectProvinceBtn.frame), CGRectGetWidth(selectProvinceBtn.frame), CGRectGetHeight(selectProvinceBtn.frame));
    
    // 绑定
    CGRect frame = identifyBtn.frame;
    frame.origin = CGPointMake(CGRectGetMinX(selectCityBtn.frame), CGRectGetMaxY(selectCityBtn.frame) + 30);
    identifyBtn.frame = frame;
}

- (void)updateFramesWithChangeBankCard
{
    if (NO == oldbankCardIdPromptView.hidden)
    {
        oldbankCardIdPromptView.frame = CGRectMake(CGRectGetMinX(oldbankCardIdField.frame), CGRectGetMaxY(oldbankCardIdField.frame), CGRectGetWidth(oldbankCardIdField.frame), 40.0f);
        
        oldreseveredPhoneField.frame = CGRectMake(CGRectGetMinX(oldbankCardIdPromptView.frame), CGRectGetMaxY(oldbankCardIdPromptView.frame) + 10, CGRectGetWidth(oldreseveredPhoneField.frame), CGRectGetHeight(oldreseveredPhoneField.frame));
        
        oldbankCardMessageCodeField.frame = CGRectMake(CGRectGetMinX(oldreseveredPhoneField.frame), CGRectGetMaxY(oldreseveredPhoneField.frame) + 10, CGRectGetWidth(oldreseveredPhoneField.frame) / 1.9, CGRectGetHeight(oldreseveredPhoneField.frame));
        
        promptLabel.frame = CGRectMake(CGRectGetMinX(oldbankCardMessageCodeField.frame), CGRectGetMaxY(oldbankCardMessageCodeField.frame) + 10, CGRectGetWidth(promptLabel.frame), CGRectGetHeight(promptLabel.frame));
        
        selectBankBtn.frame = CGRectMake(CGRectGetMinX(promptLabel.frame), CGRectGetMaxY(promptLabel.frame) + 10, CGRectGetWidth(selectBankBtn.frame), CGRectGetHeight(selectBankBtn.frame));
        
        bankCardIdField.frame = CGRectMake(CGRectGetMinX(selectBankBtn.frame), CGRectGetMaxY(selectBankBtn.frame), CGRectGetWidth(bankCardIdField.frame), CGRectGetHeight(bankCardIdField.frame));
        
        reseveredPhoneField.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
        
        newbankCardMessageCodeField.frame = CGRectMake(CGRectGetMinX(reseveredPhoneField.frame), CGRectGetMaxY(reseveredPhoneField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame) / 1.9, CGRectGetHeight(reseveredPhoneField.frame));
        
    }else if (NO == bankCardIdPromptView.hidden)
    {
        bankCardIdPromptView.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame), CGRectGetWidth(bankCardIdField.frame), 40.0f);
        
        reseveredPhoneField.frame = CGRectMake(CGRectGetMinX(bankCardIdPromptView.frame), CGRectGetMaxY(bankCardIdPromptView.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
        
        newbankCardMessageCodeField.frame = CGRectMake(CGRectGetMinX(reseveredPhoneField.frame), CGRectGetMaxY(reseveredPhoneField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame) / 1.9, CGRectGetHeight(reseveredPhoneField.frame));
        
    }else
    {
        oldreseveredPhoneField.frame = CGRectMake(CGRectGetMinX(oldbankCardIdField.frame), CGRectGetMaxY(oldbankCardIdField.frame) + 10, CGRectGetWidth(oldreseveredPhoneField.frame), CGRectGetHeight(oldreseveredPhoneField.frame));
        
        oldbankCardMessageCodeField.frame = CGRectMake(CGRectGetMinX(oldreseveredPhoneField.frame), CGRectGetMaxY(oldreseveredPhoneField.frame) + 10, CGRectGetWidth(oldreseveredPhoneField.frame) / 1.9, CGRectGetHeight(oldreseveredPhoneField.frame));
        
        promptLabel.frame = CGRectMake(CGRectGetMinX(oldbankCardMessageCodeField.frame), CGRectGetMaxY(oldbankCardMessageCodeField.frame) + 10, CGRectGetWidth(promptLabel.frame), CGRectGetHeight(promptLabel.frame));
        
        selectBankBtn.frame = CGRectMake(CGRectGetMinX(promptLabel.frame), CGRectGetMaxY(promptLabel.frame) + 10, CGRectGetWidth(selectBankBtn.frame), CGRectGetHeight(selectBankBtn.frame));
        
        bankCardIdField.frame = CGRectMake(CGRectGetMinX(selectBankBtn.frame), CGRectGetMaxY(selectBankBtn.frame), CGRectGetWidth(bankCardIdField.frame), CGRectGetHeight(bankCardIdField.frame));
        
        reseveredPhoneField.frame = CGRectMake(CGRectGetMinX(bankCardIdField.frame), CGRectGetMaxY(bankCardIdField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
        
        newbankCardMessageCodeField.frame = CGRectMake(CGRectGetMinX(reseveredPhoneField.frame), CGRectGetMaxY(reseveredPhoneField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame) / 1.9, CGRectGetHeight(reseveredPhoneField.frame));
    }
    
    // 选择省市
    selectProvinceBtn.frame = CGRectMake(CGRectGetMinX(newbankCardMessageCodeField.frame), CGRectGetMaxY(newbankCardMessageCodeField.frame) + 10, CGRectGetWidth(reseveredPhoneField.frame), CGRectGetHeight(reseveredPhoneField.frame));
    
    selectCityBtn.frame = CGRectMake(CGRectGetMinX(selectProvinceBtn.frame), CGRectGetMaxY(selectProvinceBtn.frame), CGRectGetWidth(selectProvinceBtn.frame), CGRectGetHeight(selectProvinceBtn.frame));
    
    CGRect oldbtnframe = oldgetbankMessageCodeBtn.frame;
    oldbtnframe.origin = CGPointMake(oldbtnframe.origin.x, oldbankCardMessageCodeField.frame.origin.y);
    oldgetbankMessageCodeBtn.frame = oldbtnframe;
    
    CGRect newbtnframe = newgetbankMessageCodeBtn.frame;
    newbtnframe.origin = CGPointMake(newbtnframe.origin.x, newbankCardMessageCodeField.frame.origin.y);
    newgetbankMessageCodeBtn.frame = newbtnframe;
    
    // 绑定
    CGRect frame = identifyBtn.frame;
    frame.origin = CGPointMake(CGRectGetMinX(selectCityBtn.frame), CGRectGetMaxY(selectCityBtn.frame) + 30);
    identifyBtn.frame = frame;
}

#pragma mark --
#pragma mark Get TextField Text

- (NSString *)getBankCardNumber {
    return [bankCardIdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)getOldBankCardNumber {
    return [oldbankCardIdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
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

- (NSString *)getOldPhoneString {
    return [oldreseveredPhoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)getOldBankMessageCode {
    return [oldbankCardMessageCodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)getNewBankMessageCode {
    return [oldbankCardMessageCodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)getProvinceCode {
    NSString *province = [self getProvinceString];
    return [[QMProvinceInfo sharedInstance] getProvinceNumWithProvinceName:province];}

- (NSString *)getCityCode {
    NSString *province = [self getProvinceString];
    NSString *city = [self getCityString];
    if ([city isEqualToString:@"请选择城市信息"]) {
        return nil;
    }
    return [[QMProvinceInfo sharedInstance] getCityNumWithProvinceName:province CityName:city];
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
    [reseveredPhoneField resignFirstResponder];
    [bankCardIdField resignFirstResponder];
    [oldreseveredPhoneField resignFirstResponder];
    [newbankCardMessageCodeField resignFirstResponder];
}

- (void)handleTapGesture:(UIGestureRecognizer *)tap {
    [realNameField resignFirstResponder];
    [idCardField resignFirstResponder];
    [reseveredPhoneField resignFirstResponder];
    [bankCardIdField resignFirstResponder];
    [oldbankCardMessageCodeField resignFirstResponder];
    [newbankCardMessageCodeField resignFirstResponder];
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
//    con.provinceCode = provinceItem.itemCode;
    con.provinceName = provinceItem.itemTitle;
    con.delegate = self;
    
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark --
#pragma mark Authentication

- (void)clickGetOldBankMessageCode
{
    if (QM_IS_STR_NIL([self getOldBankCardNumber])
        || QM_IS_STR_NIL([self getOldPhoneString]))
    {
        [CMMUtility showNote:@"请输入旧银行卡账号和预留手机号"];
        return;
    }
    
    [[NetServiceManager sharedInstance] getBankMessageCode:self
                                                BankCardID:[self getOldBankCardNumber]
                                                    Mobile:[self getOldPhoneString]
                                                   SmsType:RebindBankMessageTypeOldCard
                                                   success:^(id responseObject) {
                                                       NSString *result = [responseObject objectForKey:@"result"];
                                                       if (result.integerValue) {
                                                           oldgetbankMessageCodeBtn.enabled = NO;
                                                           oldSmsCodeTime = 60;
                                                           [oldgetbankMessageCodeBtn setTitle:@"60秒后再获取" forState:UIControlStateNormal];
                                                           oldSmsCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeoutWithSmsCode:) userInfo:nil repeats:YES];
                                                       }else
                                                       {
                                                           [CMMUtility showSuccessMessage:[responseObject objectForKey:@"message"]];
                                                       }
                                                   } failure:^(NSError *error) {
                                                       [CMMUtility showNoteWithError:error];
                                                   }];
}

- (void)clickGetNewBankMessageCode
{
    if (QM_IS_STR_NIL([self getBankCardNumber])
        || QM_IS_STR_NIL([self getPhoneString]))
    {
        [CMMUtility showNote:@"请输入新银行卡账号和预留手机号"];
        return;
    }
    
    [[NetServiceManager sharedInstance] getBankMessageCode:self
                                                BankCardID:[self getBankCardNumber]
                                                    Mobile:[self getPhoneString]
                                                   SmsType:RebindBankMessageTypeNewCard
                                                   success:^(id responseObject) {
                                                       NSString *result = [responseObject objectForKey:@"result"];
                                                       if (result.integerValue) {
                                                           newgetbankMessageCodeBtn.enabled = NO;
                                                           newSmsCodeTime = 60;
                                                           [newgetbankMessageCodeBtn setTitle:@"60秒后再获取" forState:UIControlStateNormal];
                                                           newSmsCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeoutWithSmsCode:) userInfo:nil repeats:YES];
                                                       }else
                                                       {
                                                           [CMMUtility showSuccessMessage:[responseObject objectForKey:@"message"]];
                                                       }
                                                   } failure:^(NSError *error) {
                                                       [CMMUtility showNoteWithError:error];
                                                   }];
}

- (void)timeoutWithSmsCode:(NSTimer *)timer
{
    if (timer == oldSmsCodeTimer) {
        oldSmsCodeTime--;
        if (oldSmsCodeTime == 0) {
            oldgetbankMessageCodeBtn.enabled = YES;
            [oldgetbankMessageCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [oldSmsCodeTimer invalidate];
        }else
        {
            [oldgetbankMessageCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒后再获取",oldSmsCodeTime] forState:UIControlStateNormal];
        }
    }else if(timer == newSmsCodeTimer)
    {
        newSmsCodeTime--;
        if (newSmsCodeTime == 0) {
            newgetbankMessageCodeBtn.enabled = YES;
            [newgetbankMessageCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [newSmsCodeTimer invalidate];
        }else
        {
            [newgetbankMessageCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒后再获取",newSmsCodeTime] forState:UIControlStateNormal];
        }
    }
}

- (BOOL)isIDCardValid {
    NSString *idCard = [idCardField text];
    
    if (_haveDefaultMessage) {
        return YES;
    }
    
    BOOL result = [CMMUtility checkIdNumber:idCard] && [self getPhoneString].length == 11;
    
    return result;
}

- (void)identifyBtnClicked:(UIButton *)btn {
    // 验证身份证和手机号码是否合法
    btn.enabled = NO;
    if (_isOpenAccount)
    {
        if ([self isIDCardValid]) {
            // 请求服务器接口
            [self checkUserValidatebtn:btn];
        }else {
            // 身份证号码或手机号码不合法
            [CMMUtility showNote:QMLocalizedString(@"qm_idcard_number_invalid", @"身份证号码或手机号码不合法")];
            btn.enabled = YES;
        }
    }
    else
    {
        [self checkUserValidatebtn:btn];
    }
}

- (void)checkUserValidatebtn:(UIButton *)btn
{
    if (_isOpenAccount == YES)
    {
        if (QM_IS_STR_NIL([self getIdCardString])
            || QM_IS_STR_NIL([self getNameString])
            || QM_IS_STR_NIL([self getBankCardNumber])
            || QM_IS_STR_NIL(currentBankInfo.bankCode)
            || QM_IS_STR_NIL(provinceItem.itemCode)
            || QM_IS_STR_NIL([self getCityString])
            || QM_IS_STR_NIL([self getPhoneString])
            )
        {
            [CMMUtility showNote:@"请完善资料"];
            return;
        }
        [[NetServiceManager sharedInstance] PersonOpenAccount:self
                                                     RealName:[self getNameString]
                                                       IdCard:[self getIdCardString]
                                                   BankCardID:[self getBankCardNumber]
                                                       Mobile:[self getPhoneString]
                                                     BankCode:currentBankInfo.bankCode
                                                 ProvinceCode:[self getProvinceCode]
                                                     CityCode:[self getCityCode]
                                                      success:^(id responseObject)
        {
            [self handleResponseSuccess:responseObject];
        } failure:^(NSError *error) {
            [self handleResponseFailure:error];
        }];
    }else if (_isActivationAccount == YES)
    {
        if (QM_IS_STR_NIL([self getBankCardNumber])
            || QM_IS_STR_NIL([self getBankCardNumber])
            || QM_IS_STR_NIL(provinceItem.itemCode)
            || QM_IS_STR_NIL([self getCityString])
            || QM_IS_STR_NIL([self getPhoneString])
            )
        {
            [CMMUtility showNote:@"请完善资料"];
            return;
        }
        [[NetServiceManager sharedInstance] PersonActivationAccount:self
                                                         BankCardID:[self getBankCardNumber]
                                                             Mobile:[self getPhoneString]
                                                           BankCode:currentBankInfo.bankCode
                                                       ProvinceCode:[self getProvinceCode]
                                                           CityCode:[self getCityCode]
                                                            success:^(id responseObject)
         {
            [self handleResponseSuccess:responseObject];
        } failure:^(NSError *error) {
            [self handleResponseFailure:error];
        }];
        
    }else if (_isChangeBandCard == YES)
    {
        if (QM_IS_STR_NIL([self getOldBankCardNumber])
            || QM_IS_STR_NIL([self getOldPhoneString])
            || QM_IS_STR_NIL([self getBankCardNumber])
            || QM_IS_STR_NIL([self getPhoneString])
            || QM_IS_STR_NIL(currentBankInfo.bankCode)
            || QM_IS_STR_NIL(provinceItem.itemCode)
            || QM_IS_STR_NIL([self getCityString])
            || QM_IS_STR_NIL([self getOldBankMessageCode])
            || QM_IS_STR_NIL([self getNewBankMessageCode])
            )
        {
            [CMMUtility showNote:@"请完善资料"];
            return;
        }
        [[NetServiceManager sharedInstance] PersonChangeBankCard:self
                                                   OldBankCardID:[self getOldBankCardNumber]
                                                       OldMobile:[self getOldPhoneString]
                                                      OldSmsCode:[self getOldBankMessageCode]
                                                   NewBankCardID:[self getBankCardNumber]
                                                       NewMobile:[self getPhoneString]
                                                      NewSmsCode:[self getNewBankMessageCode]
                                                        BankCode:currentBankInfo.bankCode
                                                    ProvinceCode:provinceItem.itemCode
                                                        CityCode:[self getCityCode]
                                                         success:^(id responseObject)
        {
            [self handleResponseSuccess:responseObject];
        } failure:^(NSError *error) {
            [self handleResponseFailure:error];
        }];
    }
}

- (void)handleResponseSuccess:(id)response {
    showWebNow = YES;
    identifyBtn.enabled = YES;
    responWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    responWebView.delegate = self;
    [self.view addSubview:responWebView];
    [responWebView loadHTMLString:response baseURL:[NSURL URLWithString:URL_BASE]];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [[request URL] absoluteString];
    NSLog(@"%@",url);
    if ([url rangeOfString:[NSString stringWithFormat:@"/wap/myaccount"]].location != NSNotFound) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

- (void)handleResponseFailure:(NSError *)error {
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
             [self updateNextBtnState];
        }else if (con.currentType == QMSelectLocationTypeV2_City) {
            // 更新城市信息
            cityitem = item;
            [selectCityBtn setTitle:item.itemTitle forState:UIControlStateNormal];
             [self updateNextBtnState];
        }
        
    }else if ([controller isKindOfClass:[QMAddBankViewController class]]) {
        QMBankInfo *info = (QMBankInfo *)item;
        if ([info isKindOfClass:[QMBankInfo class]]) {
            currentBankInfo = info;
            [selectBankBtn setTitle:currentBankInfo.bankName forState:UIControlStateNormal];
             [self updateNextBtnState];
        }
    }
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    if (_isOpenAccount == YES) {
        return @"用户开户";
    }else if (_isActivationAccount == YES)
    {
        return @"个人用户激活";
    }
    else if (_isChangeBandCard == YES)
    {
        return @"银行卡换绑";
    }
    return QMLocalizedString(@"qm_identify_nav_title", @"身份信息确认");
}

@end
