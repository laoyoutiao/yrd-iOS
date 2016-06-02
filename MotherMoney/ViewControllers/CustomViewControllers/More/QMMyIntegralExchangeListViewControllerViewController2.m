//
//  QMMyIntegralExchangeListViewControllerViewController2.m
//  MotherMoney
//
//  Created by liuyanfang on 15/9/9.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMMyIntegralExchangeListViewControllerViewController2.h"
#import "QMIntegralExchangeListCell.h"
#import "QMIntegralListHeaderView.h"

#define MY_CELL_IDENTIFIER @"cell_identifier"
#define MY_CELL_HEADER_IDENTIFIER @"header_identifier"
#define MY_CELL_FOOTER_IDENTIFIER @"exchange_footer_identifier"
@interface QMMyIntegralExchangeListViewControllerViewController2 ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

{
    UICollectionView *exchangeTable;
    NSMutableArray *exchangeLists;
    QMPageFootViewState footerLoadingState;
    QMPageFooterView *footer;
}
@end

@implementation QMMyIntegralExchangeListViewControllerViewController2
- (UIBarButtonItem *)leftBarButtonItem {
    return [QMNavigationBarItemFactory createNavigationBackItemWithTarget:self selector:@selector(goBack)];
}

- (void)goBack {
    if (self.isModel) {
        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     
                                 }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    [self initDataSource];
    if ([exchangeLists count] == 0) {
        UIAlertView *alert =  [ [UIAlertView alloc] initWithTitle:nil message:@"我们正在精心帮您挑选礼品,敬请期待" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1.5];
        
        
    }

}
- (void)dimissAlert:(UIAlertView *)alert {
    NSLog(@"==================================");
    if(alert)     {
        
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        
    }
    
}
- (void)initDataSource{
    exchangeLists = [[NSMutableArray alloc] initWithCapacity:0];
    [self asyncFetchProductListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];

}
- (void)reloadData{
    
    [self asyncFetchProductListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
    
    
}
- (void)doneLoadingTableViewData{
    [super doneLoadingTableViewData];
    [(UITableView *)self.scrollView reloadData];
    if (_isAllDataLoaded==YES) {
        footerLoadingState  = QMPageFootViewNullDataState;
    }else{
        footerLoadingState = QMPageFootViewNormalState;
    }
    if (QM_IS_ARRAY_NIL(exchangeLists)) {
        [self showEmptyView];
    }else {
        [self hideEmptyView];
    }
}

- (void)didTriggerLoadNextPageData{
    NSInteger pageNumber = [exchangeLists count] / QM_FETCH_PAGE_SIZE + 1;
    [self asyncFetchProductListWithOffset:pageNumber pageSize:QM_FETCH_PAGE_SIZE];
    NSLog(@"%ld",(unsigned long)exchangeLists.count);
}

- (BOOL)isAllDataLoaded{
    return _isAllDataLoaded;
}
-(void)asyncFetchProductListWithOffset:(NSInteger)offset
                              pageSize:(NSInteger)pageSize  {
    [[NetServiceManager sharedInstance] myIntegralExchangeListWithPageSize:[NSNumber numberWithInteger:pageSize]
                                                                pageNumber:[NSNumber numberWithInteger:offset]
                                                                  delegate:self
                                                                   success:^(id responseObject) {
                                                                       if (offset==1) {
                                                                           [exchangeLists removeAllObjects];
                                                                           NSString *lastActivity = [QMPreferenceUtil getGlobalKey:ACTIVITY_LAST_UPDATE_TIME];
                                                                           [QMPreferenceUtil setGlobalKey:ACTIVITY_LAST_READ_TIME value:lastActivity syncWrite:YES];
                                                                       }
                                                                       // 获取成功
                                                                       [self handleFetchExchangeListSuccess:responseObject];
                                                                   } failure:^(NSError *error) {
                                                                       // 获取失败
                                                                       [self handleFetchExchangeListFailure:error];
                                                                   }];
}

- (void)handleFetchExchangeListSuccess:(id)responseObject {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSArray *list = [responseObject objectForKey:kNetWorkList];
        _isAllDataLoaded = NO;
        if ([list isKindOfClass:[NSArray class]]) {
            if ([list count]<QM_FETCH_PAGE_SIZE) {
                _isAllDataLoaded=YES;
            }
            
            for (NSDictionary *dict in list) {
                QMIntegralExchangeListItem *item = [[QMIntegralExchangeListItem alloc] initWithDictionary:dict];
                [exchangeLists addObject:item];
                
                
            }
            
        }
    }
    
    [self doneLoadingTableViewData];
}

- (void)handleFetchExchangeListFailure:(NSError *)error {
    [CMMUtility showNoteWithError:error];
    [self doneLoadingTableViewData];
}
- (UIScrollView *)scrollView {
    if (nil == exchangeTable) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5;
        
        exchangeTable = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-40) collectionViewLayout:flowLayout];
        exchangeTable.alwaysBounceVertical = YES;
        [exchangeTable registerClass:[QMIntegralExchangeListCell class] forCellWithReuseIdentifier:MY_CELL_IDENTIFIER];
        [exchangeTable registerClass:[QMIntegralListHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MY_CELL_HEADER_IDENTIFIER];
        [exchangeTable registerClass:[QMPageFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MY_CELL_FOOTER_IDENTIFIER];
        exchangeTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
        exchangeTable.delegate = self;
        exchangeTable.dataSource = self;
        exchangeTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return exchangeTable;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return exchangeLists.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    QMIntegralExchangeListCell *cell = (QMIntegralExchangeListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MY_CELL_IDENTIFIER forIndexPath:indexPath];
    
    UIImageView *backgroundImageView = (UIImageView *)cell.backgroundView;
    
    cell.horizontalLine.hidden = YES;
    if ([exchangeLists count] == 1) {
        backgroundImageView.image = [QMImageFactory commonBackgroundImageBottomPart];
    }else if (indexPath.row == [exchangeLists count] - 1) {
        backgroundImageView.image = [QMImageFactory commonBackgroundImageBottomPart];
    }else {
        backgroundImageView.image = [QMImageFactory commonBackgroundImageCenterPart];
        cell.horizontalLine.hidden = NO;
    }
    
    if (indexPath.row < [exchangeLists count]) {
        QMIntegralExchangeListItem *item = [exchangeLists objectAtIndex:indexPath.row];
        [cell configureCellWithItem:item];
    }
    
    return cell;
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]&&exchangeLists.count>=10)  {
        
        footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MY_CELL_FOOTER_IDENTIFIER forIndexPath:indexPath];
        
        [footer setQMPageFootViewState:footerLoadingState];
        
        footView = footer;
        
        return footer;
    }
    if (kind==UICollectionElementKindSectionHeader&&!QM_IS_ARRAY_NIL(exchangeLists)) {
           QMIntegralListHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MY_CELL_HEADER_IDENTIFIER forIndexPath:indexPath];
        
        return header;
        
    }
    else
        return nil;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (exchangeLists.count<10) {
        return CGSizeZero;
    }
    return CGSizeMake(self.view.bounds.size.width, 40);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (exchangeLists.count<10) {
        return CGSizeZero;
    }
    return CGSizeMake(self.view.bounds.size.width, 40);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 10, [QMIntegralExchangeListCell getCellHeightWithItem:nil]);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}
//- (BOOL)isAllDataLoaded{
//    
//    return _isAllDataLoaded;
//}
#pragma override
- (NSString *)title {
    NSString* titleName=@"兑换记录";
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
