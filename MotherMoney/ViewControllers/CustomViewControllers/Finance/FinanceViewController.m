//
//  FinanceViewController.m
//  MotherMoney
//
//  Created by on 14-8-3.
//  Copyright (c) 2014年. All rights reserved.
//

#import "FinanceViewController.h"
#import "QMProductInfo.h"
#import "QMProductListCell.h"
#import "QMCreditorsInfo.h"
#import "QMCreditorsListCell.h"
#define PRODUCT_LIST_CELL_IDENTIFIER  @"product_list_cell_identifier"
#define CREDITORS_LIST_CELL_IDENTIFIER  @"creditors_list_cell_identifier"
#define LOADMORE_PAGE_FOOTER_VIEW_IDENTIFIER @"loadmore_page_footer_view_identifier"
#define LOADMORE_PAGE_HEADER_VIEW_IDENTIFIER @"loadmore_page_header_view_identifier"

#define PREFERENCE_BANNER_CLOSED @"preference_banner_closed"

@interface FinanceViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation FinanceViewController {
    //网格
    UICollectionView *productListTable;
    //数据源：产品列表
    NSMutableArray *productList;
    //是否完全下载完
    BOOL isAllDataLoaded;
    NSString *mChannelId;
    //
    UIView* pushView;
    UITextField* pushTextField;
    
    BOOL isProductList;
}

- (id)initViewControllerWithChannelId:(NSString *)channelId {
    if (self = [super init]) {
        mChannelId = channelId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self productListViewChangeFrame];
//    [self headViewButtonBuild];
    [self initDataSource];
    isProductList = YES;
    if (ON_LINE==0) {
//        [self initPushView];
    }
}

