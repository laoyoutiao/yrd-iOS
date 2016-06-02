//
//  QMActivityCenterViewController.m
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import "QMActivityCenterViewController.h"
#import "QMActivityItemInfo.h"
#import "QMActivityItemInfoCell.h"
#import "QMCollectionViewFooterView.h"
#import "MoreViewController.h"

#define ACTIVITY_CELL_IDENTIFIER @"activity_cell_identifier"
#define ACTIVITY_PAGE_FOOTER_IDENTIFIER @"activity_page_footer_identifier"

@interface QMActivityCenterViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation QMActivityCenterViewController {
    UICollectionView *activityTable;
    NSMutableArray *arrActivityItems;
    BOOL isAllDataLoaded;
}

- (void)updateTableFooterView {
    
    [footView setQMPageFootViewState:footerLoadingState];
    
}

- (void)asyncFetchMessageListWithOffset:(NSInteger)offset pageSize:(NSInteger)pageSize {
    [[NetServiceManager sharedInstance] activityCenterListWithPageSize:[NSNumber numberWithInteger:pageSize]
                                                            pageNumber:[NSNumber numberWithInteger:offset]
                                                              delegate:self
                                                               success:^(id responseObject) {
                                                                   // add objects
                                                                   if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                                       NSArray *activities = [responseObject objectForKeyedSubscript:kNetWorkList];
                                                                       if ([activities isKindOfClass:[NSArray class]]) {
                                                                           if (offset == 1) {
                                                                               isAllDataLoaded = NO;
                                                                               [arrActivityItems removeAllObjects];
                                                                               
                                                                               // 更新时间
                                                                               NSString *lastActivity = [QMPreferenceUtil getGlobalKey:ACTIVITY_LAST_UPDATE_TIME];
                                                                               [QMPreferenceUtil setGlobalKey:ACTIVITY_LAST_READ_TIME value:lastActivity syncWrite:YES];
                                                                           }
                                                                           
                                                                           if ([activities count] < QM_FETCH_PAGE_SIZE) {
                                                                               isAllDataLoaded = YES;
                                                                           }
                                                                           
                                                                           for (NSDictionary *dict in activities) {
                                                                               QMActivityItemInfo *item = [[QMActivityItemInfo alloc] initWithDictionary:dict];
                                                                               [arrActivityItems addObject:item];
                                                                           }
                                                                       }
                                                                   }
                                                                   
                                                                   
                                                                   [self doneLoadingTableViewData];
                                                               } failure:^(NSError *error) {
                                                                   [self doneLoadingTableViewData];
                                                               }];
}

- (void)reloadData {

    [self asyncFetchMessageListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
}

- (void)doneLoadingTableViewData {
    [super doneLoadingTableViewData];
    [(UICollectionView *)self.scrollView reloadData];
    if (QM_IS_ARRAY_NIL(arrActivityItems)) {
        [self showEmptyView];
    }else {
        [self hideEmptyView];
    }
    [self updateTableFooterView];
}

- (void)didTriggerLoadNextPageData {
    NSInteger pageNumber = [arrActivityItems count] / QM_FETCH_PAGE_SIZE + 1;
    [self asyncFetchMessageListWithOffset:pageNumber pageSize:QM_FETCH_PAGE_SIZE];
}

- (BOOL)isAllDataLoaded {
    return isAllDataLoaded;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    
}

- (void)initDataSource {
    if (nil == arrActivityItems) {
        arrActivityItems = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [self asyncFetchMessageListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
}

- (UIScrollView *)customScrollView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 0, 8);
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame) - 2 * 8, [QMActivityItemInfoCell getCellHeightForActivityInfo:nil]);
    activityTable = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    activityTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [activityTable registerClass:[QMActivityItemInfoCell class] forCellWithReuseIdentifier:ACTIVITY_CELL_IDENTIFIER];
    [activityTable registerClass:[QMCollectionViewFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ACTIVITY_PAGE_FOOTER_IDENTIFIER];
    activityTable.alwaysBounceVertical = YES;
    activityTable.delegate = self;
    activityTable.dataSource = self;

    mScrollView = activityTable;
    
    return mScrollView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [arrActivityItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMActivityItemInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ACTIVITY_CELL_IDENTIFIER forIndexPath:indexPath];
    
    QMActivityItemInfo *info = nil;
    if (indexPath.row < [arrActivityItems count]) {
        info = [arrActivityItems objectAtIndex:indexPath.row];
    }
    
    [cell configureCellWithItemInfo:info];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter] && !QM_IS_ARRAY_NIL(arrActivityItems)) {
        QMCollectionViewFooterView *pageFooterView = (QMCollectionViewFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ACTIVITY_PAGE_FOOTER_IDENTIFIER forIndexPath:indexPath];
        footView = pageFooterView.pageFooterView;
        [self updateTableFooterView];
        
        return pageFooterView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (QM_IS_ARRAY_NIL(arrActivityItems)) {
        return CGSizeZero;
    }else {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 45);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([arrActivityItems count] > indexPath.row) {
        QMActivityItemInfo *info = [arrActivityItems objectAtIndex:indexPath.item];
        if (!QM_IS_STR_NIL(info.url)) {
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[info.url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
            [QMWebViewController showWebViewWithRequest:request
                                               navTitle:info.name
                                                isModel:YES
                                                   from:self];
        }
    }
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_more_activity_center_title", @"活动中心");
}

@end

