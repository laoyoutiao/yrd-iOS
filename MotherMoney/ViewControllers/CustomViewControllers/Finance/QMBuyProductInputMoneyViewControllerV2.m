//
//  QMBuyProductInputMoneyViewControllerV2.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/17.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMBuyProductInputMoneyViewControllerV2.h"
#import "QMCreditorsInfo.h"
#import "QMSingleLineCollectionCell.h"
#import "QMTwoLineCollectionCell.h"
#import "QMTextFieldCollectionCell.h"
#import "QMBuyProductBottomView.h"
#import "QMSelectBankViewController.h"
#import "QMConfirmBuyProductViewController.h"
#import "QMAlertView.h"
#import "QMConfirmPayPwdViewController.h"
#import "QMProductBuyResultViewController.h"
#import "QMAccountOpViewController.h"
#import "QMRechargeViewController.h"
#import "QMCouponViewController.h"
#import "QMProductCouponViewController.h"
#import "NetServiceManager.h"
#define QMSINGLELINECOLLECTIONCELLIDENTIFIER1 @"qmsinglelinecollectioncellidentifier"
#define QMTWOLINECOLLECTIONCELLIDENTIFIER1 @"qmtwolinecollectioncellidentifier"
#define QMTEXTFIELDCOLLECTIONCELLIDENTIFIER1 @"qmtextfieldcollectioncellIdentifier"

#define QMSECTIONFOOTERVIEWIDENTIFIER @"qmsectionfooterviewIdentifier"

@interface QMBuyProductInputMoneyViewControllerV2 ()<UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, QMAlertViewDelegate, QMConfirmPayPwdViewControllerDelegate,QMProductCouponViewControllerDelegate,UIWebViewDelegate>
@property (nonatomic, strong) QMAlertView *payAlertView;
@property (nonatomic, strong)QMProductCouponViewController *couponView;

@end

@implementation QMBuyProductInputMoneyViewControllerV2 {
    UICollectionView *myCollectionView;
    QMProductInfo *myProductInfo;
    QMCreditorsInfo *myCreditorsInfo;
    NSInteger rateMoney;
    
    QMOrderModel *myOrderModel;
    BOOL hasSetPayPassword;
    double available;
    double buyMoney;
    int buyNumber;
    NSNumber *userDjqTicketCount;
    QMBuyProductBottomView *footer;
    BOOL isProduct;
}

- (id)initViewControllerWithProductInfo:(QMProductInfo *)info {
    if (self = [super init]) {
        myProductInfo = info;
        //?????????????
        rateMoney = [info.baseAmount integerValue];
        isProduct = YES;
        
            }
    
    return self;
}

- (id)initViewControllerWithCreditorsInfo:(QMCreditorsInfo *)info {
    if (self = [super init]) {
        myCreditorsInfo = info;
        //?????????????
        rateMoney = [info.baseAmount integerValue];
        isProduct = NO;
    }
    
    return self;
}

