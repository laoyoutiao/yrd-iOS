//
//  QMWithDrawViewController.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/18.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMWithDrawViewController.h"
#import "QMWithDrawRecordListViewController.h"
#import "QMSingleLineCollectionCell.h"
#import "QMTextFieldCollectionCell.h"
#import "QMMoreInfoBankTableFooterView.h"
#import "QMSingleLineTextCell.h"
#import "QMBankCardModel.h"
#import "QMSelectBankViewControllerV2.h"
#import "QMBankInfoCell.h"
#import "QMBankCardModel.h"
#import "QMAddBankCardViewControllerV2.h"

#define QMSINGLELINECOLLECTIONCELLIDENTIFIER2 @"QMSINGLELINECOLLECTIONCELLIDENTIFIER"
#define QMSINGLELINECOLLECTIONCELLIDENTIFIER3 @"QMSINGLELINECOLLECTIONCELLIDENTIFIER3"
#define QMTEXTFIELDCOLLECTIONCELLIDENTIFIER2 @"QMTEXTFIELDCOLLECTIONCELLIDENTIFIER"
#define MORE_ITEM_TABLE_FOOTER_IDENTIFIER2 @"MORE_ITEM_TABLE_FOOTER_IDENTIFIER"

@interface QMWithDrawViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIAlertViewDelegate, UIWebViewDelegate>

@end

@implementation QMWithDrawViewController {
    UICollectionView *myCollectionView;
    QMSingleLineTextCell *amountCell;
    QMBankCardModel *cardModel;
    NSArray *cardArrayModel;
    QMMoreInfoBankTableFooterView *footerView;
    QMTextFieldCollectionCell *pwdCell;
    UICollectionViewCell *lastclickcell;
    UIWebView *responWebView;
    double available;
    bool isWithDrawCardNow;
    BOOL isShowWebNow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isShowWebNow = NO;
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [self setUpCollectionView];
    isWithDrawCardNow = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self netupdateCardInformation];
}

- (void)netupdateCardInformation
{

    [[NetServiceManager sharedInstance] PersonWithDrawPermitAmt:self
                                                        success:^(id responseObject) {
                                                            if (!QM_IS_DICT_NIL(responseObject)) {
                                                                        // 显示当前余额
                                                                available = [[responseObject objectForKey:@"permitAmt"] doubleValue];
                                                            }
                                                            [myCollectionView reloadData];
                                                        } failure:^(NSError *error) {
                                                            [CMMUtility showNoteWithError:error];
                                                        }];
    
    // 获取剩余金额
//    [[NetServiceManager sharedInstance] getAvailableMoneyWithDelegate:self success:^(id responseObject) {
//        if (!QM_IS_DICT_NIL(responseObject)) {
//            // 显示当前余额
//            available = [[responseObject objectForKey:@"available"] doubleValue];
//        }
//        [myCollectionView reloadData];
//    } failure:^(NSError *error) {
//        [CMMUtility showNoteWithError:error];
//    }];
}

//- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
//    [amountCell.detailField resignFirstResponder];
//    [pwdCell.textField resignFirstResponder];
//}

