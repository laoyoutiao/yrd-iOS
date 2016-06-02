//
//  QMAssistCenterViewController.m
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import "QMAssistCenterViewController.h"
#import "QMAssistItem.h"
#import "QMAssistItemCell.h"
#import "QMCollectionViewFooterView.h"


#define HELPCENTER_CELL_IDENTIFIER @"activity_cell_identifier"
#define HELPCENTER_PAGE_FOOTER_IDENTIFIER @"activity_page_footer_identifier"


@interface QMAssistCenterViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation QMAssistCenterViewController {
    UICollectionView *activityTable;
    NSMutableArray *arrActivityItems;
    BOOL isAllDataLoaded;
}

- (void)updateTableFooterView {
    [footView setQMPageFootViewState:footerLoadingState];
}

- (void)asyncFetcAssistListWithOffset:(NSInteger)offset pageSize:(NSInteger)pageSize {
    [[NetServiceManager sharedInstance] helpCenterListWithPageSize:[NSNumber numberWithInteger:pageSize]
                                                        pageNumber:[NSNumber numberWithInteger:offset]
                                                          delegate:self
                                                           success:^(id responseObject) {
                                                               if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                                   NSArray *arr = [responseObject objectForKey:kNetWorkList];
                                                                   if ([arr isKindOfClass:[NSArray class]]) {
                                                                       if (offset == 1) {
                                                                           isAllDataLoaded = NO;
                                                                           [arrActivityItems removeAllObjects];
                                                                       }
                                                                       
                                                                       for (NSDictionary *dict  in arr) {
                                                                           QMAssistItem *item = [[QMAssistItem alloc] initWithDictionary:dict];
                                                                           
                                                                           [arrActivityItems addObject:item];
                                                                       }
                                                                       if ([arr count] < QM_FETCH_PAGE_SIZE) {
                                                                           isAllDataLoaded = YES;
                                                                       }
                                                                   }
                                                               }
                                                               
                                                               [self doneLoadingTableViewData];
                                                           } failure:^(NSError *error) {
                                                               [CMMUtility showNoteWithError:error];
                                                           }];
}

- (void)reloadData {
    [self asyncFetcAssistListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
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
    [self asyncFetcAssistListWithOffset:pageNumber pageSize:QM_FETCH_PAGE_SIZE];
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
    [self asyncFetcAssistListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
}

- (UIScrollView *)customScrollView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumLineSpacing = 5;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 0, 8);
    
    activityTable = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    activityTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    [activityTable registerClass:[QMAssistItemCell class] forCellWithReuseIdentifier:HELPCENTER_CELL_IDENTIFIER];
    
    [activityTable registerClass:[QMCollectionViewFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:HELPCENTER_PAGE_FOOTER_IDENTIFIER];
    
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
    QMAssistItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HELPCENTER_CELL_IDENTIFIER forIndexPath:indexPath];
    
    QMAssistItem *info = nil;
    if (indexPath.row < [arrActivityItems count]) {
        info = [arrActivityItems objectAtIndex:indexPath.row];
    }
    
    [cell configureCellWithAssistItem:info];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter] && !QM_IS_ARRAY_NIL(arrActivityItems)) {
        QMCollectionViewFooterView *pageFooterView = (QMCollectionViewFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:HELPCENTER_PAGE_FOOTER_IDENTIFIER forIndexPath:indexPath];
        footView = pageFooterView.pageFooterView;
        [self updateTableFooterView];
        
        return pageFooterView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMAssistItem *itm = [arrActivityItems objectAtIndex:indexPath.item];
    
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 10, [QMAssistItemCell getCellHeightForItem:itm]);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (QM_IS_ARRAY_NIL(arrActivityItems)) {
        return CGSizeZero;
    }else {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 45);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_more_assist_center_title", @"帮助中心");
}


@end