- (void)userSelectedWithName:(NSString *)name value:(double)value useCode:(NSString *)useCode useLimit:(double)useLimit{
    QMTextFieldCollectionCell *cell = (QMTextFieldCollectionCell *)[myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    
    buyNumber =[cell.textField.text intValue];
    self.useCode = useCode;
    self.couponName = name;
    _value = value;
    self.useLimit = useLimit;
    [self getBuyMoney];
    [myCollectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    rateMoney = isProduct? [myProductInfo.baseAmount integerValue]:[myCreditorsInfo.baseAmount integerValue];
    
    self.payAlertView = [[QMAlertView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 180)];
    self.payAlertView.delegate = self;

    [self setUpCollectionView];
}
- (void)handleTextChangeNotification:(NSNotification *)noti{
    
        QMTextFieldCollectionCell *cell = (QMTextFieldCollectionCell *)[myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    buyNumber = [cell.textField.text doubleValue];
    if (isProduct) {
        if (buyNumber>[myProductInfo.remainingAmount doubleValue]) {
            [CMMUtility showNote:[NSString stringWithFormat:@"最多购买%@份",myProductInfo.remainingAmount]];
            cell.textField.text = myProductInfo.remainingAmount;
            buyNumber=[myProductInfo.remainingAmount doubleValue];
        }
    }else
    {
        if (buyNumber>[myCreditorsInfo.remainingNum doubleValue]) {
            [CMMUtility showNote:[NSString stringWithFormat:@"最多购买%@份",myCreditorsInfo.remainingNum]];
            cell.textField.text = myCreditorsInfo.remainingNum;
            buyNumber=[myCreditorsInfo.remainingNum doubleValue];
        }
    }
//    [self updateBuyNumberPromptForNumber:cell.textField.text value:_value];
    [self getBuyMoney];
}
//- (void)updateBuyNumberPromptForNumber:(NSString *)number value:(double)value{
//    buyNumber = [number doubleValue];
//    if (buyNumber>[myProductInfo.remainingAmount doubleValue]) {
//        buyNumber=[myProductInfo.remainingAmount doubleValue];
//    }
//    
//    
//}
- (void)getBuyMoney{

    if (isProduct) {
        buyMoney = buyNumber *[myProductInfo.baseAmount doubleValue]-_value;
    }else
    {
        buyMoney = buyNumber *[myCreditorsInfo.baseAmount doubleValue]-_value;
    }
    if (buyMoney>=0) {
        
        footer.money.hidden=NO;

        
    }else{
    
        footer.money.hidden=YES;
    }
    footer.money.text = [NSString stringWithFormat:@"实付金额%.2f元",buyMoney];
    
    
    

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerKeybaordNotification];
    
    // 获取剩余金额及代金券
//    [[NetServiceManager sharedInstance] getAvailableMoneyWithDelegate:self success:^(id responseObject) {
//        if (!QM_IS_DICT_NIL(responseObject)) {
    
//            
//            
//        }
//        
//        [myCollectionView reloadData];
//    } failure:^(NSError *error) {
//        [CMMUtility showNoteWithError:error];
//    }];

    if (isProduct) {
        [[NetServiceManager sharedInstance] getBuyProductDetailWithProductId:myProductInfo.product_id ChannelId:@"2" delegate:self success:^(id responseObject) {
            
            available = [[responseObject objectForKey:@"available"] doubleValue];
            userDjqTicketCount = [responseObject objectForKey:@"userDjqTicketCount"];
            
            [myCollectionView reloadData];
        } failure:^(NSError *error) {
            [CMMUtility showNoteWithError:error];
        }];
    }else
    {
        [[NetServiceManager sharedInstance] getBuyProductDetailWithProductId:myCreditorsInfo.product_id_real ChannelId:@"2" delegate:self success:^(id responseObject) {
            
            available = [[responseObject objectForKey:@"available"] doubleValue];
            userDjqTicketCount = [responseObject objectForKey:@"userDjqTicketCount"];
            
            [myCollectionView reloadData];
        } failure:^(NSError *error) {
            [CMMUtility showNoteWithError:error];
        }];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.payAlertView dismiss];
    [self unRegisterKeyboardNotification];
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    
    myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    myCollectionView.alwaysBounceVertical = YES;
    [myCollectionView registerClass:[QMSingleLineCollectionCell class] forCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER1];
    [myCollectionView registerClass:[QMTwoLineCollectionCell class] forCellWithReuseIdentifier:QMTWOLINECOLLECTIONCELLIDENTIFIER1];
    [myCollectionView registerClass:[QMTextFieldCollectionCell class] forCellWithReuseIdentifier:QMTEXTFIELDCOLLECTIONCELLIDENTIFIER1];
    [myCollectionView registerClass:[QMBuyProductBottomView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:QMSECTIONFOOTERVIEWIDENTIFIER];
    
    myCollectionView.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    myCollectionView.dataSource = self;
    myCollectionView.delegate = self;
    [self.view addSubview:myCollectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSLog(@"%@",self.couponName);
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            QMTwoLineCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMTWOLINECOLLECTIONCELLIDENTIFIER1 forIndexPath:indexPath];
            UIImageView *backgroundView = (UIImageView *)cell.backgroundView;
            backgroundView.image = [QMImageFactory commonBackgroundImageTopPart];
            
            cell.textLabel.text = isProduct? myProductInfo.productName:myCreditorsInfo.productName;
            cell.detailTextLabel.text = @"";
            
            return cell;
        }else {
            QMSingleLineCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER1 forIndexPath:indexPath];
            cell.textLabel.highlightedTextColor = QM_COMMON_TEXT_COLOR;
            UIImageView *backgroundView = (UIImageView *)cell.backgroundView;
            backgroundView.image = [QMImageFactory commonBackgroundImageCenterPart];
            
            UIImageView *selectedBackgroundView = (UIImageView *)cell.selectedBackgroundView;
            selectedBackgroundView.image = nil;
            cell.horizontalLine.hidden = NO;
            cell.indicatorView.hidden = YES;
            cell.detailLabel.text = @"";
            cell.detailLabel.hidden = YES;
            if (indexPath.row == 1) {
                cell.textLabel.text = [NSString stringWithFormat:QMLocalizedString(@"qm_min_copy_format", @"起购份额:%d份"),  isProduct ?[myProductInfo.minAmount integerValue]:1];
            }else if (indexPath.row == 2) {
                cell.textLabel.text = [NSString stringWithFormat:@"每份金额:%@元", [CMMUtility formatterNumberWithComma: isProduct? myProductInfo.baseAmount:myCreditorsInfo.baseAmount]];
            }
            else if (indexPath.row == 3) {
                cell.textLabel.text = [NSString stringWithFormat:QMLocalizedString(@"qm_remaining_copy_format", @"剩余份额:%d份"), [myProductInfo.remainingAmount integerValue]];
            }else if (indexPath.row == 4) {
                cell.textLabel.text = @"手续费:无";
            }else if (indexPath.row == 5) {
                cell.textLabel.text = [NSString stringWithFormat:QMLocalizedString(@"qm_product_infO_page_investmentPeriod_format", @"理财期限:%@"), isProduct? myProductInfo.maturityDuration:myCreditorsInfo.maturity_duration];
                backgroundView.image = [QMImageFactory commonBackgroundImageCenterPart];
            }else if (indexPath.row == 6) {

                cell.textLabel.text = [NSString stringWithFormat:@"可用余额:%@元", [CMMUtility formatterNumberWithComma:[NSNumber numberWithDouble:available]]];

                selectedBackgroundView.image = [QMImageFactory commonBackgroundImageBottomPartPressed];
                backgroundView.image = [QMImageFactory commonBackgroundImageBottomPart];
                cell.textLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
                cell.horizontalLine.hidden = YES;
                cell.indicatorView.hidden = NO;
                cell.detailLabel.hidden = NO;
                cell.detailLabel.font = [UIFont systemFontOfSize:12.0f];
                cell.detailLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
                cell.detailLabel.text = @"点击充值";
            }else if (indexPath.row == 7) {

                cell.textLabel.text = [NSString stringWithFormat:@"使用礼券"];
                selectedBackgroundView.image = [QMImageFactory commonBackgroundImageBottomPartPressed];
                backgroundView.image = [QMImageFactory commonBackgroundImageBottomPart];
                cell.textLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
                cell.horizontalLine.hidden = YES;
                cell.indicatorView.hidden = NO;
                cell.detailLabel.hidden = NO;
                cell.detailLabel.font = [UIFont systemFontOfSize:12.0f];
                cell.detailLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
                if (self.couponName==nil) {
                    cell.detailLabel.text= [NSString stringWithFormat:@"%@张可用",userDjqTicketCount];
                }else{
                cell.detailLabel.text = self.couponName;
                }
                
            }
            
            return cell;
        }
    }else if (indexPath.section == 1) {
        QMTextFieldCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMTEXTFIELDCOLLECTIONCELLIDENTIFIER1 forIndexPath:indexPath];
        UIImageView *backgroundView = (UIImageView *)cell.backgroundView;
        backgroundView.image = [QMImageFactory commonBackgroundImage];
        cell.textField.placeholder = QMLocalizedString(@"qm_product_buy_copy_placeholder", @"购买份额");
        
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.delegate = self;
        
        
        return cell;
    }
    
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    if (section == 0) {
        
        
        
        return 8;
    }else if (section == 1) {
        
        
        
        return 1;
        
        
        
    }
    
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 8, 44);
        }else {
            return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 8, 44);
        }
    }else if(indexPath.section == 1) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 8, 44);
    }
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if (section == 0) {
        insets = UIEdgeInsetsMake(8, 8, 0, 8);
    }else if (section == 1) {
        insets = UIEdgeInsetsMake(4, 8, 8, 8);
    }
    
    return insets;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==  1) {
        footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:QMSECTIONFOOTERVIEWIDENTIFIER forIndexPath:indexPath];
        
        // TODO ZGH
        if (isProduct) {
            footer.infoLabel.text = [NSString stringWithFormat:QMLocalizedString(@"qm_product_rate_copy_format", @"起购份额:%@份,每份%@元"), myProductInfo.minAmount, myProductInfo.baseAmount];
        }else
        {
            footer.infoLabel.text = [NSString stringWithFormat:QMLocalizedString(@"qm_product_rate_copy_format", @"起购份额:%@份,每份%@元"), @"1", myCreditorsInfo.baseAmount];
        }
