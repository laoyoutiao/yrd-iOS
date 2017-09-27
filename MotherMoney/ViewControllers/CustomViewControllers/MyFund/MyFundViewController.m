//
//  MyFundViewController.m
//  MotherMoney
//
//  Created by on 14-8-3.
//  Copyright (c) 2014年. All rights reserved.
//

#import "MyFundViewController.h"
#import "QMMyFundModel.h"
#import "QMBuyedProductInfoCell.h"
#import "QMMyFundAbstractCell.h"
#import "QMAccountInfoCell.h"
#import "QMBuyedProductInfoHeaderView.h"
#import "QMMessageCenterViewController.h"
#import "QMPersonalCenterViewController.h"
#import "QMMyProductInfoViewController.h"
#import "QMFundEmptyCell.h"
#import "QMGoodsListViewController.h"
#import "QMWithDrawRecordListViewController.h"
#import "QMRechargeRecordListViewController.h"
#import "QMMyFundTableFooterView.h"
#import "QMBuyHistoryListViewController.h"
#import "QMAccountOpViewController.h"
#import "QMIdentityAuthenticationViewController.h"
#import "QMBaseInfoCell.h"
#import "QMMyFundFooterReusableView.h"
#import "QMRechargeViewController.h"
#import "QMWithDrawViewController.h"
#import "QMDealDetailViewController.h"
#import "QMPrizeViewController.h"
#import "QMProvinceInfo.h"
#define myFundAbstractCellIdentifier @"myFundAbstractCellIdentifier"
#define buyedProductInfoCellIdentifier @"buyedProductInfoCellIdentifier"
#define totalEarningsCellIdentifier @"totalEarningsCellIdentifier"
#define QM_FUND_EMPTY_CELL_IDENTIFIER @"QM_FUND_EMPTY_CELL_IDENTIFIER"
#define QM_FUND_FOOTER_IDENTIFIER @"QM_FUND_FOOTER_IDENTIFIER"

#define BUYEDPRODUCTIONINFOSECTION_TITLE_IDENTIFIER @"buyedproductioninfosection_title_identifier"
#define QM_FUND_BASEIFO_CELL_IDENTIFIER @"QM_FUND_BASEIFO_CELL_IDENTIFIER"
#define QM_FUND_FOOTERRESUABLE_IDENTIFIER @"QM_FUND_FOOTERRESUABLE_IDENTIFIER"
typedef enum {
    
    QMFundTableSection_Abstract=0, // 概述信息
    QMFundTableSection_BaseInfo,//基本信息
    QMFundTableSection_Count
}QMFundTableSection;

@interface MyFundViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation MyFundViewController {
    UICollectionView *myFundTable;
    QMMyFundModel *myFundInfo;
    BOOL isBuy;
    NSString *_idCardNumber;
    NSString *phoneNumber;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [self.navigationController setNavigationBarHidden:NO];
    [self initDataSource];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 打点
    [QMUMTookKitManager event:USE_MY_ASSET_KEY label:@"查看我的资产"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (UIBarButtonItem *)rightBarButtonItem {
    UIBarButtonItem *item = [QMNavigationBarItemFactory createNavigationImageButtonWithNormalImage:[UIImage imageNamed:@"top_bar_envelope_icon.png"]
                                                                                           hlImage:[UIImage imageNamed:@"top_bar_envelope_icon.png"]
                                                                                            target:self selector:@selector(gotoMessageCenterViewController) isLeft:NO];
    
    return item;
}

- (void)asyncFetchMyAssertFromServer {
    [[NetServiceManager sharedInstance] getMyAssertInfoWithDelegate:self
                                                            success:^(id responseObject) {
                                                                // 获取成功
                                                                [self handleFetchMyAssertSuccess:responseObject];
                                                            } failure:^(NSError *error) {
                                                                // 获取失败
                                                                [self handleFetchMyAssertFailure:error];
                                                            }];
    
    [[NetServiceManager sharedInstance] getProvinceInfo:nil success:^(id responseObject) {
        NSDictionary *dic = (NSDictionary *)[responseObject objectFromJSONData];
        [[QMProvinceInfo sharedInstance] cutupProvince:dic];
    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"城市信息获取失败"];
    }];
}

- (void)handleFetchMyAssertSuccess:(id)responseObject {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {

        myFundInfo = [[QMMyFundModel alloc] initWithDictionary:responseObject];
        
        myFundInfo.idCardNumber =[[responseObject objectForKey:@"customerAccount"] objectForKey:@"idCardNumber"];
        
        
    }
    
    [self doneLoadingTableViewData];
}

- (void)handleFetchMyAssertFailure:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:QMLocalizedString(@"qm_get_my_asset_info_failed", @"资产信息获取失败")];
    [self doneLoadingTableViewData];
}

