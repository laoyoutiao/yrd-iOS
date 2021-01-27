//
//  QMGoodsListViewController.m
//  MotherMoney

#import "QMGoodsListViewController.h"
#import "QMMyIntegralExchangeListViewController.h"
#import "QMGoodsListItem.h"
#import "QMGoodsListItemCell.h"
#import "QMMyFundGoodListHeaderView.h"
#import "QMGoodListDetailViewController.h"
#import "QMMyIntegralExchangeListViewControllerViewController2.h"
#define CELL_IDENTIFIER @"cell_identifier"
#define CELL_HEADER_IDENTIFIER @"CELL_HEADER_IDENTIFIER"
#define EXCHANGE_ALERT_TAG 5001

@interface QMGoodsListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>

@end

@implementation QMGoodsListViewController {
    UICollectionView *goodListTable;
    NSMutableArray *goodsList;
    QMGoodsListItem *selectedItem;
    UIToolbar* bottomBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [self.navigationController setNavigationBarHidden:NO];
    [self initDataSource];
//    [self setUpBottomBar];
//    if ([goodsList count] == 0) {
//        UIAlertView *alert =  [ [UIAlertView alloc] initWithTitle:nil message:@"我们正在精心帮您挑选礼品,敬请期待" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//        [alert show];
//        [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1.5];
//        
//        
//    }

}
- (void)initDataSource {
    goodsList = [[NSMutableArray alloc] initWithCapacity:0];
    [self asyncFetchMyAssertFromServer];
}

- (void)asyncFetchMyAssertFromServer {
    NSInteger pageNumber = [goodsList count] / QM_FETCH_PAGE_SIZE + 1;
    NSNumber *pageSize = [NSNumber numberWithInteger:pageNumber];
    

    
    QMAccountInfo *info = [[QMAccountUtil sharedInstance] currentAccount];
    [[NetServiceManager sharedInstance] getWillTimeOutScore:info.phoneNumber Delegate:self success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        self.currentWillTimeOutScoreValue = [responseObject objectForKey:@"point"];
        self.willEndTime = [responseObject objectForKey:@"endDate"];
        [[NetServiceManager sharedInstance] getGoodsListWithPageSize:[NSNumber numberWithInteger:QM_FETCH_PAGE_SIZE]
                                                          pageNumber:pageSize
                                                            delegate:self
                                                             success:^(id responseObject) {
                                                                 // 获取成功
                                                                 [self handleFetchGoodsListSuccess:responseObject];
                                                             } failure:^(NSError *error) {
                                                                 // 获取失败
                                                                 [self handleFetchGoodListFailure:error];
                                                             }];
    } failure:^(NSError *error) {
        [self handleFetchGoodListFailure:error];
    }];
}

- (void)handleFetchGoodsListSuccess:(id)responseObject {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@---------------------",responseObject);
        self.currentScoreValue = [responseObject objectForKey:@"availableScore"];
        
        NSArray *goods = [responseObject objectForKey:kNetWorkList];

        if ([goods isKindOfClass:[NSArray class]]) {
            if (!QM_IS_ARRAY_NIL(goods)) {
                
                [goodsList removeAllObjects];
                
            }
            
            for (NSDictionary *dict in goods) {
                
                QMGoodsListItem *item = [[QMGoodsListItem alloc] initWithDictionary:dict];
                
                [goodsList addObject:item];
                
            }
            

        }
    }
    
    [self doneLoadingTableViewData];
}

- (void)handleFetchGoodListFailure:(NSError *)error {
    [CMMUtility showNoteWithError:error];
    [self doneLoadingTableViewData];
}

- (void)reloadData {
    [self asyncFetchMyAssertFromServer];
}

- (void)doneLoadingTableViewData {
    [super doneLoadingTableViewData];
    [(UITableView *)self.scrollView reloadData];
    
    if (QM_IS_ARRAY_NIL(goodsList)) {
        [self showEmptyView];
    }else {
        [self hideEmptyView];
    }
}
-(void)gotoEarningMoneyBeanController
{
    
}
- (void)setUpBottomBar {
    if (bottomBar.superview != nil) {
        [bottomBar removeFromSuperview];
    }
    
    CGFloat bottomBarHeight = 60;
    bottomBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - bottomBarHeight, CGRectGetWidth(self.view.frame), bottomBarHeight)];
    bottomBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    UIBarButtonItem *leftFixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftFixedSpaceItem.width = -16;
    
    self.buyMoneybeanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.buyMoneybeanBtn.backgroundColor=[UIColor colorWithRed:236.0f/255.0f green:34.0f/255.0f blue:49.0f/255.0f alpha:1];
    [self.buyMoneybeanBtn setTitle:@"去赚积分" forState:UIControlStateNormal];
    [self.buyMoneybeanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buyMoneybeanBtn addTarget:self action:@selector(gotoEarningMoneyBeanController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem=[[UIBarButtonItem alloc] initWithCustomView:self.buyMoneybeanBtn];
    NSArray* itemArray=[NSArray arrayWithObjects:leftItem, nil];
    [bottomBar setItems:itemArray];
    [self.buyMoneybeanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomBar.mas_left);
        make.top.equalTo(bottomBar.mas_top);
        make.bottom.equalTo(bottomBar.mas_bottom);
        make.right.equalTo(bottomBar.mas_right);
    }];
