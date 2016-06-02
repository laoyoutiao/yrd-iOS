//
//  QMGoodListDetailViewController.m
//  MotherMoney
//
//  Created by liuyanfang on 15/8/14.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMGoodListDetailViewController.h"
#import "QMGoodListCollectionViewCell.h"
#import "QMDetailHeaderView.h"
#import "QMGoodListDetailModel.h"
#import "UIViewExt.h"
#define DETAIL_CELL_IDETIFIER @"DETAIL_CELL_IDETIFIER"
#define  DETAIL_HEADER_IDETIFIER @"DETAIL_HEADER_IDETIFIER"
#define  DETAIL_FOOTER_IDETIFIER @"DETAIL_FOOTER_IDETIFIER"

@interface QMGoodListDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    
    UICollectionView* detailTable;
    NSMutableArray* detailLists;
    BOOL isAllDataLoaded;
    float width;
    float height;
    QMPageFooterView *footer;
    QMPageFootViewState footerLoadingState;
    UIView *heartView;
    QMDetailHeaderView* headerView;
}

@end

@implementation QMGoodListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=QM_COMMON_BACKGROUND_COLOR;
    detailLists=[[NSMutableArray alloc] init];
    width=self.view.frame.size.width;
    height=self.view.frame.size.height;
    [self initDataSource];
//    [self creatHeatView];

}
- (void)creatHeatView{
    heartView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    
    heartView.backgroundColor = [UIColor whiteColor];
    
    UILabel* remaningValueLabel = [[UILabel alloc] initWithFrame:heartView.frame];
    
    NSString *str = [NSString stringWithFormat:@"当前金币   %@",self.currentScore];
    NSMutableAttributedString* remainningStr=[[NSMutableAttributedString alloc] initWithString:str];
    remaningValueLabel.textColor=[UIColor colorWithRed:236.0f/255.0f green:71.0f/255.0f blue:59.0f/255.0f alpha:1];
    remaningValueLabel.font=[UIFont systemFontOfSize:18];
    [remainningStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:119.0f/255.0f green:119.0f/255.0f blue:119.0f/255.0f alpha:1] range:NSMakeRange(0, 4)];
    [remainningStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 4)];
    remaningValueLabel.attributedText=remainningStr;
    
    remaningValueLabel.textAlignment = NSTextAlignmentRight;

    [heartView addSubview:remaningValueLabel];
    [self.view addSubview:heartView];
}
- (void)initDataSource{
    [self asyncFetchProductListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
}
-(void)reloadData
{
    [self asyncFetchProductListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];

    
}
- (void)asyncFetchProductListWithOffset:(NSInteger)offset
                               pageSize:(NSInteger)pageSize {
    [[NetServiceManager sharedInstance] getGoodListDetailWithoffset:offset pageSize:pageSize delegate:self success:^(id responseObject) {
        if (offset == 1) {
            isAllDataLoaded = NO;
            [detailLists removeAllObjects];
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
        
        NSArray *list = [responseObject objectForKey:@"list"];
        
        NSNumber *avaiScore = [responseObject objectForKey:@"availableScore"];

        self.currentScore = avaiScore;
        isAllDataLoaded = NO;
        if ([list isKindOfClass:[NSArray class]]) {
            
        
        if ([list count] < QM_FETCH_PAGE_SIZE) {
            
           isAllDataLoaded = YES;
        
        }

        for (NSDictionary *dic in list) {
            _goodListModel = [[QMGoodListDetailModel alloc] initWithDictionary:dic];
            
            
            
            [detailLists addObject:_goodListModel];
        }
      }
    }
    [self doneLoadingTableViewData];
}

- (void)handleFetchMyAssertFailure:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:QMLocalizedString(@"qm_get_my_asset_info_failed", @"资产信息获取失败")];
    
}

- (void)doneLoadingTableViewData {
    [super doneLoadingTableViewData];
    [(UICollectionView *)self.scrollView reloadData];
    

    if (isAllDataLoaded==YES) {
        footerLoadingState = QMPageFootViewNullDataState;
    }else{
        footerLoadingState = QMPageFootViewNormalState;
    }
    if (QM_IS_ARRAY_NIL(detailLists)) {
        [self showEmptyView];
    }else {
        [self hideEmptyView];
    }
}
- (void)didTriggerLoadNextPageData {
    NSInteger pageNumber = [detailLists count] / QM_FETCH_PAGE_SIZE + 1;
    
    [self asyncFetchProductListWithOffset:pageNumber pageSize:QM_FETCH_PAGE_SIZE];
    
}
-(UIScrollView*)customScrollView
{
    if (nil == detailTable) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5;
        
        detailTable = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        detailTable.alwaysBounceVertical = YES;
        [detailTable registerClass:[QMGoodListCollectionViewCell class] forCellWithReuseIdentifier:DETAIL_CELL_IDETIFIER];
        [detailTable registerClass:[QMDetailHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DETAIL_HEADER_IDETIFIER];
        [detailTable registerClass:[QMPageFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DETAIL_FOOTER_IDETIFIER];
        detailTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
        detailTable.delegate = self;
        detailTable.dataSource = self;
        detailTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
        
        
    }
    return detailTable;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return detailLists.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    QMGoodListCollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:DETAIL_CELL_IDETIFIER forIndexPath:indexPath];
    if (indexPath.row < [detailLists count]) {
        cell.goodListCellModel = detailLists[indexPath.item];
        [cell configureDetailCell];
    }
    
    return cell;
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]&&detailLists.count>=10)  {

        footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DETAIL_FOOTER_IDETIFIER forIndexPath:indexPath];

        [footer setQMPageFootViewState:footerLoadingState];
        
        footView = footer;
        
        return footer;
    }
    if (kind==UICollectionElementKindSectionHeader&&!QM_IS_ARRAY_NIL(detailLists)) {

         headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DETAIL_HEADER_IDETIFIER forIndexPath:indexPath];
       
        NSString *str = [NSString stringWithFormat:@"当前金币   %@",self.currentScore];
        NSMutableAttributedString* remainningStr=[[NSMutableAttributedString alloc] initWithString:str];
        headerView.remaningValueLabel.textColor=[UIColor colorWithRed:236.0f/255.0f green:71.0f/255.0f blue:59.0f/255.0f alpha:1];
        headerView.remaningValueLabel.font=[UIFont systemFontOfSize:18];
        [remainningStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:119.0f/255.0f green:119.0f/255.0f blue:119.0f/255.0f alpha:1] range:NSMakeRange(0, 4)];
        [remainningStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 4)];
        headerView.remaningValueLabel.attributedText=remainningStr;;
        
        return headerView;
        
    }
    else
        return nil;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (QM_IS_ARRAY_NIL(detailLists)) {
        return CGSizeZero;
    }
    return CGSizeMake(width, 40);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (detailLists.count<10) {
        return CGSizeZero;
    }
    return CGSizeMake(width, 40);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(width,[QMGoodListCollectionViewCell getDetailCellHeight]);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}
- (BOOL)isAllDataLoaded{

    return isAllDataLoaded;
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat offset = detailTable.contentOffset.y;
//    
//    if (offset<0) {
//        
//        [heartView setBottom:-offset];
//        
//        
//    }
//}
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    [heartView removeFromSuperview];
//}
#pragma override
- (NSString *)title {
    NSString* titleName=@"金币明细";
    return titleName;
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