- (void)gotoMessageCenterViewController {
    // 打点
    [QMUMTookKitManager event:SHOW_MSG_KEY label:@"显示消息中心"];
    
    QMMessageCenterViewController *con = [[QMMessageCenterViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)reloadData {
    [self asyncFetchMyAssertFromServer];
}

- (void)doneLoadingTableViewData {
    [super doneLoadingTableViewData];
    [(UITableView *)self.scrollView reloadData];
    
    
}

- (void)initDataSource {
    [self asyncFetchMyAssertFromServer];
}

- (UIScrollView *)scrollView {
    if (nil == myFundTable) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        myFundTable = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        myFundTable.alwaysBounceVertical = YES;
        [myFundTable registerClass:[QMBuyedProductInfoHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BUYEDPRODUCTIONINFOSECTION_TITLE_IDENTIFIER];
        [myFundTable registerClass:[QMMyFundTableFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:QM_FUND_FOOTER_IDENTIFIER];
        [myFundTable registerClass:[QMMyFundFooterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:QM_FUND_FOOTERRESUABLE_IDENTIFIER];
        //        [myFundTable registerClass:[QMAccountInfoCell class] forCellWithReuseIdentifier:userInfoCellIdentifier];
        [myFundTable registerClass:[QMMyFundAbstractCell class] forCellWithReuseIdentifier:myFundAbstractCellIdentifier];
        [myFundTable registerClass:[QMBuyedProductInfoCell class] forCellWithReuseIdentifier:buyedProductInfoCellIdentifier];
        [myFundTable registerClass:[QMBaseInfoCell class] forCellWithReuseIdentifier:QM_FUND_BASEIFO_CELL_IDENTIFIER];
        [myFundTable registerClass:[QMFundEmptyCell class] forCellWithReuseIdentifier:QM_FUND_EMPTY_CELL_IDENTIFIER];
        myFundTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
        myFundTable.delegate = self;
        myFundTable.dataSource = self;
        myFundTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return myFundTable;
}

//选择理财产品的界面
- (void)earningMoneyBtnClicked:(id)sender {
    self.tabBarController.selectedIndex = 1;
}

- (void)gotoAmountViewController {
    if (myFundInfo.realNameAuthed) {
        // 已经实名认证
        //进入账户余额界面，包括充值和体现
        QMAccountOpViewController *con = [[QMAccountOpViewController alloc] init];
        [self.navigationController pushViewController:con animated:YES];
    }else {
        // 还没有实名认证，需要进行实名认证
        [self gotoRealNameAuthenticateViewController];
    }
}
//充值
-(void)gotoRechargeController
{
//    [self gotoRealNameAuthenticateViewController];
    
    if (myFundInfo.realNameAuthed  && myFundInfo.ableCardNum.integerValue) {
        QMRechargeViewController *con = [[QMRechargeViewController alloc] init];
        con.isModel = YES;
        QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else
    {
        [self gotoRealNameAuthenticateViewController];
    }
    
}

//体现
-(void)gotoWithDrawController
{
    if (myFundInfo.realNameAuthed && myFundInfo.ableCardNum.integerValue) {
        QMWithDrawViewController *con = [[QMWithDrawViewController alloc] init];
        con.isModel = YES;
        QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else
    {
        [self gotoRealNameAuthenticateViewController];
    }
}
-(void)gotoDealDetailController
{
//    QMDealDetailViewController* con=[[QMDealDetailViewController alloc] init];
//        [con configureRealName:myFundInfo.realName];
//        [self.navigationController pushViewController:con animated:YES];
    
    if (myFundInfo.realNameAuthed) {
    QMDealDetailViewController* con=[[QMDealDetailViewController alloc] init];
    [con configureRealName:myFundInfo.realName];
    [self.navigationController pushViewController:con animated:YES];
    }else{
        [self gotoRealNameAuthenticateViewController];
    }
}

- (void)gotoRealNameAuthenticateViewController {
    // 打点
    [QMUMTookKitManager event:USER_AUTH_REAL_NAME_KEY label:@"用户实名认证"];
    //进入实名验证界面
    QMIdentityAuthenticationViewController *con = [[QMIdentityAuthenticationViewController alloc] init];
    con.isModel = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

-(void)gotoPersonalCenterViewController
{
    // 打点
    [QMUMTookKitManager event:SHOW_PERSONAL_INFO_KEY label:@"显示个人信息"];
    QMAccountInfo *info = [[QMAccountUtil sharedInstance] currentAccount];
    info.isAuthenticated = myFundInfo.realNameAuthed;
    info.isHasPayPwd = myFundInfo.hasPayPwd;
    info.realName = myFundInfo.realName;
    info.identifierCardId = myFundInfo.idCardNumber;
    info.hasRealName = myFundInfo.realNameAuthed;
    info.salesman = myFundInfo.salesman;
    info.channelID = myFundInfo.channelId;
    info.customerCount = myFundInfo.customerCount;
    info.openAccountStatus = myFundInfo.openAccountStatus;
    QMPersonalCenterViewController *con = [[QMPersonalCenterViewController alloc] initViewControllerWithAccountInf:info];
    con.currentAvailabelScore = myFundInfo.availableScore;
    [self.navigationController pushViewController:con
                                         animated:YES];
}
//我的奖励
- (void)gotoGoodsListViewController{
    
//    QMGoodsListViewController *con = [[QMGoodsListViewController alloc] init];
//    con.currentScoreValue=myFundInfo.availableScore;
    
    QMPrizeViewController *con = [[QMPrizeViewController alloc] init];
    
    [self.navigationController pushViewController:con animated:YES];
}

// 充值记录
- (void)gotoRechargeRecordListViewController {
    QMRechargeRecordListViewController *con = [[QMRechargeRecordListViewController alloc] init];
    //跳转到充值记录几面
    [self.navigationController pushViewController:con animated:YES];
}

// 提现记录
- (void)gotowithDrawApplyListViewController {
    QMWithDrawRecordListViewController *con = [[QMWithDrawRecordListViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}
//投资记录
- (void)gotoHistoryListViewController {
    if (myFundInfo.realNameAuthed) {
        NSString *url = [NSString stringWithFormat:@"%@/mycurrPlan?showNav=0",URL_BASE];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [QMWebViewController showWebViewWithRequest:request navTitle:@"投资记录" isModel:NO from:self];
    }else{
        [self gotoRealNameAuthenticateViewController];
    }
}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return QMFundTableSection_Count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger rowCount = 0;
    
    if (QMFundTableSection_Abstract == section) {
        rowCount = 1;
    }else if (QMFundTableSection_BaseInfo==section)
    {
        rowCount=1;
    }
    
    return rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == QMFundTableSection_Abstract) {
        //项目描述:今日收益、总资产、积累资产
        QMMyFundAbstractCell *cell = (QMMyFundAbstractCell *)[collectionView dequeueReusableCellWithReuseIdentifier:myFundAbstractCellIdentifier forIndexPath:indexPath];
       
        [cell configureWithFundInfo:myFundInfo];
        
        return cell;
    }
    else if (indexPath.section==QMFundTableSection_BaseInfo)
    {
        QMBaseInfoCell* cell=(QMBaseInfoCell*)[collectionView dequeueReusableCellWithReuseIdentifier:QM_FUND_BASEIFO_CELL_IDENTIFIER forIndexPath:indexPath];
        [cell.userInfoBtn addTarget:self action:@selector(gotoPersonalCenterViewController) forControlEvents:UIControlEventTouchUpInside];
        [cell.dealDetailBtn addTarget:self action:@selector(gotoDealDetailController) forControlEvents:UIControlEventTouchUpInside];
        [cell.investRecordBtn addTarget:self action:@selector(gotoHistoryListViewController) forControlEvents:UIControlEventTouchUpInside];
        [cell.goodListBtn addTarget:self action:@selector(gotoGoodsListViewController) forControlEvents:UIControlEventTouchUpInside];
        [cell.rechargeBtn addTarget:self action:@selector(gotoRechargeController) forControlEvents:UIControlEventTouchUpInside];
        [cell.withDrawBtn addTarget:self action:@selector(gotoWithDrawController) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
        return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == QMFundTableSection_Abstract) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 10, [QMMyFundAbstractCell getAbstractViewHeightForFundInfo:nil]);
    }
    else if (indexPath.section==QMFundTableSection_BaseInfo)
    {
        return CGSizeMake(CGRectGetWidth(collectionView.frame)-2*10, [QMBaseInfoCell getBaseInfoViewHeightForFundInfo:nil]);
    }
        return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == QMFundTableSection_BaseInfo) {
    }
    
    else if (indexPath.section == QMFundTableSection_Abstract) {
            
        }else if (indexPath.section==QMFundTableSection_BaseInfo)
        {
            
        }
}



-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView* collectionResusableView=nil;
    
    if (indexPath.section==QMFundTableSection_BaseInfo) {
        
        if (kind==UICollectionElementKindSectionFooter) {

            
            if (myFundInfo.isBuy==YES) {
                
                QMMyFundTableFooterView * footerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:QM_FUND_FOOTER_IDENTIFIER forIndexPath:indexPath];
                collectionResusableView=(UICollectionReusableView*)footerView;
                [footerView.productSecureBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                QMMyFundFooterReusableView* footerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:QM_FUND_FOOTERRESUABLE_IDENTIFIER forIndexPath:indexPath];
                footerView.userInteractionEnabled=YES;
                [footerView.productSecureBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
                
                [footerView.actionBtn addTarget:self action:@selector(earningMoneyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                collectionResusableView=(UICollectionReusableView*)footerView;
            }
            
        }
    }
    return collectionResusableView;
}
//打电话
- (void)callPhone{
    
    phoneNumber = QM_OFFICIAL_PHONE_NUMBER;
    if (QM_IS_STR_NIL(phoneNumber)) {
        return;
    }
    
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",phoneNumber]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
        return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == QMFundTableSection_BaseInfo) {
        return UIEdgeInsetsMake(15, 10, 0, 10);
    }else if (section == QMFundTableSection_Abstract) {
        return UIEdgeInsetsMake(15, 10, 0, 10);
    }else {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == QMFundTableSection_BaseInfo) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
        CGSize size = CGSizeMake(CGRectGetWidth(collectionView.frame) - layout.sectionInset.left - layout.sectionInset.right, 100);
        
        return size;
    }
    
    return CGSizeZero;
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_navigation_title_myfund", @"我的资产");
}


@end