- (void)headViewButtonBuild
{
    [productListButton addTarget:self action:@selector(clickProductList) forControlEvents:UIControlEventTouchUpInside];
    [creditorsListBUtton addTarget:self action:@selector(clickCreditors) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickProductList
{
    isProductList = YES;
    [productList removeAllObjects];
    productListButton.backgroundColor = QM_COMMON_HEADBUTTON_COLOR;
    creditorsListBUtton.backgroundColor = [UIColor whiteColor];
    [productListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [creditorsListBUtton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self asyncFetchProductListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
}

- (void)clickCreditors
{
    isProductList = NO;
    [productList removeAllObjects];
    productListButton.backgroundColor = [UIColor whiteColor];
    creditorsListBUtton.backgroundColor = QM_COMMON_HEADBUTTON_COLOR;
    [productListButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [creditorsListBUtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self asyncFetchCreditorsListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
}

-(void)initPushView
{
    pushView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    pushView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:pushView];
    pushTextField=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width-20*2, 30)];
    pushTextField.backgroundColor=[UIColor whiteColor];
    [pushView addSubview:pushTextField];
//    UIButton* cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
//    cancelBtn.frame=CGRectMake(20, 50,60, 40);
//    [cancelBtn setTintColor:[UIColor blackColor]];
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [pushView addSubview:cancelBtn];
    
    UIButton* YesBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    YesBtn.frame=CGRectMake(pushView.frame.size.width-80,50,60, 40);
    [YesBtn addTarget:self action:@selector(yesAction:) forControlEvents:UIControlEventTouchUpInside];
    [YesBtn setTitle:@"确定" forState:UIControlStateNormal];
    [YesBtn setTintColor:[UIColor blackColor]];
    [pushView addSubview:YesBtn];
    
}
-(void)yesAction:(id)sender
{
    NSString* productId=pushTextField.text;
    if (productId) {
        if (productList) {
            if(isProductList)
            {
                QMProductInfo *info = [[QMProductInfo alloc] init];
                info.product_id =productId;
                [self gotoProductDetailInfoViewController:info];
            }else
            {
                QMCreditorsInfo *info = [[QMCreditorsInfo alloc] init];
                info.product_id =productId;
                [self gotoCreditorsDetailInfoViewController:info];
            }
        }
        else
        {
            NSLog(@"productList is nil");
        }
    }
}
//-(void)cancelAction:(id)sender
//{
//    CGRect frame=CGRectMake(0, -184, self.view.frame.size.width, 120);
//    pushView.frame=frame;
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [bannerView.timer setFireDate:[NSDate date]];//开启定时器
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [bannerView.timer setFireDate:[NSDate distantFuture]];
}

- (void)initDataSource {
    productList = [[NSMutableArray alloc] initWithCapacity:0];
    [self asyncFetchProductListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
}

//异步加载产品列表
- (void)asyncFetchProductListWithOffset:(NSInteger)offset
                               pageSize:(NSInteger)pageSize {
    [[NetServiceManager sharedInstance] getProductListWithWithChannelId:mChannelId
                                                                 offset:offset
                                                               pageSize:pageSize
                                                               delegate:self
                                                                success:^(id responseObject) {
                                                                    if (1 == offset) {
                                                                        [productList removeAllObjects];
                                                                    }
                                                                    [self handleFetchProductListSuccess:responseObject];
                                                                } failure:^(NSError *error) {
                                                                    [self handleFetchProductListFailure:error];
                                                                }];
}


- (void)asyncFetchCreditorsListWithOffset:(NSInteger)offset
                               pageSize:(NSInteger)pageSize {
    
    [[NetServiceManager sharedInstance] getCreditorsListWithWithChannelId:mChannelId
                                                                 offset:offset
                                                               pageSize:pageSize
                                                               delegate:self
                                                                success:^(id responseObject) {
                                                                    if (1 == offset) {
                                                                        [productList removeAllObjects];
                                                                    }
                                                                    [self handleFetchCreditorsListSuccess:responseObject];
                                                                } failure:^(NSError *error) {
                                                                    [self handleFetchProductListFailure:error];
                                                                }];
}


//产品列表加载成功
- (void)handleFetchProductListSuccess:(id)responseObject {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSArray *products = (NSArray *)[responseObject objectForKey:kNetWorkList];
        isAllDataLoaded = NO;
        if ([products isKindOfClass:[NSArray class]]) {
            if ([products count] < QM_FETCH_PAGE_SIZE) {
                isAllDataLoaded = YES;
            }
            
            for (NSDictionary *dict in products) {
                QMProductInfo *info = [[QMProductInfo alloc] initWithDictionary:dict];
                
                if (info) {
                    [productList addObject:info];
                }
            }
        }
    }
    
    [self doneLoadingTableViewData];
}

- (void)handleFetchCreditorsListSuccess:(id)responseObject {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSArray *products = (NSArray *)[responseObject objectForKey:kNetWorkList];
        isAllDataLoaded = NO;
        if ([products isKindOfClass:[NSArray class]]) {
            if ([products count] < QM_FETCH_PAGE_SIZE) {
                isAllDataLoaded = YES;
            }
            
            for (NSDictionary *dict in products) {
                QMCreditorsInfo *info = [[QMCreditorsInfo alloc] initWithDictionary:dict];
                
                if (info) {
                    [productList addObject:info];
                }
            }
        }
    }
    
    [self doneLoadingTableViewData];
}

- (void)handleFetchProductListFailure:(NSError *)error {
//    [self doneLoadingTableViewData];
    if (isProductList)
    {
        [self handleFetchProductListSuccess:nil];
    }else
    {
        [self handleFetchCreditorsListSuccess:nil];
    }
}

- (void)refreshBtnClicked:(id)sender {
    LNLogInfo(@"refreshBtnClicked !!!");
    
    [self.scrollView setContentOffset:CGPointMake(0, -66) animated:NO];
    [mRefreshHeaderView egoRefreshScrollViewDidEndDragging:self.scrollView];
}

#pragma mark -
#pragma mark Override mthoeds
- (UIScrollView *)customScrollView {
    //新建布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    //设置网格
    CGRect rect = self.view.bounds;
    productListTable = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    productListTable.alwaysBounceVertical = YES;
    productListTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    productListTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [productListTable registerClass:[QMProductListCell class] forCellWithReuseIdentifier:PRODUCT_LIST_CELL_IDENTIFIER];
    [productListTable registerClass:[QMCreditorsListCell class] forCellWithReuseIdentifier:CREDITORS_LIST_CELL_IDENTIFIER];
    [productListTable registerClass:[QMPageFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:LOADMORE_PAGE_FOOTER_VIEW_IDENTIFIER];
    productListTable.delegate = self;
    productListTable.dataSource = self;
    return productListTable;
}

- (void)reloadData {
    if (isProductList)
    {
        [self asyncFetchProductListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
    }else
    {
        [self asyncFetchCreditorsListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
    }
}


- (void)doneLoadingTableViewData {
    [super doneLoadingTableViewData];
    [(UICollectionView *)self.scrollView reloadData];
    if (QM_IS_ARRAY_NIL(productList)) {
        [self showEmptyView];
    }else {
        [self hideEmptyView];
    }
}

- (void)didTriggerLoadNextPageData {
    NSInteger pageNumber = [productList count] / QM_FETCH_PAGE_SIZE + 1;
    if (isProductList)
    {
        [self asyncFetchProductListWithOffset:pageNumber pageSize:QM_FETCH_PAGE_SIZE];
    }else
    {
        [self asyncFetchCreditorsListWithOffset:pageNumber pageSize:QM_FETCH_PAGE_SIZE];
    }
}

- (BOOL)isAllDataLoaded {
    return isAllDataLoaded;
}

- (void)setUpProductListTable {
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.minimumLineSpacing = 8;
//    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
//    productListTable = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
//    productListTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
//    productListTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [productListTable registerClass:[QMProductListCell class] forCellWithReuseIdentifier:PRODUCT_LIST_CELL_IDENTIFIER];
//    productListTable.delegate = self;
//    productListTable.dataSource = self;
//    [self.view addSubview:productListTable];
}

#pragma mark -
#pragma mark UICollectionViewDataSource & Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [productList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isProductList) {
        QMProductListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PRODUCT_LIST_CELL_IDENTIFIER forIndexPath:indexPath];
        //    cell.backgroundColor = [UIColor orangeColor];
        if (indexPath.row < [productList count]) {
            QMProductInfo *info = [productList objectAtIndex:indexPath.row];
            //实现产品cell的显示，cell的返回高度：130
            [cell configureCellWithProductionInfo:info];
        }
        return cell;
    }else
    {
        QMCreditorsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CREDITORS_LIST_CELL_IDENTIFIER forIndexPath:indexPath];

        if (indexPath.row < [productList count]) {
            QMCreditorsInfo *info = [productList objectAtIndex:indexPath.row];
            //实现产品cell的显示，cell的返回高度：130
            [cell configureCellWithProductionInfo:info];
        }
        return cell;
    }
}
//选中cell实现的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 打点
    [QMUMTookKitManager event:USER_CLICK_Buy_InPRODUCTLIST_KEY label:@"点击列表产品"];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [productList count]) {
        if (isProductList) {
            QMProductInfo *info = [productList objectAtIndex:indexPath.row];
            //跳转产品详情页面
            [self gotoProductDetailInfoViewController:info];
        }else
        {
            QMCreditorsInfo *info = [productList objectAtIndex:indexPath.row];
            //跳转产品详情页面
            [self gotoCreditorsDetailInfoViewController:info];
        }
    }
}

