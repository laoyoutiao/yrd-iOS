//
//  QMDealDetailViewController.m
//  MotherMoney
//
//  Created by liuyanfang on 15/8/19.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMDealDetailViewController.h"
#import "QMAccountOpHeaderView.h"
#import "QMDetailCollectionViewCell.h"
#import "QMDetailHeaderView.h"
#import "QMRechargeViewController.h"
#import "QMWithDrawViewController.h"
#import "QMIdentityAuthenticationViewController.h"
#import "NetServiceManager.h"
#import "QMPageFooterView.h"
#define DETAIL_CELL_IDETIFIER @"DETAIL_CELL_IDETIFIER"
#define DETAIL_HEADER_IDETIFIER @"DETAIL_HEADER_IDETIFIER"
#define DETAIL_FOOTER_IDETIFIER @"DETAIL_FOOTER_IDETIFIER"

@interface QMDealDetailViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView* dealDetailTable;

    QMAccountOpHeaderView* header;
    NSString *accountNumber;
    NSMutableArray *dataDetailList;
    BOOL isAllDataLoaded;
    QMPageFootViewState footerLoadingState;
}
@end

@implementation QMDealDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    header=[[QMAccountOpHeaderView alloc] initWithFrame:CGRectZero];

    // Do any additional setup after loading the view.
    [self initDataSource];
    [self setUpSubView];
}
- (void)initDataSource {
    
    
    
    dataDetailList=[[NSMutableArray alloc] initWithCapacity:0];
    
    
    
    [self asyncFetchProductListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
    
    
    
}

- (void)reloadData {

    [self asyncFetchProductListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
    
}
- (void)doneLoadingTableViewData {
    [super doneLoadingTableViewData];
    [(UICollectionView *)self.scrollView reloadData];
    
    if (isAllDataLoaded==YES) {
        footerLoadingState = QMPageFootViewNullDataState;
    }else{
        footerLoadingState = QMPageFootViewNormalState;
    }
    
    if (QM_IS_ARRAY_NIL(dataDetailList)) {
        [self showEmptyView];
        
    }else {
        [self hideEmptyView];
    }

}

- (void)didTriggerLoadNextPageData {
    if (isAllDataLoaded==YES) {
        return;
    }

    NSInteger pageNumber = [dataDetailList count] / QM_FETCH_PAGE_SIZE + 1;
    
    [self asyncFetchProductListWithOffset:pageNumber pageSize:QM_FETCH_PAGE_SIZE];
}

- (void)asyncFetchProductListWithOffset:(NSInteger)offset
                               pageSize:(NSInteger)pageSize {
    
    
    [[NetServiceManager sharedInstance] getDealDetailWithoffset:offset pageSize:pageSize delegate:self success:^(id responseObject) {
        
        if (offset == 1) {
            isAllDataLoaded = NO;
            [dataDetailList removeAllObjects];
            NSString *lastActivity = [QMPreferenceUtil getGlobalKey:ACTIVITY_LAST_UPDATE_TIME];
            [QMPreferenceUtil setGlobalKey:ACTIVITY_LAST_READ_TIME value:lastActivity syncWrite:YES];
            
        }
        [self handleFetchMyAssertSuccess:responseObject];
        
    } failure:^(NSError *error) {

        
        [self handleFetchMyAssertFailure:error];
    }];
}

- (void)handleFetchMyAssertSuccess:(id)responseObject {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSArray *arr = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"list"]];
        if ([arr
             isKindOfClass:[NSArray class]]) {
            if ([arr count] < QM_FETCH_PAGE_SIZE) {
                isAllDataLoaded = YES;
            }
        }
        NSDictionary *dic = [[NSDictionary alloc] init];
        
        for (dic in arr) {
            _detailModel = [[QMDealDetailViewControllerModel alloc] initWithDictionary:dic];
            
            [dataDetailList addObject:_detailModel];
            
            _detailModel.ableWithdrawalAmount = [responseObject objectForKey:@"ableWithdrawalAmount"];
        }
        
        
    }
    
    [self doneLoadingTableViewData];
    
}

- (void)handleFetchMyAssertFailure:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:QMLocalizedString(@"qm_get_my_asset_info_failed", @"资产信息获取失败")];
    
    [self doneLoadingTableViewData];
    
}

