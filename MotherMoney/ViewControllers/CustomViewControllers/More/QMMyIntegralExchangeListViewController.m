//
//  QMMyIntegralExchangeListViewController.m
//  MotherMoney

#import "QMMyIntegralExchangeListViewController.h"
#import "QMIntegralExchangeListCell.h"
#import "QMIntegralListHeaderView.h"

#define MY_CELL_IDENTIFIER @"cell_identifier"
#define MY_CELL_HEADER_IDENTIFIER @"header_identifier"
#define MY_CELL_FOOTER_IDENTIFIER @"exchange_footer_identifier"

@interface QMMyIntegralExchangeListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation QMMyIntegralExchangeListViewController {
    UICollectionView *exchangeListTable;
    NSMutableArray *exchangeList;
    QMPageFootViewState footerLoadingState;
}

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
}

- (void)initDataSource {
    exchangeList = [[NSMutableArray alloc] initWithCapacity:0];
    [self asyncFetchProductListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
}
- (void)reloadData{
    
    [self initDataSource];
    
    
}
- (void)doneLoadingTableViewData{
    [super doneLoadingTableViewData];
    [(UITableView *)self.scrollView reloadData];
    if (_isAllDataLoaded==YES) {
        footerLoadingState  = QMPageFootViewNullDataState;
    }else{
        footerLoadingState = QMPageFootViewNormalState;
    }
    if (QM_IS_ARRAY_NIL(exchangeList)) {
        [self showEmptyView];
    }else {
        [self hideEmptyView];
    }
}

- (void)didTriggerLoadNextPageData{
    NSInteger pageNumber = [exchangeList count] / QM_FETCH_PAGE_SIZE + 1;
    [self asyncFetchProductListWithOffset:pageNumber pageSize:QM_FETCH_PAGE_SIZE];
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
                                                                           [exchangeList removeAllObjects];
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
            if (!QM_IS_ARRAY_NIL(list)) {
                [exchangeList removeAllObjects];
            }
            if ([list count]<QM_FETCH_PAGE_SIZE) {
                _isAllDataLoaded=YES;
            }
            
            for (NSDictionary *dict in list) {
                QMIntegralExchangeListItem *item = [[QMIntegralExchangeListItem alloc] initWithDictionary:dict];
                [exchangeList addObject:item];
                
                
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
    if (nil == exchangeListTable) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        
        exchangeListTable = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-40) collectionViewLayout:flowLayout];
        exchangeListTable.alwaysBounceVertical = YES;
        [exchangeListTable registerClass:[QMIntegralExchangeListCell class] forCellWithReuseIdentifier:MY_CELL_IDENTIFIER];
        [exchangeListTable registerClass:[QMIntegralListHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MY_CELL_HEADER_IDENTIFIER];
        [exchangeListTable registerClass:[QMPageFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MY_CELL_FOOTER_IDENTIFIER];
        exchangeListTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
        exchangeListTable.delegate = self;
        exchangeListTable.dataSource = self;
        exchangeListTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return exchangeListTable;
}

- (void)gotoIntegralExchangeListViewController {
    QMMyIntegralExchangeListViewController *con = [[QMMyIntegralExchangeListViewController alloc] init];
    con.isModel = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

- (UICollectionViewCell *)recursionToCell:(UIView *) curView{
    if (curView == nil) {
        return nil;
    }
    if ([curView.superview isKindOfClass:[UICollectionViewCell class]]) {
        return (UICollectionViewCell *)curView.superview;
    }
    else {
        return [self recursionToCell:curView.superview];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [exchangeList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMIntegralExchangeListCell *cell = (QMIntegralExchangeListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MY_CELL_IDENTIFIER forIndexPath:indexPath];
    
    UIImageView *backgroundImageView = (UIImageView *)cell.backgroundView;
    
    cell.horizontalLine.hidden = YES;
    if ([exchangeList count] == 1) {
        backgroundImageView.image = [QMImageFactory commonBackgroundImageBottomPart];
    }else if (indexPath.row == [exchangeList count] - 1) {
        backgroundImageView.image = [QMImageFactory commonBackgroundImageBottomPart];
    }else {
        backgroundImageView.image = [QMImageFactory commonBackgroundImageCenterPart];
        cell.horizontalLine.hidden = NO;
    }
    
    if (indexPath.row < [exchangeList count]) {
        QMIntegralExchangeListItem *item = [exchangeList objectAtIndex:indexPath.row];
        [cell configureCellWithItem:item];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (exchangeList.count>=10)  {
        
        QMPageFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MY_CELL_FOOTER_IDENTIFIER forIndexPath:indexPath];
        
        [footer setQMPageFootViewState:footerLoadingState];
        
        footView = footer;
        
        return footer;
    }
    QMIntegralListHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MY_CELL_HEADER_IDENTIFIER forIndexPath:indexPath];
    
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 10, [QMIntegralExchangeListCell getCellHeightWithItem:nil]);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (!QM_IS_ARRAY_NIL(exchangeList)) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 10, 40.0f);
    }
    
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForfooterInSection:(NSInteger)section {
    if (exchangeList.count>=10) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 10, 40.0f);
    }
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 10, 10);
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_integral_exchange_list", @"兑换记录");
}

@end