//返回每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat padding = ((UICollectionViewFlowLayout *)collectionView.collectionViewLayout).sectionInset.left;
    if (isProductList)
    {
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * padding, [QMProductListCell getCellHeightForProductInfo:nil]);
    }else
    {
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * padding, [QMCreditorsListCell getCellHeightForProductInfo:nil]);
    }
}

//cell footer和headerView的返回
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //footerView
    if ([kind isEqualToString:UICollectionElementKindSectionFooter] && !QM_IS_ARRAY_NIL(productList)) {
        QMPageFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:LOADMORE_PAGE_FOOTER_VIEW_IDENTIFIER forIndexPath:indexPath];
        [footer setQMPageFootViewState:footerLoadingState];
        
        footView = footer;
        
        return footer;
    }
    return nil;
}
//返回footerView的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (!QM_IS_ARRAY_NIL(productList)) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 50.0f);
    }else {
        return CGSizeZero;
    }
}

- (void)gotoProductDetailInfoViewController:(QMProductInfo *)productInfo {
    if (nil == productInfo) {
        return;
    }
    
    QMProductInfoViewController *con = [[QMProductInfoViewController alloc] initViewControllerWithProductInfo:productInfo];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)gotoCreditorsDetailInfoViewController:(QMCreditorsInfo *)productInfo {
    if (nil == productInfo) {
        return;
    }
    
    QMCreditorsInfoViewController *con = [[QMCreditorsInfoViewController alloc] initViewControllerWithProductInfo:productInfo];
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_navigation_title_finance", @"理财产品");
}

@end