//        footer.money.hidden = YES;
        [footer.actionBtn addTarget:self action:@selector(nextStepBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [footer.actionBtn setTitle:@"确认申购" forState:UIControlStateNormal];
        
        return footer;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 1) {
        // 最后一个
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 200);
    }else {
        return CGSizeZero;
    }
}

#pragma mark -
#pragma mark keyboard notification
- (void)handleKeyboardWillShowNotification:(NSNotification *)noti {
    CGRect endRect = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIEdgeInsets insets = myCollectionView.contentInset;
    insets.bottom = CGRectGetHeight(endRect);
    myCollectionView.contentInset = insets;
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)noti {
    UIEdgeInsets insets = myCollectionView.contentInset;
    insets.bottom = 0;
    
    myCollectionView.contentInset = insets;
}

- (void)nextStepBtnClicked:(UIButton *)btn {
    QMTextFieldCollectionCell *cell = (QMTextFieldCollectionCell *)[myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    NSString *moneyText = cell.textField.text;
    NSInteger money = [moneyText integerValue];
    if (isProduct)
    {
        if (money <= 0) {
            
            [CMMUtility showNote:@"请输入购买份额"];
            
            return;
        }else if (money < [myProductInfo.minAmount integerValue]) { // 购买份额太小了
            [CMMUtility showNote:[NSString stringWithFormat:@"您至少要购买%@份", [NSNumber numberWithInteger:[myProductInfo.minAmount integerValue]]]];
            
            return;
        }else if (money > [myProductInfo.remainingAmount integerValue]) {
            [CMMUtility showNote:[NSString stringWithFormat:@"您当前最多只能购买:%@份", myProductInfo.remainingAmount]];
            return;
        }
        if (buyMoney+_value<self.useLimit&&self.value>0) {
            [CMMUtility showNote:[NSString stringWithFormat:@"当前购买金额不足以使用礼券"]];
            return;
        }
    }else
    {
        if (money <= 0) {
            
            [CMMUtility showNote:@"请输入购买份额"];
            
            return;
        }else if (money < 1) { // 购买份额太小了
            [CMMUtility showNote:[NSString stringWithFormat:@"您至少要购买%@份", [NSNumber numberWithInteger:1]]];
            
            return;
        }else if (money > [myCreditorsInfo.remainingNum integerValue]) {
            [CMMUtility showNote:[NSString stringWithFormat:@"您当前最多只能购买:%@份", myCreditorsInfo.remainingNum]];
            return;
        }
        if (buyMoney+_value<self.useLimit&&self.value>0) {
            [CMMUtility showNote:[NSString stringWithFormat:@"当前购买金额不足以使用礼券"]];
            return;
        }
    }
    
    // 提示用户购买金额
//    buyMoney = money * [myProductInfo.baseAmount doubleValue];
    NSString *message = [NSString stringWithFormat:@"需要支付金额:%@元，确定购买?", [CMMUtility formatterNumberWithComma:[NSNumber numberWithDouble:buyMoney]]];
    
    
    
    
    PSTAlertController *promptController = [PSTAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:PSTAlertControllerStyleAlert];
    [promptController addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleCancel handler:^(PSTAlertAction *action) {
        
    }]];
    
    [promptController addAction:[PSTAlertAction actionWithTitle:@"确定" style:PSTAlertActionStyleDefault handler:^(PSTAlertAction *action) {
        // 确定购买，检查余额
        if (available < buyMoney) { // 余额不足，进入充值页面
            NSString *alertMsg = [NSString stringWithFormat:@"您当前帐户余额不足，前去充值?"];
            PSTAlertController *controller = [PSTAlertController alertControllerWithTitle:@"提示" message:alertMsg preferredStyle:PSTAlertControllerStyleAlert];
            [controller addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleCancel handler:^(PSTAlertAction *action) {
                
            }]];
            
            [controller addAction:[PSTAlertAction actionWithTitle:@"确定" style:PSTAlertActionStyleDefault handler:^(PSTAlertAction *action) {
                // 进入余额页面进行充值
                [self gotoAmountViewController];
            }]];
            
            [controller showWithSender:nil controller:self animated:YES completion:nil];
        }else { // 余额充足，输入支付密码进行购买
            // 执行购买操作
            myOrderModel = [[QMOrderModel alloc] init];
            if (isProduct)
            {
                myOrderModel.productId = myProductInfo.product_id;
                myOrderModel.productName = myProductInfo.productName;
                myOrderModel.productChannelId = myProductInfo.productChannelId;
            }else
            {
                myOrderModel.productId = myCreditorsInfo.product_id_real;
                myOrderModel.productName = myCreditorsInfo.productName;
                myOrderModel.productChannelId = myCreditorsInfo.productChannelId;
            }
            //代金券界面的申购价格
//            NSInteger piece = money-_value;
//            double baseAmount = [myProductInfo.baseAmount doubleValue];
            myOrderModel.amount = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:buyMoney]];
            
            // 首先检查是否设置过支付密码
            [self showPayPassword:YES];
        }
    }]];
    [promptController showWithSender:nil controller:self animated:YES completion:^{
        
    }];
}

