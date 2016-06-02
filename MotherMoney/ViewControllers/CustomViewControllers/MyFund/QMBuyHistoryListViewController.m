//
//  QMBuyHistoryListViewController.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/18.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMBuyHistoryListViewController.h"
#import "QMBuyedProductInfoCell.h"
#import "QMBuyedProductInfoHeaderView.h"
#import "QMEmptyView.h"
#import "QMMyProductInfoViewController.h"
#import "QMBuyedProductInfoCell2.h"
#define buyedProductInfoCellIdentifier @"buyedProductInfoCellIdentifier"
#define buyedProductInfoCellIdentifier1 @"buyedProductInfoCellIdentifier1"
#define BUYEDPRODUCTIONINFOSECTION_TITLE_IDENTIFIER1 @"BUYEDPRODUCTIONINFOSECTION_TITLE_IDENTIFIER1"
#define SELECTEDCOLOR [UIColor colorWithRed:220.0f/255 green:47.0f/255.0f blue:26.0f/255.0f alpha:1]
#define  NOMALCOLOR  [UIColor colorWithRed:30.0f/255.0f green:30.0f/255.0f blue:30.0f/255.0f alpha:1]
@interface QMBuyHistoryListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation QMBuyHistoryListViewController {
    QMEmptyView *emptyView;
    
    UICollectionView* progressingTable;
    UICollectionView* finishTable;
    NSMutableArray* progressingList;
    NSMutableArray* finishList;
    UIImageView* headerImageView;
    UIImageView* trackImageView;
    UIScrollView* scrollView;
    UIButton* leftBtn;
    UIButton* rightBtn;
    float width;
    float height;
    NSInteger newContentOffSetX;
    NSInteger oldContentOffSetX;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     width=self.view.frame.size.width;
     height=self.view.frame.size.height;
    oldContentOffSetX=0;
    newContentOffSetX=0;
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    progressingList=[[NSMutableArray alloc] init];
    finishList=[[NSMutableArray alloc] init];
    [self asyncFetchMyAssertFromServer];
    [self initHeaderView];
    [self setUpSubViews];
    [self initCollectionView];
}

//- (UIBarButtonItem *)leftBarButtonItem {
//    return [QMNavigationBarItemFactory createNavigationBackItemWithTarget:self selector:@selector(onBack)];
//}
//
//- (void)onBack {
//    [self.navigationController popViewControllerAnimated:YES];
//}
-(void)btnClick:(UIButton*)sender
{
    if (leftBtn.tag==sender.tag) {
        [leftBtn setSelected:YES];
        [rightBtn setSelected:NO];
        [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        trackImageView.frame=CGRectMake(0,41,width/2, 1);
        [UIView commitAnimations];
    }
    else
    {
        [leftBtn setSelected:NO];
        [rightBtn setSelected:YES];
        [scrollView setContentOffset:CGPointMake(width, 0) animated:YES];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        trackImageView.frame=CGRectMake(width/2,41,width/2, 1);
        [UIView commitAnimations];
    }
}
-(void)initHeaderView
{
    
    headerImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width,40)];
    headerImageView.backgroundColor=[UIColor whiteColor];
    headerImageView.userInteractionEnabled=YES;
    leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0,0,width/2,40);
    [leftBtn setTitle:@"持有中" forState:UIControlStateNormal];
    [leftBtn setTitleColor:NOMALCOLOR forState:UIControlStateNormal];
    [leftBtn setTitleColor:SELECTEDCOLOR forState:UIControlStateSelected];
    leftBtn.tag=1;
    [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setSelected:YES];
    
    
    rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(width/2, 0, width/2,40);
    [rightBtn setTitle:@"已完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:NOMALCOLOR forState:UIControlStateNormal];
    [rightBtn setTitleColor:SELECTEDCOLOR forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerImageView addSubview:leftBtn];
    [headerImageView addSubview:rightBtn];
    [self.view addSubview:headerImageView];
    
    trackImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,41,width/2,1)];
    trackImageView.backgroundColor=QM_THEME_COLOR;
    [self.view addSubview:trackImageView];
}
- (void)setUpSubViews
{
    
    
    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 42, width, height)];
    [scrollView setContentSize:CGSizeMake(width*2,height-42)];
    scrollView.backgroundColor=QM_COMMON_BACKGROUND_COLOR;
    scrollView.delegate=self;
    scrollView.directionalLockEnabled=YES;
    scrollView.pagingEnabled=NO;
    [scrollView setBounces:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self asyncFetchMyAssertFromServer];
}
-(void)initCollectionView
{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 10, 10, 10);
    flowLayout.minimumLineSpacing = 10;
    progressingTable=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0, width, height-42) collectionViewLayout:flowLayout];
    [progressingTable registerClass:[QMBuyedProductInfoCell class] forCellWithReuseIdentifier:buyedProductInfoCellIdentifier];
    
    progressingTable.alwaysBounceVertical = YES;
    progressingTable.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    progressingTable.backgroundColor =QM_COMMON_BACKGROUND_COLOR;
    progressingTable.delegate = self;
    progressingTable.dataSource = self;
    progressingTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [scrollView addSubview:progressingTable];
    
    
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 10, 10, 10);
    flowLayout.minimumLineSpacing = 10;
    finishTable=[[UICollectionView alloc] initWithFrame:CGRectMake(width, 0, width, height) collectionViewLayout:flowLayout1];
    [finishTable registerClass:[QMBuyedProductInfoCell2 class] forCellWithReuseIdentifier:buyedProductInfoCellIdentifier1];
    
    finishTable.alwaysBounceVertical = YES;
    finishTable.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    finishTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    finishTable.delegate = self;
    finishTable.dataSource = self;
    finishTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [scrollView addSubview:finishTable];
}

