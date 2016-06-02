//
//  QMSelectBankViewController.m
//  MotherMoney
//

#import "QMSelectBankViewController.h"
#import "QMAddBankCardViewController.h"
#import "QMConfirmBuyProductViewController.h"
#import "QMAddBankCardViewControllerV2.h"
#import "QMBankCardModel.h"

@interface QMSelectBankViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation QMSelectBankViewController {
    NSMutableArray *userCardListData;
    QMOrderModel *currentOrderModel;
    UIPickerView *pickerView;
    QMBankCardModel *selectedCard;
    
    UITextField *bankTextField;
    UIButton *nextStepBtn;
}

- (id)initViewControllerWithOrder:(QMOrderModel *)model {
    if (self = [super init]) {
        currentOrderModel = model;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    userCardListData = [[NSMutableArray alloc] initWithCapacity:0];
    // Do any additional setup after loading the view.
    [self customSubViews];
}

- (void)customSubViews {
    pickerView = [[UIPickerView alloc] init];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    bankTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 20, CGRectGetWidth(self.view.frame) - 2 * 15, 40)];
    bankTextField.textColor = QM_COMMON_TEXT_COLOR;
    bankTextField.inputView = pickerView;
    [bankTextField setBackground:[QMImageFactory commonTextFieldImage]];
    bankTextField.font = [UIFont systemFontOfSize:13];
    bankTextField.placeholder = QMLocalizedString(@"qm_select_bank_title", @"请选择银行");
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(bankTextField.frame))];
    bankTextField.leftView = leftView;
    bankTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:bankTextField];
    
    nextStepBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(bankTextField.frame), 44) title:QMLocalizedString(@"qm_next_action_btn_title", @"下一步") target:self selector:@selector(nextStepBtnClicked:)];
    CGRect frame = nextStepBtn.frame;
    frame.origin = CGPointMake(CGRectGetMinX(bankTextField.frame), CGRectGetMaxY(bankTextField.frame) + 20);
    nextStepBtn.frame = frame;
    nextStepBtn.enabled = NO;
    [self.view addSubview:nextStepBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadBankInfoData];
}

- (void)nextStepBtnClicked:(id)sender {
    currentOrderModel.bankCardNumber = selectedCard.bankId;
    QMConfirmBuyProductViewController *con = [[QMConfirmBuyProductViewController alloc] initViewControllerWithProductOrder:currentOrderModel];
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark - PickView

-(void)loadBankInfoData {
    [[NetServiceManager sharedInstance] getMyBankCardWithProductId:currentOrderModel.productId
                                                          delegate:self
                                                           success:^(id responseObject) {
                                                               if (![responseObject isKindOfClass:[NSDictionary class]]) {
                                                                   return;
                                                               }
                                                               
                                                               NSArray *cardList = [responseObject objectForKey:kNetWorkList];
                                                               if (cardList && [cardList isKindOfClass:[NSArray class]]) {
                                                                   [userCardListData removeAllObjects];
                                                                   
                                                                   // 选择银行
                                                                   QMBankCardModel *select = [[QMBankCardModel alloc] init];
                                                                   select.bankName = QMLocalizedString(@"qm_select_bank_title", @"请选择银行");
                                                                   [userCardListData addObject:select];
                                                                   
                                                                   for (NSDictionary *dict in cardList) {
                                                                       QMBankCardModel *model = [[QMBankCardModel alloc] initWithDictionary:dict];
                                                                       
                                                                       [userCardListData addObject:model];
                                                                   }
                                                                   
                                                                   // 添加银行
                                                                   QMBankCardModel *add = [[QMBankCardModel alloc] init];
                                                                   add.bankName = QMLocalizedString(@"qm_add_new_bank_title", @"请添加银行");
                                                                   [userCardListData addObject:add];
                                                                   
                                                                   [pickerView reloadAllComponents];
                                                               }
                                                           } failure:^(NSError *error) {
//                                                               [CMMUtility showNote:@"银行信息加载失败"];
                                                               [CMMUtility showNoteWithError:error];
                                                           }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return userCardListData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    QMBankCardModel *model = [userCardListData objectAtIndex:row];
    
    NSString *bankName = model.bankName;
    NSString *cardNumber = model.bankCardNumber;
    
    if ([cardNumber length] >= 4) {
        cardNumber = [cardNumber substringFromIndex:cardNumber.length - 4];
        NSString *noteStr = [NSString stringWithFormat:QMLocalizedString(@"qm_bank_card_tail_text", @"(尾号为%@)"),cardNumber];
        NSString *contentStr = [NSString stringWithFormat:@"%@%@",bankName,noteStr];
        
        return contentStr;
    }else {
        return bankName;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    /*
     *判断数组的返回值
     */
    if (QM_IS_ARRAY_NIL(userCardListData)) {
        return;
    }
    
    nextStepBtn.enabled = NO;
    QMBankCardModel *model = [userCardListData objectAtIndex:row];
    if (row == 0) {
        //
        selectedCard = nil;
        bankTextField.text = nil;
    }else if (row == [userCardListData count] - 1) {
        selectedCard = nil;
        
        QMAddBankCardViewController *con = [[QMAddBankCardViewController alloc] initViewControllerWithOrder:currentOrderModel];
        con.isModel = YES;
        QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else{
        nextStepBtn.enabled = YES;
        selectedCard = model;
        
        NSString *bankName = model.bankName;
        NSString *cardNumber = model.bankCardNumber;
        NSString *showText = bankName;
        if (!QM_IS_STR_NIL(cardNumber)) {
            cardNumber = [cardNumber substringFromIndex:cardNumber.length - 4];
            NSString *noteStr = [NSString stringWithFormat:QMLocalizedString(@"qm_bank_card_tail_text", @"(尾号为%@)"),cardNumber];
            NSString *contentStr = [NSString stringWithFormat:@"%@%@",bankName,noteStr];
            
            showText = contentStr;
        }
        
        bankTextField.text = showText;
    }
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_select_bank_title", @"请选择银行");
}

@end
