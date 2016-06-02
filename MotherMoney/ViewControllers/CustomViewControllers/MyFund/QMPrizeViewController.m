//
//  QMPrizeViewController.m
//  MotherMoney
//
//  Created by liuyanfang on 15/9/14.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMPrizeViewController.h"
#import "QMPrizeCouponCollectionViewCell.h"
#import "QMPrizeGoodListCollectionViewCell.h"
#import "QMPrizePacketCollectionViewCell.h"
#import "QMGoodsListViewController.h"
#import "QMCouponViewController.h"
#import "QMWebViewController3.h"
#import "NetServiceManager.h"
#define CELL_GOODLIST_IDENTIFIER @"cell_goodList_identifier"
#define CELL_PACKET_IDENTIFIER @"cell_packet_identifier"
#define CELL_COUPON_IDENTIFIER @"cell_coupon_identifier"
@interface QMPrizeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end
typedef enum {
    
    QMPrizeTableSection_goodList=0,
    QMPrizeTableSection_packet,
    QMPrizeTableSection_coupon,
    QMPrizeTableSection_Count
}QMPrizeTableSection;
@implementation QMPrizeViewController{
    UICollectionView *prizeListTable;
    NSString *availableScore;
    NSString *userDjqTicketCount;
    NSString *userTicketCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;

    [self creatTable];
    
    
}
    
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NetServiceManager sharedInstance] getMyAwardListWithdelegate:self success:^(id responseObject) {

        if (!QM_IS_DICT_NIL(responseObject)) {
            availableScore = [responseObject objectForKey:@"availableScore"];
            
            userDjqTicketCount = [responseObject objectForKey:@"userDjqTicketCount"];
            userTicketCount = [responseObject objectForKey:@"userTicketCount"] ;
            
        }
        [prizeListTable reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)creatTable{
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumInteritemSpacing = 10;
    
    
    prizeListTable = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    
    prizeListTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    [prizeListTable registerClass:[QMPrizeGoodListCollectionViewCell class] forCellWithReuseIdentifier:CELL_GOODLIST_IDENTIFIER];
    
    [prizeListTable registerClass:[QMPrizeCouponCollectionViewCell class] forCellWithReuseIdentifier:CELL_COUPON_IDENTIFIER];
    [prizeListTable registerClass:[QMPrizePacketCollectionViewCell class] forCellWithReuseIdentifier:CELL_PACKET_IDENTIFIER];
    
    prizeListTable.dataSource = self;
    
    prizeListTable.delegate = self;
    
    prizeListTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:prizeListTable];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item==QMPrizeTableSection_goodList) {
        QMPrizeGoodListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_GOODLIST_IDENTIFIER forIndexPath:indexPath];
        cell.scoreValue = availableScore;
        return cell;
    }else if (indexPath.item==QMPrizeTableSection_coupon){
        QMPrizeCouponCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_COUPON_IDENTIFIER forIndexPath:indexPath];
        cell.userDjqTicketCount = userDjqTicketCount;
        return cell;
    }else if (indexPath.item==QMPrizeTableSection_packet){
        QMPrizePacketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_PACKET_IDENTIFIER forIndexPath:indexPath];
        cell.userTicketCount = userTicketCount;
        return cell;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetWidth(prizeListTable.frame), 44);
}
- (NSString *)title{
    
        return QMLocalizedString(@"qm_navigation_title_myprize", @"我的奖励");
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0,10, 0, 10);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item==QMPrizeTableSection_goodList) {
        
        QMGoodsListViewController *con = [[QMGoodsListViewController alloc] init];
        
        [self.navigationController pushViewController:con animated:YES];
    }if (indexPath.item==QMPrizeTableSection_coupon) {
        
        QMCouponViewController *con = [[QMCouponViewController alloc] init];
        
        [self.navigationController pushViewController:con animated:YES];
        
    }if (indexPath.item==QMPrizeTableSection_packet) {

        NSString *str = @"/myDoTicket?showNav=0";
        NSString *packetUrl = [NSString stringWithFormat:@"%@%@",URL_BASE,str];
        
        NSURL* url1=[NSURL URLWithString:packetUrl];
        NSURLRequest* request=[NSURLRequest requestWithURL:url1];
        
        [QMWebViewController showWebViewWithRequest:request navTitle:@"我的红包" isModel:NO from:self];


    }
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
