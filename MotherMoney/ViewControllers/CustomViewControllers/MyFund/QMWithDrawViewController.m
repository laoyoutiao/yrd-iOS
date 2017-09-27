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

@interface QMWithDrawViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, QMSelectBankViewControllerV2Delegate,UIAlertViewDelegate>

@end

@implementation QMWithDrawViewController {
    UICollectionView *myCollectionView;
    QMSingleLineTextCell *amountCell;
    QMBankCardModel *cardModel;
    NSArray *cardArrayModel;
    QMTextFieldCollectionCell *pwdCell;
    UICollectionViewCell *lastclickcell;
    double available;
    bool isWithDrawCardNow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
        
        NSLog(@"%@",[QMBankCardModel getArrayModel:cardList]);
        
        cardArrayModel = [QMBankCardModel getArrayModel:cardList];
        
        NSMutableArray *modelArray = [[NSMutableArray alloc] initWithArray:cardArrayModel];
        
        for (QMBankCardModel *model in modelArray)
        {
            if (model.isWithdrawCard.integerValue) {
                cardArrayModel = @[model];
                isWithDrawCardNow = YES;
                [myCollectionView reloadData];
                return;
            }
        }
        
        if ([modelArray count])
        {
            cardArrayModel = modelArray;
            [myCollectionView reloadData];
            return;
        }
        
        cardArrayModel = nil;
        [myCollectionView reloadData];
        //        if (cardList && [cardList isKindOfClass:[NSArray class]]) {
        //
        //            for (NSDictionary *dict in cardList) {
        //                QMBankCardModel *model = [[QMBankCardModel alloc] initWithDictionary:dict];
        //
        //                cardModel = model;
        //                break;
        //            }
        //
        //            [myCollectionView reloadData];
        //        }
    } failure:^(NSError *error) {
        [CMMUtility showNoteWithError:error];
    }];
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
    [myCollectionView registerClass:[QMBankInfoCell class] forCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER2];
    [myCollectionView registerClass:[QMSingleLineTextCell class] forCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER3];
    
    [myCollectionView registerClass:[QMTextFieldCollectionCell class] forCellWithReuseIdentifier:QMTEXTFIELDCOLLECTIONCELLIDENTIFIER2];
    [myCollectionView registerClass:[QMMoreInfoBankTableFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MORE_ITEM_TABLE_FOOTER_IDENTIFIER2];
    
    myCollectionView.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    myCollectionView.dataSource = self;
    myCollectionView.delegate = self;
    [self.view addSubview:myCollectionView];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
//    [myCollectionView addGestureRecognizer:tap];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self handleTapGesture];
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
        QMBankCardModel *model = [cardArrayModel objectAtIndex:indexPath.row];
        if ([cardArrayModel count] == 1 && isWithDrawCardNow == YES)
        {
            cell.withDrawCard = YES;
        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        [cell configureCellWithBankCardModel:model];
        if (indexPath.row < [cardArrayModel count] - 1)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 0.5, cell.frame.size.width, 0.5)];
            line.backgroundColor = [UIColor grayColor];
            [cell addSubview:line];
        }
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
    [self handleTapGesture];
}

- (void)gotoAddBankCardViewController {
    QMAddBankCardViewControllerV2 *con = [[QMAddBankCardViewControllerV2 alloc] init];
    con.isModel = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
//        return [cardArrayModel count];
        return 0;
    }else
    {
        return 1;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row < [cardArrayModel count]) {
        QMBankCardModel *model = [cardArrayModel objectAtIndex:indexPath.row];
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 8, [QMBankInfoCell getCellHeightWithBankCardModel:model]);
    }
    
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 8, 44);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 0, 8);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    QMMoreInfoBankTableFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MORE_ITEM_TABLE_FOOTER_IDENTIFIER2 forIndexPath:indexPath];
    [footerView.actionBtn setTitle:@"提交" forState:UIControlStateNormal];
    [footerView.actionBtn addTarget:self action:@selector(commitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return footerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",buttonIndex);
    lastclickcell.backgroundColor = [UIColor whiteColor];
    NSInteger clickcell = [myCollectionView indexPathForCell:lastclickcell].row;
    if (alertView.tag == 100 && buttonIndex == 1) {
        QMBankCardModel *model = [cardArrayModel objectAtIndex:clickcell];
        [[NetServiceManager sharedInstance] setWithDrawCardWithCardID:model.bankCardId Delegate:self success:^(id responseObject) {
            [self netupdateCardInformation];
        } failure:^(NSError *error) {
            [CMMUtility showNote:@"绑定失败"];
        }];
    }
}

// 提现申请
- (void)commitBtnClicked:(id)sender {
    [self handleTapGesture];
    NSString *channelId = @"2";
    cardModel = [cardArrayModel objectAtIndex:0];
    NSString *bankCardId = cardModel.bankCardId;
    NSString *pwd = [pwdCell.textField text];
    NSString *amount = [amountCell.detailField text];
    UIButton *btn = (UIButton *)sender;
    btn.enabled = NO;
    if (cardModel.isWithdrawCard.integerValue == 0) {
        [CMMUtility showNote:@"请先点击选择银行卡，进行提现银行卡的设置。"];
        btn.enabled = YES;
        return;
    }
    
    if ([amount doubleValue] <= 0) {
        [CMMUtility showNote:@"请输入提现金额"];
        btn.enabled = YES;
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
                                                                   btn.enabled = YES;
                                                               } failure:^(NSError *error) {
                                                                   [CMMUtility showNoteWithError:error];
                                                                   btn.enabled = YES;
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

