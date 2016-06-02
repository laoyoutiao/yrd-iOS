//
//  UnuseViewController.m
//  MotherMoney
//
//  Created by liuyanfang on 15/9/14.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "UnuseViewController.h"
#import "QMUnUserCollectionViewCell.h"
#import "NetServiceManager.h"
#define UNUSE_CELL_IDENTIFIER @"unuse_cell_identifier"
@interface UnuseViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation UnuseViewController

{
    UICollectionView *packetListTable;
    NSMutableArray *couponList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=QM_COMMON_BACKGROUND_COLOR;
    [self customScrollView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    couponList = [[NSMutableArray alloc] initWithCapacity:0];
    [[NetServiceManager sharedInstance] getDidUseCouponListWithdelegate:self success:^(id responseObject) {
        NSArray *list = [responseObject objectForKey:@"list"];
        
        for (NSDictionary *dic in list) {
            QMUnUseModel *model = [[QMUnUseModel alloc] initWithDictionary:dic];
            
            [couponList addObject:model];
        }
        [self reloadData];
    } failure:^(NSError *error) {
        [CMMUtility showNoteWithError:error];
    }];
}
- (void)reloadData{
    [packetListTable reloadData];
    if (QM_IS_ARRAY_NIL(couponList)) {
        [self showEmptyView];
    }else {
        [self hideEmptyView];
    }
    
}

- (void)customScrollView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumInteritemSpacing = 10;
    
    packetListTable = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    packetListTable.backgroundColor = [UIColor whiteColor];
    [packetListTable registerClass:[QMUnUserCollectionViewCell class] forCellWithReuseIdentifier:UNUSE_CELL_IDENTIFIER];
    
    packetListTable.alwaysBounceVertical = YES;
    packetListTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    packetListTable.delegate = self;
    packetListTable.dataSource = self;
    packetListTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:packetListTable];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return [couponList count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QMUnUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UNUSE_CELL_IDENTIFIER forIndexPath:indexPath];
    
    cell.model = couponList[indexPath.item];
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return CGSizeMake(CGRectGetWidth(packetListTable.frame)-20, 104);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 0, 10, 0);
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
