//
//  QMWithDrawRecordListViewController.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/13.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMWithDrawRecordListViewController.h"
#import "QMWithDrawRecordItem.h"
#import "QMWithDrawRecordCell.h"
#import "QMCollectionViewFooterView.h"

#define WITHDRAW_CELL_IDENTIFIER @"WITHDRAW_CELL_IDENTIFIER"
#define WITHDRAW_PAGE_FOOTER_IDENTIFIER @"WITHDRAW_PAGE_FOOTER_IDENTIFIER"

@interface QMWithDrawRecordListViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation QMWithDrawRecordListViewController {
    UICollectionView *withDrawListTable;
    NSMutableArray *withDrawList;
    BOOL isAllDataLoaded;
}

- (void)updateTableFooterView {
    [footView setQMPageFootViewState:footerLoadingState];
}

- (void)asyncFetchMessageListWithOffset:(NSInteger)offset pageSize:(NSInteger)pageSize {
    [[NetServiceManager sharedInstance] getWithDrawRecordListWithChannelId:QM_DEFAULT_CHANNEL_ID
                                                                  pageSize:[NSNumber numberWithInteger:pageSize]
                                                                pageNumber:[NSNumber numberWithInteger:offset]
                                                                  delegate:self success:^(id responseObject) {
                                                                      // add objects
                                                                      if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                                          NSArray *activities = [responseObject objectForKeyedSubscript:kNetWorkList];
                                                                          if ([activities isKindOfClass:[NSArray class]]) {
                                                                              if (offset == 1) {
                                                                                  isAllDataLoaded = NO;
                                                                                  [withDrawList removeAllObjects];
                                                                              }
                                                                              
                                                                              if ([activities count] < QM_FETCH_PAGE_SIZE) {
                                                                                  isAllDataLoaded = YES;
                                                                              }
                                                                              
                                                                              for (NSDictionary *dict in activities) {
                                                                                  QMWithDrawRecordItem *item = [[QMWithDrawRecordItem alloc] initWithDictionary:dict];
                                                                                  [withDrawList addObject:item];
                                                                              }
                                                                          }
                                                                      }
                                                                      
                                                                      
                                                                      [self doneLoadingTableViewData];
                                                                  } failure:^(NSError *error) {
                                                                      [self doneLoadingTableViewData];
                                                                  }];
}

- (void)reloadData {
    [withDrawList removeAllObjects];
    [self asyncFetchMessageListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
}

- (void)doneLoadingTableViewData {
    [super doneLoadingTableViewData];
    [(UICollectionView *)self.scrollView reloadData];
    if (QM_IS_ARRAY_NIL(withDrawList)) {
        [self showEmptyView];
    }else {
        [self hideEmptyView];
    }
    [self updateTableFooterView];
}

- (void)didTriggerLoadNextPageData {
    NSInteger pageNumber = [withDrawList count] / QM_FETCH_PAGE_SIZE + 1;
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
    if (nil == withDrawList) {
        withDrawList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [self asyncFetchMessageListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
}

- (UIScrollView *)customScrollView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 0, 8);
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame) - 2 * 8, [QMWithDrawRecordCell getCellHeightForWithDrawItem:nil]);
    withDrawListTable = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    withDrawListTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [withDrawListTable registerClass:[QMWithDrawRecordCell class] forCellWithReuseIdentifier:WITHDRAW_CELL_IDENTIFIER];
    [withDrawListTable registerClass:[QMCollectionViewFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:WITHDRAW_PAGE_FOOTER_IDENTIFIER];
    withDrawListTable.alwaysBounceVertical = YES;
    withDrawListTable.delegate = self;
    withDrawListTable.dataSource = self;
    
    mScrollView = withDrawListTable;
    
    return mScrollView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [withDrawList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMWithDrawRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WITHDRAW_CELL_IDENTIFIER forIndexPath:indexPath];
    
    QMWithDrawRecordItem *info = nil;
    if (indexPath.row < [withDrawList count]) {
        info = [withDrawList objectAtIndex:indexPath.row];
    }
    
    [cell configureCellWithItemInfo:info];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter] && !QM_IS_ARRAY_NIL(withDrawList)) {
        QMCollectionViewFooterView *pageFooterView = (QMCollectionViewFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:WITHDRAW_PAGE_FOOTER_IDENTIFIER forIndexPath:indexPath];
        footView = pageFooterView.pageFooterView;
        [self updateTableFooterView];
        
        return pageFooterView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (QM_IS_ARRAY_NIL(withDrawList)) {
        return CGSizeZero;
    }else {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 45);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([withDrawList count] > indexPath.row) {
//        QMWithDrawRecordItem *info = [withDrawList objectAtIndex:indexPath.item];
        
    }
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_withdraw_record_list", @"提现记录");
}

@end