- (void)handleTapGesture{
    [amountCell.detailField resignFirstResponder];
    [pwdCell.textField resignFirstResponder];
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    
    myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    myCollectionView.alwaysBounceVertical = YES;
    [myCollectionView registerClass:[QMSingleLineTextCell class] forCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER3];
    [myCollectionView registerClass:[QMTextFieldCollectionCell class] forCellWithReuseIdentifier:QMTEXTFIELDCOLLECTIONCELLIDENTIFIER2];
    [myCollectionView registerClass:[QMMoreInfoBankTableFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MORE_ITEM_TABLE_FOOTER_IDENTIFIER2];
    
    myCollectionView.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    myCollectionView.dataSource = self;
    myCollectionView.delegate = self;
    [self.view addSubview:myCollectionView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self handleTapGesture];
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
    return [QMNavigationBarItemFactory createNavigationItemWithTitle:QMLocalizedString(@"qm_withdraw_record_list", nil)
                                                              target:self
                                                            selector:@selector(gotowithDrawApplyListViewController)
                                                              isLeft:NO];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QMSingleLineTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER3 forIndexPath:indexPath];
        UIImageView *backgroundView = (UIImageView *)cell.backgroundView;
        backgroundView.image = [QMImageFactory commonBackgroundImage];
        cell.textLabel.text = @"可提现余额(元):";
        cell.detailField.enabled = NO;
        cell.detailField.placeholder = [CMMUtility formatterNumberWithComma:[NSNumber numberWithDouble:available]];
        cell.detailField.rightViewMode = UITextFieldViewModeNever;
        
        return cell;
    }else if (indexPath.section == 1) {
        QMSingleLineTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER3 forIndexPath:indexPath];
        UIImageView *backgroundView = (UIImageView *)cell.backgroundView;
        backgroundView.image = [QMImageFactory commonBackgroundImage];
        cell.textLabel.text = @"提现金额(元):";
        cell.detailField.placeholder = @"请输入提现金额";
        cell.detailField.enabled = YES;
        cell.detailField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.detailField.secureTextEntry = NO;
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        rightView.backgroundColor = QM_THEME_COLOR;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = rightView.bounds;
        [btn addTarget:self action:@selector(allMoney) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [btn setTitle:@"全额提现" forState:UIControlStateNormal];
        [rightView addSubview:btn];
        cell.detailField.rightView = rightView;
    
        cell.detailField.rightViewMode = UITextFieldViewModeAlways;
        
        amountCell = cell;
        
        return cell;
    }else if (indexPath.section == 2) {
        QMTextFieldCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMTEXTFIELDCOLLECTIONCELLIDENTIFIER2 forIndexPath:indexPath];
        UIImageView *backgroundView = (UIImageView *)cell.backgroundView;
        backgroundView.image = [QMImageFactory commonBackgroundImage];
        cell.textField.placeholder = @"请输入交易密码";
        cell.textField.secureTextEntry = YES;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.delegate = self;
        pwdCell = cell;
        
        return cell;
    }
    
    return nil;
}

- (void)allMoney {
    amountCell.detailField.text = [NSString stringWithFormat:@"%.2f", available];
    [self handleTapGesture];
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MORE_ITEM_TABLE_FOOTER_IDENTIFIER2 forIndexPath:indexPath];
    [footerView.actionBtn setTitle:@"提交" forState:UIControlStateNormal];
    [footerView.actionBtn addTarget:self action:@selector(commitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    footerView.actionBtn.frame = CGRectMake(10, 24, CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * 10, 40);
    footerView.actionBtn.enabled = YES;

    return footerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

// 提现申请
- (void)commitBtnClicked:(id)sender {
    [self handleTapGesture];
    cardModel = [cardArrayModel objectAtIndex:0];
    NSString *pwd = [pwdCell.textField text];
    NSString *amount = [amountCell.detailField text];
    [pwdCell.textField resignFirstResponder];
    [amountCell.textLabel resignFirstResponder];
    UIButton *btn = (UIButton *)sender;
    btn.enabled = NO;
    
    if ([amount doubleValue] <= 0) {
        [CMMUtility showNote:@"请输入提现金额"];
        btn.enabled = YES;
        return;
    }
    
    if ([pwd doubleValue] <= 0) {
        [CMMUtility showNote:@"请输入交易密码"];
        btn.enabled = YES;
        return;
    }
    
    [[NetServiceManager sharedInstance] PersonWithDraw:self
                                                Amount:amount
                                           paypassword:pwd
                                               success:^(id responseObject) {
                                                   [self handleResponseSuccess:responseObject];
                                               } failure:^(NSError *error) {
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 200);
    }
    return CGSizeZero;
}

// 提现记录
- (void)gotowithDrawApplyListViewController {
    QMWithDrawRecordListViewController *con = [[QMWithDrawRecordListViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}


- (void)unRegisterKeyBoardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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

- (void)handleKeyboardWillShowNotification:(NSNotification *)noti {
    CGRect endRect = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [myCollectionView setContentInset:UIEdgeInsetsMake(0, 0, 1.0f * endRect.size.height, 0)];
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)noti {
    [myCollectionView setContentInset:UIEdgeInsetsZero];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self registerKeyBoardNotification];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self unRegisterKeyBoardNotification];
}

- (NSString *)title {
    return @"提现";
}

@end