// 显示设置支付密码页面
- (void)showPayPassword:(BOOL)hasSet {
    hasSetPayPassword = hasSet;
    
    [self.payAlertView clearTextField];
    [self.payAlertView show];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.item == 6) {
        //进入充值页面
        [self gotoAmountViewController];
    }else if (indexPath.item==7){
        [self gotoCouponViewController];
    }
    
}
//代金券界面
- (void)gotoCouponViewController{
    QMProductCouponViewController *con = [[QMProductCouponViewController alloc] init];
    con.delegate = self;
    con.productId = isProduct? myProductInfo.product_id:myCreditorsInfo.product_id_real;
    con.ticketCode = self.useCode;
//    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:con animated:YES];
}
//充值界面
- (void)gotoAmountViewController {
//    QMAccountOpViewController *con = [[QMAccountOpViewController alloc] init];
//    [self.navigationController pushViewController:con animated:YES];
    QMRechargeViewController *con = [[QMRechargeViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)registerKeybaordNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    

}

- (void)unRegisterKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc {
    [self unRegisterKeyboardNotification];
}

#pragma mark ----XSAlertViewDelegate
-(void)alertForgetPwd {
    [self.payAlertView dismiss];
    
    [self gotoModifyPayPasswordViewController];
}

-(void)alertConfirmCheckWithPwd:(NSString *)pwd {
    NSString *productId = myOrderModel.productId;
    
    QMTextFieldCollectionCell *cell = (QMTextFieldCollectionCell *)[myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    NSString *amount = [cell.textField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *bankCardNumber = myOrderModel.bankCardNumber;
    pwd = self.payAlertView.payTextField.text;
    
    if (QM_IS_STR_NIL(productId) || QM_IS_STR_NIL(amount) || QM_IS_STR_NIL(pwd)) {
        return;
    }
    
    [self.payAlertView dismiss];
    
//    [[NetServiceManager sharedInstance] buyProductWithProductId:productId
//                                                         amount:amount
//                                                 bankCardNumber:bankCardNumber
//                                                    payPassword:pwd
//                                                       delegate:self
//                                                        success:^(id responseObject) {
//                                                            // 打点
//                                                            [QMUMTookKitManager event:USER_BUY_SUCCESS_KEY label:@"用户购买成功"];
//                                                            
//                                                            // 购买成功
//                                                            [SVProgressHUD showSuccessWithStatus:QMLocalizedString(@"qm_buy_produt_success", @"购买成功")];
//                                                            
//                                                            QMProductBuyResultViewController *con = [[QMProductBuyResultViewController alloc] initViewControllerWithOrder:myOrderModel result:nil];
//                                                            
//                                                            [self.navigationController pushViewController:con animated:YES];
//                                                        } failure:^(NSError *error) {
//                                                            // 购买失败
//                                                            [SVProgressHUD showErrorWithStatus:QMLocalizedString(@"qm_buy_produt_failure", @"购买失败")];
//                                                            
//                                                            // 产品购买失败
//                                                            QMProductBuyResultViewController *con = [[QMProductBuyResultViewController alloc] initViewControllerWithOrder:myOrderModel result:error];
//                                                            [self.navigationController pushViewController:con animated:YES];
//}];
//    NSLog(@"--------%@---------",productId);
//    NSLog(@"----------%@---------",pwd);
//    NSLog(@"----------%@--------",amount);
//    NSLog(@"------------%@---------",self.useCode);
    
    
    
    [[NetServiceManager sharedInstance] getButTicketwithProductId:productId share:[amount integerValue] payPassword:pwd ticketCode:self.useCode delegate:self success:^(id responseObject){
        
        UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
        webview.delegate = self;
        [self.view addSubview:webview];
        [webview loadHTMLString:responseObject baseURL:[NSURL URLWithString:URL_BASE]];
        
//        [QMUMTookKitManager event:USER_BUY_SUCCESS_KEY label:@"用户购买成功"];
//        
//        // 购买成功
//        [SVProgressHUD showSuccessWithStatus:QMLocalizedString(@"qm_buy_produt_success", @"购买成功")];
//        
//        QMProductBuyResultViewController *con = [[QMProductBuyResultViewController alloc] initViewControllerWithOrder:myOrderModel result:nil];
//        
//        [self.navigationController pushViewController:con animated:YES];

    } failure:^(NSError *error) {
        
//        [SVProgressHUD showErrorWithStatus:QMLocalizedString(@"qm_buy_produt_failure", @"购买失败")];
//        
//        // 产品购买失败
//        QMProductBuyResultViewController *con = [[QMProductBuyResultViewController alloc] initViewControllerWithOrder:myOrderModel result:error];
//        [self.navigationController pushViewController:con animated:YES];

    }];
    
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

// 重置支付密码
- (void)gotoModifyPayPasswordViewController {
    QMConfirmPayPwdViewController *con = [[QMConfirmPayPwdViewController alloc] init];
    con.isModel = YES;
    con.delegate = self;
    
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [nav updateNavigationBarBgWithCurrentBackgroundImage];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark -
#pragma mark QMConfirmPayPwdViewControllerDelegate
- (void)confirmPayPwdViewControllerDidResetPayPasswordSuccess:(QMConfirmPayPwdViewController *)controller {
    if (controller.isModel) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popToViewController:self animated:YES];
    }
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return @"申购";
}

@end

