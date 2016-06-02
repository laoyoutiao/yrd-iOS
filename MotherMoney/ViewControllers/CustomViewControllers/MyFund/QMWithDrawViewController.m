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
#import "QMMoreInfoTableFooterView.h"
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

@interface QMWithDrawViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, QMSelectBankViewControllerV2Delegate>

@end

@implementation QMWithDrawViewController {
    UICollectionView *myCollectionView;
    QMSingleLineTextCell *amountCell;
    QMBankCardModel *cardModel;
    QMTextFieldCollectionCell *pwdCell;
    double available;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [self setUpCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 获取剩余金额
    [[NetServiceManager sharedInstance] getAvailableMoneyWithDelegate:self success:^(id responseObject) {
        if (!QM_IS_DICT_NIL(responseObject)) {
            // 显示当前余额
            available = [[responseObject objectForKey:@"available"] doubleValue];
        }
        [myCollectionView reloadData];
    } failure:^(NSError *error) {
        [CMMUtility showNoteWithError:error];
    }];
    
    // 获取银行卡信息
    [[NetServiceManager sharedInstance] getBankCardListByChannelId:@"2" delegate:self success:^(id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        NSArray *cardList = [responseObject objectForKey:kNetWorkList];
        if (cardList && [cardList isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dict in cardList) {
                QMBankCardModel *model = [[QMBankCardModel alloc] initWithDictionary:dict];
                
                cardModel = model;
                break;
            }
            
            [myCollectionView reloadData];
        }
    } failure:^(NSError *error) {
        [CMMUtility showNoteWithError:error];
    }];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    [amountCell.detailField resignFirstResponder];
    [pwdCell.textField resignFirstResponder];
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    
    myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    myCollectionView.alwaysBounceVertical = YES;
    [myCollectionView registerClass:[QMBankInfoCell class] forCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER2];
    [myCollectionView registerClass:[QMSingleLineTextCell class] forCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER3];
    
    [myCollectionView registerClass:[QMTextFieldCollectionCell class] forCellWithReuseIdentifier:QMTEXTFIELDCOLLECTIONCELLIDENTIFIER2];
    [myCollectionView registerClass:[QMMoreInfoTableFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MORE_ITEM_TABLE_FOOTER_IDENTIFIER2];
    
    myCollectionView.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    myCollectionView.dataSource = self;
    myCollectionView.delegate = self;
    [self.view addSubview:myCollectionView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [myCollectionView addGestureRecognizer:tap];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}


- (void)onBack {
    if (self.isModel) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
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
        QMBankInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER2 forIndexPath:indexPath];
        cell.withDraw = YES;
        [cell.actionBtn addTarget:self action:@selector(gotoAddBankCardViewController) forControlEvents:UIControlEventTouchUpInside];
        [cell configureCellWithBankCardModel:cardModel];
        
        return cell;
    }else if (indexPath.section == 1) {
        QMSingleLineTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER3 forIndexPath:indexPath];
        UIImageView *backgroundView = (UIImageView *)cell.backgroundView;
        backgroundView.image = [QMImageFactory commonBackgroundImage];
        cell.textLabel.text = @"可提现余额(元):";
        cell.detailField.enabled = NO;
        cell.detailField.placeholder = [CMMUtility formatterNumberWithComma:[NSNumber numberWithDouble:available]];
        cell.detailField.rightViewMode = UITextFieldViewModeNever;
        
        return cell;
    }else if (indexPath.section == 2) {
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
    }else if (indexPath.section == 3) {
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
}

- (void)gotoAddBankCardViewController {
    QMAddBankCardViewControllerV2 *con = [[QMAddBankCardViewControllerV2 alloc] init];
    con.isModel = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 8, [QMBankInfoCell getCellHeightWithBankCardModel:cardModel]);
    }
    
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 8, 44);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 0, 8);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    QMMoreInfoTableFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MORE_ITEM_TABLE_FOOTER_IDENTIFIER2 forIndexPath:indexPath];
    [footerView.actionBtn setTitle:@"提交" forState:UIControlStateNormal];
    [footerView.actionBtn addTarget:self action:@selector(commitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return footerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
 
    
}

// 提现申请
- (void)commitBtnClicked:(id)sender {
    NSString *channelId = @"2";
    NSString *bankCardId = cardModel.bankCardId;
    NSString *pwd = [pwdCell.textField text];
    NSString *amount = [amountCell.detailField text];
    
    if (QM_IS_STR_NIL(bankCardId)) {
        [CMMUtility showNote:@"请选择银行卡"];
        return;
    }
    
    if ([amount doubleValue] <= 0) {
        [CMMUtility showNote:@"请输入提现金额"];
        return;
    }
    
    [[NetServiceManager sharedInstance] withWithDrawApplyWithChannelId:channelId
                                                                   pwd:pwd
                                                            bankCardId:bankCardId
                                                                amount:amount
                                                              delegate:self
                                                               success:^(id responseObject) {
                                                                   NSLog(@"response:%@", responseObject);
                                                                   // 提现成功
                                                                   if (self.isModel) {
                                                                       [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                                   }else {
                                                                       [self.navigationController popViewControllerAnimated:YES];
                                                                   }
                                                                   [CMMUtility showNote:@"提现申请提交成功"];
                                                               } failure:^(NSError *error) {
                                                                   [CMMUtility showNoteWithError:error];
                                                               }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 3) {
        // 最后一个
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 200);
    }else {
        return CGSizeZero;
    }
}

- (void)selectBankViewController:(QMSelectBankViewControllerV2 *)con didSelectBank:(QMBankCardModel *)model {
    cardModel = model;
    [myCollectionView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectBankViewControllerDidCancel:(QMSelectBankViewControllerV2 *)con {
    [self.navigationController popViewControllerAnimated:YES];
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

