//
//  QMConfirmBuyProductViewController.m
//  MotherMoney

#import "QMConfirmBuyProductViewController.h"
#import "QMSingleLineCollectionCell.h"
#import "QMBuyProductFooterView.h"
#import "QMConfirmPayPwdViewController.h"
#import "QMProductBuyResultViewController.h"
#import "LLViewController.h"
#import "QMWebViewController3.h"

#define COLLECTION_VIEW_CELL_IDENTITIER @"COLLECTION_VIEW_CELL_IDENTITIER"
#define COLLECTION_VIEW_FOOTER_IDENTITIER @"COLLECTION_VIEW_FOOTER_IDENTITIER"

@interface QMConfirmBuyProductViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, QMBuyProductFooterViewDelegate, QMAlertViewDelegate, QMConfirmPayPwdViewControllerDelegate>

@end

@implementation QMConfirmBuyProductViewController {
    UICollectionView *myCollectionView;
    QMOrderModel *myOrderModel;
    BOOL hasSetPayPassword;
}

- (id)initViewControllerWithProductOrder:(QMOrderModel *)model {
    if (self = [super init]) {
        myOrderModel = model;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSubViews];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.payAlertView dismiss];
}

- (void)setUpSubViews {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    myCollectionView.alwaysBounceVertical = YES;
    [myCollectionView registerClass:[QMSingleLineCollectionCell class] forCellWithReuseIdentifier:COLLECTION_VIEW_CELL_IDENTITIER];
    [myCollectionView registerClass:[QMBuyProductFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:COLLECTION_VIEW_FOOTER_IDENTITIER];
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    myCollectionView.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [self.view addSubview:myCollectionView];
    
    self.payAlertView = [[QMAlertView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 180)];
    self.payAlertView.delegate = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMSingleLineCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION_VIEW_CELL_IDENTITIER forIndexPath:indexPath];
    cell.detailLabel.hidden = YES;
    if (indexPath.row == 0) {
        cell.textLabel.text = myOrderModel.productName;
        cell.horizontalLine.hidden = NO;
        ((UIImageView *)cell.backgroundView).image = [QMImageFactory commonBackgroundImageTopPart];
    }else if (indexPath.row == 1) {
        cell.textLabel.text = QMLocalizedString(@"qm_product_buy_money", @"购买金额(元)");
        cell.detailLabel.text = [NSString stringWithFormat:@"%@", myOrderModel.amount];
        cell.detailLabel.hidden = NO;
        cell.horizontalLine.hidden = YES;
        ((UIImageView *)cell.backgroundView).image = [QMImageFactory commonBackgroundImageBottomPart];
    }

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    QMBuyProductFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:COLLECTION_VIEW_FOOTER_IDENTITIER forIndexPath:indexPath];
    footer.delegate = self;
    [footer setProductName:myOrderModel.productName];
    
    return footer;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 8, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 15 + 20 + 80);
}

// 执行购买操作
- (void)didSelectConfirmBtn:(UIButton *)btn {
    // 打点
    [QMUMTookKitManager event:USER_SUBMIT_ORDER_KEY label:@"用户提交订单"];
    
    // 首先检查是否设置过支付密码
    [self showPayPassword:YES];
}

// 显示设置支付密码页面
- (void)showPayPassword:(BOOL)hasSet {
    hasSetPayPassword = hasSet;
    
    [self.payAlertView clearTextField];
    [self.payAlertView show];
}

- (void)didSelectPrincipleBtn:(UIButton *)btn {
    [[NetServiceManager sharedInstance] getSequestrateAgreementWithDelegate:self
                                                                    success:^(id responseObject) {
                                                                        if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                                            NSDictionary *agreement = [responseObject objectForKey:@"agreement"];
                                                                            
                                                                            NSString *agreementContent = [agreement objectForKey:@"agreementContent"];
                                                                            
                                                                            NSString *name = [agreement objectForKey:@"name"];
                                                                            
                                                                            NSString *navTitle = name;
                                                                            if (QM_IS_STR_NIL(navTitle)) {
                                                                                navTitle = @"联动优势扣款协议";
                                                                            }
                                                                            
                                                                            [QMWebViewController3 showWebViewWithContent:agreementContent
                                                                                                               navTitle:navTitle
                                                                                                                isModel:YES
                                                                                                                   from:self];
                                                                        }
                                                                    } failure:^(NSError *error) {
                                                                        [CMMUtility showNoteWithError:error];
                                                                    }];
}

#pragma mark ----XSAlertViewDelegate
-(void)alertForgetPwd {
    [self.payAlertView dismiss];
    
    [self gotoModifyPayPasswordViewController];
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


-(void)alertConfirmCheckWithPwd:(NSString *)pwd {
    NSString *productId = myOrderModel.productId;
    NSString *amount = myOrderModel.amount;
    NSString *bankCardNumber = myOrderModel.bankCardNumber;
    pwd = self.payAlertView.payTextField.text;
    
    if (QM_IS_STR_NIL(productId) || QM_IS_STR_NIL(amount) || QM_IS_STR_NIL(bankCardNumber) || QM_IS_STR_NIL(pwd)) {
        return;
    }
    
    [self.payAlertView dismiss];
    
    [[NetServiceManager sharedInstance] buyProductWithProductId:productId
                                                         amount:amount
                                                 bankCardNumber:bankCardNumber
                                                    payPassword:pwd
                                                       delegate:self
                                                        success:^(id responseObject) {
                                                            // 打点
                                                            [QMUMTookKitManager event:USER_BUY_SUCCESS_KEY label:@"用户购买成功"];
                                                            
                                                            // 购买成功
                                                            [SVProgressHUD showSuccessWithStatus:QMLocalizedString(@"qm_buy_produt_success", @"购买成功")];
                                                            
                                                            QMProductBuyResultViewController *con = [[QMProductBuyResultViewController alloc] initViewControllerWithOrder:myOrderModel result:nil];
                                                            
                                                            [self.navigationController pushViewController:con animated:YES];
                                                        } failure:^(NSError *error) {
                                                            // 购买失败
                                                            [SVProgressHUD showErrorWithStatus:QMLocalizedString(@"qm_buy_produt_failure", @"购买失败")];
                                                            
                                                            // 产品购买失败
                                                            QMProductBuyResultViewController *con = [[QMProductBuyResultViewController alloc] initViewControllerWithOrder:myOrderModel result:error];
                                                            [self.navigationController pushViewController:con animated:YES];
                                                        }];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_confirm_buy_product_nav_title", @"购买");
}

@end