//    [self.view addSubview:bottomBar];
}

- (UIScrollView *)scrollView {
    if (nil == goodListTable) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        
        goodListTable = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        goodListTable.alwaysBounceVertical = YES;
        [goodListTable registerClass:[QMGoodsListItemCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [goodListTable registerClass:[QMMyFundGoodListHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CELL_HEADER_IDENTIFIER];
        goodListTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
        goodListTable.delegate = self;
        goodListTable.dataSource = self;
        goodListTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    
    return goodListTable;
}

- (void)gotoIntegralExchangeListViewController {
    QMMyIntegralExchangeListViewControllerViewController2 *con = [[QMMyIntegralExchangeListViewControllerViewController2 alloc] init];
    con.isModel = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

- (UIBarButtonItem *)rightBarButtonItem {
    return [QMNavigationBarItemFactory createNavigationItemWithTitle:QMLocalizedString(@"qm_integral_exchange_list", @"兑换记录") target:self selector:@selector(gotoIntegralExchangeListViewController) isLeft:NO];
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
-(void)tapGesAction
{
    QMGoodListDetailViewController* con=[[QMGoodListDetailViewController alloc] init];
//    [con configureCurrentScore:self.currentScoreValue];
    [self.navigationController pushViewController:con animated:YES];
}
#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case EXCHANGE_ALERT_TAG: {
            if (buttonIndex == 1) {
                if (selectedItem && !QM_IS_STR_NIL(selectedItem.prizeId)) {
                    // 兑换
                    [[NetServiceManager sharedInstance] addIntegralExchangeWithGoodId:selectedItem.prizeId
                                                                             delegate:self
                                                                              success:^(id responseObject) {
                                                                                  NSDictionary *dict = [responseObject safeDictForKey:@"winnersRecord"];
                                                                                  if([dict safeStringForKey:@"prizeId"].integerValue > 0 && [dict safeStringForKey:@"prizeId"].integerValue < 5)
                                                                                  {
                                                                                      [CMMUtility showNote:QMLocalizedString(@"qm_exchange_successL_title", @"兑换成功")];
                                                                                  }else
                                                                                  {
                                                                                      [CMMUtility showNote:QMLocalizedString(@"qm_exchange_success_title", @"兑换成功礼品将于两个工作日内发放。")];
                                                                                  }
                                                                                  
                                                                                  [self reloadData];
                                                                              } failure:^(NSError *error) {
                                                                                  [CMMUtility showNoteWithError:error];
                                                                              }];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)exchangeGoods:(UIButton *)btn {
    QMGoodsListItemCell *cell = (QMGoodsListItemCell *)[self recursionToCell:btn];
    selectedItem = cell.goodsItem;
    NSString *string = [NSString stringWithFormat:@"%@%@?",NSLocalizedString(@"qm_confirm_exchange_goods", @"您是否确定兑换"),selectedItem.prizeName];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:QMLocalizedString(@"qm_check_update_alert_title", @"提示")
                                                        message:string
                                                       delegate:self
                                              cancelButtonTitle:QMLocalizedString(@"qm_cancel_alert_btn_title", @"取消")
                                              otherButtonTitles:QMLocalizedString(@"qm_ok_alert_btn_title", @"确定"), nil];
    alertView.tag = EXCHANGE_ALERT_TAG;
    [alertView show];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [goodsList count];
}
- (void)dimissAlert:(UIAlertView *)alert {
    NSLog(@"==================================");
    if(alert)     {
        
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        
    }
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMGoodsListItemCell *cell = (QMGoodsListItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    
    if (indexPath.row < [goodsList count]) {
        QMGoodsListItem *item = [goodsList objectAtIndex:indexPath.row];
        [cell configureCellWithGoodsListItem:item];
        [cell.exchangeGoodBtn addTarget:self action:@selector(exchangeGoods:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind==UICollectionElementKindSectionHeader) {
        QMMyFundGoodListHeaderView* headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CELL_HEADER_IDENTIFIER forIndexPath:indexPath];

        [headerView.tapGes addTarget:self action:@selector(tapGesAction)];
        
        [headerView configCurrentScoreValue:self.currentScoreValue :self.currentWillTimeOutScoreValue :self.willEndTime];
        
        return headerView;
    }
    
    return nil;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 92);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(CGRectGetWidth(collectionView.frame), [QMGoodsListItemCell getGoodsItemCellHeightWithGoodsListItem:nil]);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(15,0, 10, 0);
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_my_integral_nav_title", @"我的积分");
}


@end