-(UIScrollView*)customScrollView
{
    
    if (nil == dealDetailTable) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 8;
        dealDetailTable = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        dealDetailTable.alwaysBounceVertical = YES;
        [dealDetailTable registerClass:[QMDetailCollectionViewCell class] forCellWithReuseIdentifier:DETAIL_CELL_IDETIFIER];
        [dealDetailTable registerClass:[QMPageFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DETAIL_FOOTER_IDETIFIER];
        [dealDetailTable registerClass:[QMDetailHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DETAIL_HEADER_IDETIFIER];
        dealDetailTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
        dealDetailTable.delegate = self;
        dealDetailTable.dataSource = self;
        dealDetailTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return dealDetailTable;

}
-(void)setUpSubView
{
    // 底部按钮
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
    containerView.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [self.view addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(50.0f);
    }];
    //充值按钮
    UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    rechargeBtn.backgroundColor=[UIColor whiteColor];
    [rechargeBtn setTitleColor:[UIColor colorWithRed:112.0f/255.0f green:112.0f/255.0f blue:112.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    //    [rechargeBtn setImage:[UIImage imageNamed:@"recharge_icon"] forState:UIControlStateNormal];
    [rechargeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [rechargeBtn addTarget:self action:@selector(gotoRechargeController) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:rechargeBtn];
    
    //体现按钮
    UIButton *withDrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    withDrawBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    //    [withDrawBtn setImage:[UIImage imageNamed:@"withdraw_icon"] forState:UIControlStateNormal];
    withDrawBtn.backgroundColor=[UIColor whiteColor];
    [withDrawBtn setTitleColor:[UIColor colorWithRed:112.0f/255.0f green:112.0f/255.0f blue:112.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [withDrawBtn setTitle:@"提现" forState:UIControlStateNormal];
    [withDrawBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [withDrawBtn addTarget:self action:@selector(gotoWithDrawController) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:withDrawBtn];
    
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView.mas_left);
        make.top.equalTo(containerView.mas_top);
        make.bottom.equalTo(containerView.mas_bottom);
        make.right.equalTo(withDrawBtn.mas_left);
    }];
    
    [withDrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rechargeBtn.mas_right);
        make.right.equalTo(containerView.mas_right);
        make.top.equalTo(containerView.mas_top);
        make.bottom.equalTo(containerView.mas_bottom);
        make.width.equalTo(rechargeBtn.mas_width);
    }];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor colorWithRed:240.0f / 255.0f green:240.0f / 255.0f blue:240.0f / 255.0f alpha:1.0f];
    [containerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView.mas_centerX);
        make.top.equalTo(containerView.mas_top);
        make.bottom.equalTo(containerView.mas_bottom);
        make.width.equalTo(0.5f);
    }];
}
-(void)configureRealName:(BOOL)hasRealName
{
    
    
    self.hasRealName=hasRealName;
}
//实名验证
- (void)gotoRealNameAuthenticateViewController {
    // 打点
    [QMUMTookKitManager event:USER_AUTH_REAL_NAME_KEY label:@"用户实名认证"];
    //进入实名验证界面
    QMIdentityAuthenticationViewController *con = [[QMIdentityAuthenticationViewController alloc] init];
    con.isModel = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
//recharge
-(void)gotoRechargeController
{
    if (self.hasRealName) {
        QMRechargeViewController *con = [[QMRechargeViewController alloc] init];
        con.isModel = YES;
        QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else
    {
        [self gotoRealNameAuthenticateViewController];
    }
    
}
//withDraw
-(void)gotoWithDrawController
{
    if (self.hasRealName) {
        QMWithDrawViewController *con = [[QMWithDrawViewController alloc] init];
        con.isModel = YES;
        QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else
    {
        [self gotoRealNameAuthenticateViewController];
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataDetailList.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath



{
    QMDetailCollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:DETAIL_CELL_IDETIFIER forIndexPath:indexPath];
    
    if (indexPath.row < [dataDetailList count]) {
        cell.detailCellModel = [dataDetailList objectAtIndex:indexPath.row];
        
       [cell configureDetailCell];
    }
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath


{
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]&&!QM_IS_ARRAY_NIL(dataDetailList)) {
        QMPageFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DETAIL_FOOTER_IDETIFIER forIndexPath:indexPath];
        
        
        [footer setQMPageFootViewState:QMPageFootViewNormalState];
        
        
        
        footView = footer;
        return footer;
    }


    
//        if (!QM_IS_ARRAY_NIL(dataDetailList)) {
    
            
        if (kind==UICollectionElementKindSectionHeader){
            
            
        QMDetailHeaderView* headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DETAIL_HEADER_IDETIFIER forIndexPath:indexPath];
        header.frame=headerView.frame;
        
        header.amount =[_detailModel.ableWithdrawalAmount doubleValue];
        
        [headerView addSubview:header];
        return headerView;
//        }
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (QM_IS_ARRAY_NIL(dataDetailList)) {
        return CGSizeZero;
    }

    return CGSizeMake(self.view.frame.size.width, 50);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    

    if (QM_IS_ARRAY_NIL(dataDetailList)) {
        return CGSizeZero;
    }
    
    
    
    return CGSizeMake(self.view.frame.size.width, 80);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    return CGSizeMake(self.view.frame.size.width, [QMDetailCollectionViewCell getDetailCellHeight]);
}

- (NSString *)title {
    NSString* titleName=@"交易明细";
    return titleName;
}
- (BOOL)isAllDataLoaded {
    return isAllDataLoaded;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
