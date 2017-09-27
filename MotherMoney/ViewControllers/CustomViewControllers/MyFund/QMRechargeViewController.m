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
#define QMSINGLELINECOLLECTIONCELLIDENTIFIER1 @"QMSINGLELINECOLLECTIONCELLIDENTIFIER"
#define QMTEXTFIELDCOLLECTIONCELLIDENTIFIER1 @"QMTEXTFIELDCOLLECTIONCELLIDENTIFIER"
#define MORE_ITEM_TABLE_FOOTER_IDENTIFIER1 @"MORE_ITEM_TABLE_FOOTER_IDENTIFIER"

@interface QMRechargeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, QMSelectBankViewControllerV2Delegate, LLPaySdkDelegate, UIWebViewDelegate>

@end

@implementation QMRechargeViewController {
    UICollectionView *myCollectionView;
    QMBankCardModel *cardModel;
    UICollectionViewCell *lastclickcell;
    NSArray *cardArrayModel;
    QMTextFieldCollectionCell *amountCell;
    LLPaySdk *sdk;
    QMMoreInfoBankTableFooterView *footerView;
    UIScrollView *myScrollView;
    UIImageView *checkImgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    [self setUpCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 获取银行卡信息
    [[NetServiceManager sharedInstance] getBankCardListByChannelId:@"2" delegate:self success:^(id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        NSArray *cardList = [responseObject objectForKey:kNetWorkList];
        
        cardArrayModel = [QMBankCardModel getArrayModel:cardList];
        [myCollectionView reloadData];
        
        //        if (cardList && [cardList isKindOfClass:[NSArray class]]) {
        //
        //            for (NSDictionary *dict in cardList) {
        //                QMBankCardModel *model = [[QMBankCardModel alloc] initWithDictionary:dict];
        //
        //                cardModel = model;
        //                break;
        //            }
        //            //刷新表格
        //            [myCollectionView reloadData];
        //            [amountCell.textField becomeFirstResponder];
        //        }
    } failure:^(NSError *error) {
        [CMMUtility showNoteWithError:error];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [amountCell.textField becomeFirstResponder];
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
    [myCollectionView registerClass:[QMBankInfoCell class] forCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER1];
    [myCollectionView registerClass:[QMTextFieldCollectionCell class] forCellWithReuseIdentifier:QMTEXTFIELDCOLLECTIONCELLIDENTIFIER1];
    [myCollectionView registerClass:[QMMoreInfoBankTableFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MORE_ITEM_TABLE_FOOTER_IDENTIFIER1];
    
    myCollectionView.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    myCollectionView.scrollEnabled = NO;
    myCollectionView.dataSource = self;
    myCollectionView.delegate = self;
    [myScrollView addSubview:myCollectionView];
    
    [myScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + 150)];
    
    checkImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    checkImgView.image = [UIImage imageNamed:@"check_box_2"];
    //    checkImgView.backgroundColor = [UIColor redColor];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (void)gotoAddBankCardViewController {
    QMIdentityAuthenticationViewController *con = [[QMIdentityAuthenticationViewController alloc] init];
    QMAccountInfo *info = [[QMAccountUtil sharedInstance] currentAccount];
    con.isModel = YES;
    con.userIdCard = info.identifierCardId;
    NSLog(@"%@",info.realName);
    con.userRealName = info.realName;
    con.haveDefaultMessage = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QMBankInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER1 forIndexPath:indexPath];
        cell.withDraw = NO;//提示信息将显示为充值银行卡。。。。
        [cell.actionBtn addTarget:self action:@selector(gotoAddBankCardViewController) forControlEvents:UIControlEventTouchUpInside];
        QMBankCardModel *model;
        
        if ([cardArrayModel count] == 1 && indexPath.row == 0)
        {
            cell.withOnlyCard = YES;
        }else
        { 
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        if (indexPath.row < [cardArrayModel count])
        {
            model = [cardArrayModel objectAtIndex:indexPath.row];
            [cell configureCellWithBankCardModel:model];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 0.5, cell.frame.size.width, 0.5)];
            line.backgroundColor = [UIColor grayColor];
            [cell addSubview:line];
        }else
        {
            [cell configureCellWithBankCardModel:nil];
        }
        
        
        
        if (indexPath.row < [cardArrayModel count] - 1)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 0.5, cell.frame.size.width, 0.5)];
            line.backgroundColor = [UIColor grayColor];
            [cell addSubview:line];
        }
        
        
                else if (indexPath.row == [cardArrayModel count])
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
                    label.text = @"添加提现银行卡";
                    label.font = [UIFont systemFontOfSize:16];
                    label.textAlignment = NSTextAlignmentCenter;
                    [cell addSubview:label];
                    cell.tag = 1200;
                }
        return cell;
    }else if (indexPath.section == 1) {
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
    if (section == 0) {
//        if ([cardArrayModel count] < 3 && [cardArrayModel count] > 0)
//        {
//            return [cardArrayModel count] + 1;
//        }else
//        {
//            return [cardArrayModel count];
//        }
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
    if (indexPath.section == 1) {
        footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MORE_ITEM_TABLE_FOOTER_IDENTIFIER1 forIndexPath:indexPath];
        [footerView.actionBtn setTitle:@"提交" forState:UIControlStateNormal];
        [footerView.actionBtn addTarget:self action:@selector(commitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        footerView.actionBtn.frame = CGRectMake(10, 24, CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * 10, 40);
        footerView.actionBtn.enabled = YES;
        
        return footerView;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (lastclickcell) {
        lastclickcell.backgroundColor = [UIColor whiteColor];
        [checkImgView removeFromSuperview];
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cardArrayModel count] == 1)
    {
        return;
    }else
    {
        checkImgView.frame = CGRectMake(cell.frame.size.width - 70, cell.frame.size.height / 2 - 15, 30, 30);
        [cell addSubview:checkImgView];
    }
    cell.backgroundColor = [UIColor grayColor];
    lastclickcell = cell;
    QMBankCardModel *model = [cardArrayModel objectAtIndex:indexPath.row];
    cardModel = model;
}

- (void)commitBtnClicked:(id)sender {
    if ([cardArrayModel count] == 1)
    {
        cardModel = [cardArrayModel objectAtIndex:0];
    }
    NSString *bankCardId = cardModel.bankCardId;
    NSString *amount = [amountCell.textField text];
    
    if (QM_IS_STR_NIL(bankCardId)) {
        [CMMUtility showNote:@"请选择银行卡"];
        return;
    }
    
    if (QM_IS_STR_NIL(amount)) {
        [CMMUtility showNote:@"请输入金额"];
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
    [[NetServiceManager sharedInstance] getRechargeRouteWithUserBankCardId:bankCardId amount:amount productChannelId:@"2" delegate:self success:^(id responseObject) {
        NSLog(@"%@",(NSDictionary *)responseObject);
        NSLog(@"支付方式:%@",[responseObject objectForKey:@"payWay"]);
        NSString *payWay = [responseObject objectForKey:@"payWay"];
        if ([payWay isEqualToString:@"WAP"]) {
            //            [self gotoLLWapWithURL:[responseObject objectForKey:@"url"]];
            [self gotoHeeWapWithURL:[responseObject objectForKey:@"url"]];
        }else{
            //发起支付请求
            [[NetServiceManager sharedInstance] rechargeRequestWithDelegate:self userBankCardId:bankCardId amount:amount success:^(id responseObject) {
                // 调用连连sdk
                NSDictionary *dic = (NSDictionary *)responseObject;
                
                NSLog(@"支付发起%@",dic);
                
                NSDictionary * param = [dic objectForKey:@"param"];
                
                sdk = [[LLPaySdk alloc] init];
                sdk.sdkDelegate = self;
                
                NSLog(@"%@",kLLPaySDKBuildVersion);
                // 认证支付(旧版本方法)
                //                [LLPaySdk setLLsdkPayState:1];
                //                [sdk presentPaySdkInViewController:self withTraderInfo:param];
                
                //认证支付
                [sdk presentLLPaySDKInViewController:self withPayType:LLPayTypeVerify andTraderInfo:param];
                
            } failure:^(NSError *error) {
                [CMMUtility showNoteWithError:error];
                [myCollectionView reloadData];
            }];
        }
        
        
        
    } failure:^(NSError *error) {
        [CMMUtility showNoteWithError:error];
    }];
    
    
}

- (void)gotoLLWapWithURL:(NSString *)url{
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [QMWebViewController2 showWebViewWithRequest:request navTitle:@"认证支付" isModel:NO from:self];
}

- (void)gotoHeeWapWithURL:(NSString *)url
{
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [QMHeeWebViewController showWebViewWithRequest:request navTitle:@"认证支付" isModel:NO from:self];
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 1) {
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
    [amountCell.textField becomeFirstResponder];
}

- (void)selectBankViewControllerDidCancel:(QMSelectBankViewControllerV2 *)con {
    [self.navigationController popViewControllerAnimated:YES];
}


// 充值记录
- (void)gotoRechargeRecordListViewController {
    QMRechargeRecordListViewController *con = [[QMRechargeRecordListViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

#pragma -mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    footerView.actionBtn.enabled = YES;
    
    NSString *msg = @"支付异常";
    switch (resultCode) {
        case kLLPayResultSuccess: {
            msg = @"支付成功";
            
            NSString* result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"]) {
                if (!QM_IS_DICT_NIL(dic)) {
                    // 提交到服务器
                    [[NetServiceManager sharedInstance] sendRechargeResultWithParam:dic delegate:self success:^(id responseObject) {
                        // 回传成功
                        if (self.isModel) {
                            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                        }else {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    } failure:^(NSError *error) {
                        [CMMUtility showNoteWithError:error];
                    }];
                }
            } else if ([result_pay isEqualToString:@"PROCESSING"]) {
                msg = @"支付单处理中";
            }else if ([result_pay isEqualToString:@"FAILURE"]) {
                msg = @"支付单失败";
            }else if ([result_pay isEqualToString:@"REFUND"]) {
                msg = @"支付单已退款";
            }
        }
            break;
        case kLLPayResultFail: {
            msg = @"支付失败";
        }
            break;
        case kLLPayResultCancel: {
            msg = @"支付取消";
        }
            break;
        case kLLPayResultInitError: {
            msg = @"sdk初始化异常";
        }
            break;
        case kLLPayResultInitParamError: {
            msg = dic[@"ret_msg"];
        }
            break;
        default:
            break;
    }
    [[[UIAlertView alloc] initWithTitle:@"结果"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:@"确认"
                      otherButtonTitles:nil] show];
}


- (NSString *)title {
    return @"充值";
}

@end
