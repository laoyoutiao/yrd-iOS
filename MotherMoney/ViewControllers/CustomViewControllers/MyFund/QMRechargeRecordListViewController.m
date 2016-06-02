//
//  QMRechargeRecordListViewController.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/13.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMRechargeRecordListViewController.h"
#import "QMRechargeRecordItem.h"
#import "QMCollectionViewFooterView.h"
#import "QMRechargeListCell.h"

#define RECHARGE_CELL_IDENTIFIER @"RECHARGE_CELL_IDENTIFIER"
#define RECHARGE_PAGE_FOOTER_IDENTIFIER @"RECHARGE_PAGE_FOOTER_IDENTIFIER"

@interface QMRechargeRecordListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation QMRechargeRecordListViewController {
    UICollectionView *rechargeListTable;
    NSMutableArray *arrRechargeList;
    BOOL isAllDataLoaded;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initDataSource];
}

- (void)initDataSource {
    if (nil == arrRechargeList) {
        arrRechargeList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    //异步加载充值信息
    [self asyncFetchMessageListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
}

- (UIScrollView *)customScrollView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 0, 8);
    //QMRechargeListCell的高度：60
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame) - 2 * 8, [QMRechargeListCell getCellHeightForRechargeItem:nil]);
    rechargeListTable = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [rechargeListTable registerClass:[QMCollectionViewFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:RECHARGE_PAGE_FOOTER_IDENTIFIER];
    rechargeListTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [rechargeListTable registerClass:[QMRechargeListCell class] forCellWithReuseIdentifier:RECHARGE_CELL_IDENTIFIER];
    rechargeListTable.alwaysBounceVertical = YES;
    rechargeListTable.delegate = self;
    rechargeListTable.dataSource = self;
    
    mScrollView = rechargeListTable;
    
    return mScrollView;
}

- (void)updateTableFooterView {
    [footView setQMPageFootViewState:footerLoadingState];
}


- (void)asyncFetchMessageListWithOffset:(NSInteger)offset pageSize:(NSInteger)pageSize {
    [[NetServiceManager sharedInstance] getRechargeRecordListWithChannelId:QM_DEFAULT_CHANNEL_ID
                                                                  pageSize:[NSNumber numberWithInteger:pageSize]
                                                                pageNumber:[NSNumber numberWithInteger:offset]
                                                                  delegate:self success:^(id responseObject) {
                                                                      // add objects
                                                                      if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                                          NSArray *recordList = [responseObject objectForKeyedSubscript:kNetWorkList];
                                                                          if ([recordList isKindOfClass:[NSArray class]]) {
                                                                              if (offset == 1) {
                                                                                  isAllDataLoaded = NO;
                                                                                  [arrRechargeList removeAllObjects];
                                                                              }
                                                                              
                                                                              if ([recordList count] < QM_FETCH_PAGE_SIZE) {
                                                                                  isAllDataLoaded = YES;
                                                                              }
                                                                              
                                                                              for (NSDictionary *dict in recordList) {
                                                                                  QMRechargeRecordItem *item = [[QMRechargeRecordItem alloc] initWithDictionary:dict];
                                                                                  [arrRechargeList addObject:item];
                                                                              }
                                                                          }
                                                                      }
                                                                      
                                                                      
                                                                      [self doneLoadingTableViewData];
                                                                  } failure:^(NSError *error) {
                                                                      [self doneLoadingTableViewData];
                                                                  }];
}

- (void)reloadData {
    [arrRechargeList removeAllObjects];
    [self asyncFetchMessageListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
}

- (void)doneLoadingTableViewData {
    [super doneLoadingTableViewData];
    [(UITableView *)self.scrollView reloadData];
    if (QM_IS_ARRAY_NIL(arrRechargeList)) {
        [self showEmptyView];
    }else {
        [self hideEmptyView];
    }
    [self updateTableFooterView];
}

- (void)didTriggerLoadNextPageData {
    NSInteger pageNumber = [arrRechargeList count] / QM_FETCH_PAGE_SIZE + 1;
    [self asyncFetchMessageListWithOffset:pageNumber pageSize:QM_FETCH_PAGE_SIZE];
}

- (BOOL)isAllDataLoaded {
    return isAllDataLoaded;
}

////////
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [arrRechargeList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMRechargeListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RECHARGE_CELL_IDENTIFIER forIndexPath:indexPath];
    
    QMRechargeRecordItem *info = nil;
    if (indexPath.row < [arrRechargeList count]) {
        info = [arrRechargeList objectAtIndex:indexPath.row];
    }
    
    [cell configureCellWithItemInfo:info];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter] && !QM_IS_ARRAY_NIL(arrRechargeList)) {
        QMCollectionViewFooterView *pageFooterView = (QMCollectionViewFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:RECHARGE_PAGE_FOOTER_IDENTIFIER forIndexPath:indexPath];
        footView = pageFooterView.pageFooterView;
        [self updateTableFooterView];
        
        return pageFooterView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (QM_IS_ARRAY_NIL(arrRechargeList)) {
        return CGSizeZero;
    }else {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 45);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([arrRechargeList count] > indexPath.row) {
//        QMActivityItemInfo *info = [arrRechargeList objectAtIndex:indexPath.item];
        
    }
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_recharge_record_list", @"充值记录");
}

@end