- (void)asyncFetchMyAssertFromServer {
    [[NetServiceManager sharedInstance] getProductAccountListWithDelegate:self success:^(id responseObject) {
        [self handleFetchListSuccess:responseObject];
    } failure:^(NSError *error) {
        [CMMUtility showNoteWithError:error];
        [self doneLoadingTableViewData];
    }];
}

- (void)handleFetchListSuccess:(id)responseObject {
    // 初始化产品数据
    
    NSArray *products = [responseObject objectForKey:@"productAccountList"];
    if ([products isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in products) {
            QMBuyedProductInfo *info = [[QMBuyedProductInfo alloc] initWithDictionary:dict];
    if ([info.bandInfo.statusValue isEqualToString:@"收益中"]) {
        
            }
            else
            {
                [progressingList addObject:info];
                [finishList addObject:info];
            }
           
        }
    }
    
    [self doneLoadingTableViewData];
    
    if (QM_IS_ARRAY_NIL(progressingList)) {
        [self showEmptyView:progressingTable.frame];
    }else if(QM_IS_ARRAY_NIL(finishList))
    {
        [self showEmptyView:finishTable.frame];
    }else
    {
        [self hideEmptyView];
    }
}
-(void)showEmptyView:(CGRect)frame
{
    if (nil == emptyView) {
        emptyView = [[QMEmptyView alloc] initWithFrame:frame];
        emptyView.backgroundColor=QM_COMMON_BACKGROUND_COLOR;
        emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        emptyView.textLabel.text = [self emptyTitle];
        emptyView.userInteractionEnabled = NO;
        [scrollView addSubview:emptyView];
    }
    
    if (nil == [emptyView superview]) {
        [scrollView addSubview:emptyView];
    }
    
    [scrollView bringSubviewToFront:emptyView];
}
- (void)doneLoadingTableViewData {
    [progressingTable reloadData];
    [finishTable reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:progressingTable]) {
        return [progressingList count];
    }else if ([collectionView isEqual:finishTable])
    {
        return [finishList count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView==progressingTable) {
        QMBuyedProductInfoCell *cell = (QMBuyedProductInfoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:buyedProductInfoCellIdentifier forIndexPath:indexPath];
        QMBuyedProductInfo* info=[progressingList objectAtIndex:indexPath.item];
        [cell configureCellWithProductInfo:info];
        return cell;
        
    }else if (collectionView==finishTable)
    {
        QMBuyedProductInfoCell2 *cell = (QMBuyedProductInfoCell2 *)[collectionView dequeueReusableCellWithReuseIdentifier:buyedProductInfoCellIdentifier1 forIndexPath:indexPath];
        
        QMBuyedProductInfo* info=[finishList objectAtIndex:indexPath.item];
        cell.backgroundView.layer.masksToBounds=YES;
        cell.backgroundView.layer.cornerRadius=10.0f;
        [cell configureCellWithProductInfo2:info];
        return cell;
    }
    
    return nil;
    

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==progressingTable) {
        return CGSizeMake(width - 2 * 10, [QMBuyedProductInfoCell getCellHeightForProductInfo:nil]);
    }else if (collectionView==finishTable)
    {
        return CGSizeMake(width -2*10, [QMBuyedProductInfoCell2 getCellHeightForProductInfo:nil]);
    }
    return CGSizeZero;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView==progressingTable) {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }else if (collectionView==finishTable)
    {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return UIEdgeInsetsZero;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    // 打点
    [QMUMTookKitManager event:SHOW_ORDER_DETAIL_KEY label:@"使用订单详情"];
    if (collectionView==progressingTable) {
        QMBuyedProductInfo *productInfo = [progressingList objectAtIndex:indexPath.row];
        QMMyProductInfoViewController *con = [[QMMyProductInfoViewController alloc] initViewControllerWithProduct:productInfo];
        [self.navigationController pushViewController:con
                                             animated:YES];
    }
    else if (collectionView==finishTable)
    {
        QMBuyedProductInfo *productInfo = [finishList objectAtIndex:indexPath.row];
        QMMyProductInfoViewController *con = [[QMMyProductInfoViewController alloc] initViewControllerWithProduct:productInfo];
        [self.navigationController pushViewController:con
                                             animated:YES];
    }
    
}

#pragma scrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    newContentOffSetX=scrollView.contentOffset.x;
    
    if (newContentOffSetX!=0) {
        int nowPage=newContentOffSetX/width;
        
        if (nowPage==0) {
            [leftBtn setSelected:YES];
            [rightBtn setSelected:NO];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.1];
            trackImageView.frame=CGRectMake(0,41,width/2, 1);
            [UIView commitAnimations];
        }else
        {
            [rightBtn setSelected:YES];
            [leftBtn setSelected:NO];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.1];
            trackImageView.frame=CGRectMake(width/2,41,width/2, 1);
            [UIView commitAnimations];
        }

    }
    
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return @"投资记录";
}



@end



