//
//  QMBuyProductInputMoneyViewController.m
//  MotherMoney
//
//  Created by   on 14-8-16.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMBuyProductInputMoneyViewController.h"
#import "QMSingleLineCollectionCell.h"
#import "QMTwoLineCollectionCell.h"
#import "QMTextFieldCollectionCell.h"
#import "QMBuyProductBottomView.h"
#import "QMSelectBankViewController.h"

#define QMSINGLELINECOLLECTIONCELLIDENTIFIER @"qmsinglelinecollectioncellidentifier"
#define QMTWOLINECOLLECTIONCELLIDENTIFIER @"qmtwolinecollectioncellidentifier"
#define QMTEXTFIELDCOLLECTIONCELLIDENTIFIER @"qmtextfieldcollectioncellIdentifier"

#define QMSECTIONFOOTERVIEWIDENTIFIER @"qmsectionfooterviewIdentifier"

@interface QMBuyProductInputMoneyViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>

@end

@implementation QMBuyProductInputMoneyViewController {
    UICollectionView *myCollectionView;
    QMProductInfo *myProductInfo;
    
    NSInteger rateMoney;
}

- (id)initViewControllerWithProductInfo:(QMProductInfo *)info {
    if (self = [super init]) {
        myProductInfo = info;
        rateMoney = [info.baseAmount integerValue];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    rateMoney = [myProductInfo.baseAmount integerValue];
    
    [self setUpCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerKeybaordNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self unRegisterKeyboardNotification];
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    
    myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    myCollectionView.alwaysBounceVertical = YES;
    [myCollectionView registerClass:[QMSingleLineCollectionCell class] forCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER];
    [myCollectionView registerClass:[QMTwoLineCollectionCell class] forCellWithReuseIdentifier:QMTWOLINECOLLECTIONCELLIDENTIFIER];
    [myCollectionView registerClass:[QMTextFieldCollectionCell class] forCellWithReuseIdentifier:QMTEXTFIELDCOLLECTIONCELLIDENTIFIER];
    [myCollectionView registerClass:[QMBuyProductBottomView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:QMSECTIONFOOTERVIEWIDENTIFIER];
    
    myCollectionView.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    myCollectionView.dataSource = self;
    myCollectionView.delegate = self;
    [self.view addSubview:myCollectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            QMTwoLineCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMTWOLINECOLLECTIONCELLIDENTIFIER forIndexPath:indexPath];
            UIImageView *backgroundView = (UIImageView *)cell.backgroundView;
            backgroundView.image = [QMImageFactory commonBackgroundImageTopPart];
            
            cell.textLabel.text = myProductInfo.productName;
            cell.detailTextLabel.text = @"";
            
            return cell;
        }else {
            QMSingleLineCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER forIndexPath:indexPath];
            UIImageView *backgroundView = (UIImageView *)cell.backgroundView;
            backgroundView.image = [QMImageFactory commonBackgroundImageCenterPart];
            cell.horizontalLine.hidden = NO;
            if (indexPath.row == 1) {
                cell.textLabel.text = [NSString stringWithFormat:QMLocalizedString(@"qm_min_money_format", @"起购金额:%d元"), [myProductInfo.minAmount integerValue]];
            }else if (indexPath.row == 2) {
                cell.textLabel.text = @"手续费:无";
            }else if (indexPath.row == 3) {
                cell.textLabel.text = [NSString stringWithFormat:QMLocalizedString(@"qm_product_infO_page_investmentPeriod_format", @"理财期限:%@"), myProductInfo.maturityDuration];
                backgroundView.image = [QMImageFactory commonBackgroundImageBottomPart];
                cell.horizontalLine.hidden = YES;
            }
            
            return cell;
        }
    }else if (indexPath.section == 1) {
        QMTextFieldCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMTEXTFIELDCOLLECTIONCELLIDENTIFIER forIndexPath:indexPath];
        UIImageView *backgroundView = (UIImageView *)cell.backgroundView;
        backgroundView.image = [QMImageFactory commonBackgroundImage];
        cell.textField.placeholder = QMLocalizedString(@"qm_product_buy_amount_placeholder", @"购买金额");
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.delegate = self;
        
        return cell;
    }
    
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
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
        QMBuyProductBottomView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:QMSECTIONFOOTERVIEWIDENTIFIER forIndexPath:indexPath];
        
        // TODO ZGH
        footer.infoLabel.text = [NSString stringWithFormat:QMLocalizedString(@"qm_product_rate_format", @"起购金额:%@元,%@元递增"), myProductInfo.minAmount, myProductInfo.baseAmount];
        [footer.actionBtn addTarget:self action:@selector(nextStepBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
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
    
    if ((money % rateMoney) != 0) {
        NSString *text = [NSString stringWithFormat:QMLocalizedString(@"qm_money_rate_error", @"购买金额必须是%d元的整数倍"), rateMoney];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:text
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:QMLocalizedString(@"qm_alertview_ok_title", @"确定"), nil];
        [alertView show];
    }else if (money < [myProductInfo.minAmount integerValue]) {
        NSString *text = [NSString stringWithFormat:QMLocalizedString(@"qm_money_less_minamount_error", @"购买金额必须不少于%d元"), [myProductInfo.minAmount integerValue]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:text
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:QMLocalizedString(@"qm_alertview_ok_title", @"确定"), nil];
        [alertView show];
    }else {
        // 选择银行卡
        
        QMOrderModel *orderModel = [[QMOrderModel alloc] init];
        orderModel.productId = myProductInfo.product_id;
        orderModel.productName = myProductInfo.productName;
        orderModel.productChannelId = myProductInfo.productChannelId;
        
        orderModel.amount = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:money]];
        
        QMSelectBankViewController *con = [[QMSelectBankViewController alloc] initViewControllerWithOrder:orderModel];
        [self.navigationController pushViewController:con animated:YES];
    }
}

- (void)registerKeybaordNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unRegisterKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [self unRegisterKeyboardNotification];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_confirm_buy_product_nav_title", @"购买");
}

@end
