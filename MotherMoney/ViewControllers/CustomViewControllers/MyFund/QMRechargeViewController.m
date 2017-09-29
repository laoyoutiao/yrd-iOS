//
//  QMRechargeViewController.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/18.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMRechargeViewController.h"
#import "QMRechargeRecordListViewController.h"
#import "QMSingleLineCollectionCell.h"
#import "QMTextFieldCollectionCell.h"
#import "QMMoreInfoBankTableFooterView.h"
#import "QMSelectBankViewControllerV2.h"
#import "LLViewController.h"
#import "QMTextFieldCollectionCell.h"
#import "LLPayUtil.h"
#import "QMBankInfoCell.h"
#import "QMAddBankCardViewControllerV2.h"
#import "QMWebViewController2.h"
#import "QMHeeWebViewController.h"
#import "QMAddBankCardViewController.h"
#import "QMIdentityAuthenticationViewController.h"
#import "QMAddBankViewController.h"
#import "QMBankInfo.h"
#define QMSELECTBANKCELLIDENTIFIER1 @"QMSELECTBANKCELLIDENTIFIER"
#define QMTEXTFIELDCOLLECTIONCELLIDENTIFIER1 @"QMTEXTFIELDCOLLECTIONCELLIDENTIFIER"
#define MORE_ITEM_TABLE_FOOTER_IDENTIFIER1 @"MORE_ITEM_TABLE_FOOTER_IDENTIFIER"

@interface QMRechargeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIWebViewDelegate, QMSelectItemViewControllerDelegate, UIWebViewDelegate>

@end

@implementation QMRechargeViewController {
    UICollectionView *myCollectionView;
    QMBankCardModel *cardModel;
    QMBankInfo *currentBankInfo;
    UICollectionViewCell *lastclickcell;
    NSArray *cardArrayModel;
    QMTextFieldCollectionCell *amountCell;
    QMTSelectBankCollectionCell *selectBankCell;
    LLPaySdk *sdk;
    QMMoreInfoBankTableFooterView *footerView;
    UIScrollView *myScrollView;
    UIImageView *checkImgView;
    UIWebView *responWebView;
    BOOL isShowWebNow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    isShowWebNow = NO;
    [self setUpCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [amountCell.textField becomeFirstResponder];
}

- (void)onBack {
    if (isShowWebNow) {
        isShowWebNow = NO;
        [responWebView removeFromSuperview];
    }else
    {
        if (self.isModel) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

- (UIBarButtonItem *)leftBarButtonItem {
    if (self.isModel) {
        return [QMNavigationBarItemFactory createNavigationBackItemWithTarget:self selector:@selector(onBack)];
    }
    
    return nil;
}

- (UIBarButtonItem *)rightBarButtonItem {
    //返回充值记录
    return [QMNavigationBarItemFactory createNavigationItemWithTitle:QMLocalizedString(@"qm_recharge_record_list", nil)
                                                              target:self
                                                            selector:@selector(gotoRechargeRecordListViewController)
                                                              isLeft:NO];
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;

    myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:myScrollView];
    myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    myCollectionView.alwaysBounceVertical = YES;
    [myCollectionView registerClass:[QMTextFieldCollectionCell class] forCellWithReuseIdentifier:QMTEXTFIELDCOLLECTIONCELLIDENTIFIER1];
    [myCollectionView registerClass:[QMTSelectBankCollectionCell class] forCellWithReuseIdentifier:QMSELECTBANKCELLIDENTIFIER1];
    [myCollectionView registerClass:[QMMoreInfoBankTableFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MORE_ITEM_TABLE_FOOTER_IDENTIFIER1];
    
    myCollectionView.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    myCollectionView.scrollEnabled = NO;
    myCollectionView.dataSource = self;
    myCollectionView.delegate = self;
    [myScrollView addSubview:myCollectionView];
    
    [myScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QMTSelectBankCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMSELECTBANKCELLIDENTIFIER1 forIndexPath:indexPath];
        [cell.selectBankBtn addTarget:self action:@selector(clickSelectBank) forControlEvents:UIControlEventTouchUpInside];
        selectBankCell = cell;
        [cell.selectBankBtn setTitle:@"请选择银行" forState:UIControlStateNormal];
        return cell;
    }else
    {
        QMTextFieldCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMTEXTFIELDCOLLECTIONCELLIDENTIFIER1 forIndexPath:indexPath];
        UIImageView *backgroundView = (UIImageView *)cell.backgroundView;
        backgroundView.image = [QMImageFactory commonBackgroundImage];
        cell.textField.placeholder = @"充值金额(元):充值金额>= 50";
        cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.textField.delegate = self;
        amountCell = cell;
        return cell;
    }
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 8, 44);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 0, 8);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 200);
    }
    return CGSizeZero;
}

- (void)selectBankViewControllerDidCancel:(QMSelectBankViewControllerV2 *)con {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
        footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MORE_ITEM_TABLE_FOOTER_IDENTIFIER1 forIndexPath:indexPath];
        [footerView.actionBtn setTitle:@"提交" forState:UIControlStateNormal];
        [footerView.actionBtn addTarget:self action:@selector(commitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        footerView.actionBtn.frame = CGRectMake(10, 24, CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * 10, 40);
        footerView.actionBtn.enabled = YES;
        
        return footerView;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)clickSelectBank
{
    QMOrderModel *mOrderModel = [[QMOrderModel alloc] init];
    mOrderModel.productChannelId = @"2";
    
    QMAddBankViewController *con = [[QMAddBankViewController alloc] initViewControllerWithProduct:mOrderModel];
    con.delegate = self;
    con.isModel = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)commitBtnClicked:(id)sender {
    NSString *amount = [amountCell.textField text];
    [amountCell.textField resignFirstResponder];
    if (QM_IS_STR_NIL(amount)) {
        [CMMUtility showNote:@"请输入金额"];
        return;
    }
    
    if (QM_IS_STR_NIL(currentBankInfo.bankCode)) {
        [CMMUtility showNote:@"请选择银行"];
        return;
    }
    
#if ON_LINE
    if ([amount doubleValue] < 50.0f) {
        [CMMUtility showNote:@"充值金额必须大于等于50元"];
        return;
    }
#else
    
#endif
    
    // 禁掉按钮，防止多次点击
    footerView.actionBtn.enabled = NO;
    
    [[NetServiceManager sharedInstance] PersonRecharge:self
                                                Amount:amount
                                              BankCode:currentBankInfo.bankCode
                                               success:^(id responseObject) {
                                                   [self handleResponseSuccess:responseObject];
                                               }
                                               failure:^(NSError *error) {
                                                   [self handleResponseFailure:error];
                                               }];
    
}

- (void)handleResponseSuccess:(id)response {
    isShowWebNow = YES;
    footerView.actionBtn.enabled = YES;
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
    footerView.actionBtn.enabled = YES;
    [CMMUtility showNoteWithError:error];
}

#pragma mark QMSelectItemViewControllerDelegate
- (void)viewController:(QMSelectItemViewController *)controller didSelectItem:(QMSearchItem *)item {
    if ([controller isKindOfClass:[QMAddBankViewController class]]) {
        QMBankInfo *info = (QMBankInfo *)item;
        if ([info isKindOfClass:[QMBankInfo class]]) {
            currentBankInfo = info;
            [selectBankCell.selectBankBtn setTitle:currentBankInfo.bankName forState:UIControlStateNormal];
        }
    }
}


// 充值记录
- (void)gotoRechargeRecordListViewController {
    QMRechargeRecordListViewController *con = [[QMRechargeRecordListViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}


- (NSString *)title {
    return @"充值";
}

@end
