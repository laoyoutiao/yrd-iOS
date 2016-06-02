//
//  QMProductInfoViewController.m
//  MotherMoney

#import "QMMyProductInfoViewController.h"
#import "MyFundViewController.h"
#import "QMMyFundModel.h"
#import "QMMyFundAbstractCell.h"
#import "QMAccountInfoCell.h"
#import "QMBuyedProductRecordInfoHeaderView.h"
#import "QMMessageCenterViewController.h"
#import "QMMyProductInfoAbstractCell.h"
#import "QMMyProductBuyRecordCell.h"
#import "QMProductInfoViewController.h"
#import "QMBuyedProductResolveModel.h"

typedef enum {
    QMProductInfoTableSection_Abstract = 0, // 概述信息
    QMProductInfoTableSection_Product, // 产品列表
    QMProductInfoTableSection_Count
}QMProductInfoTableSection;


#define myProductAbstractCellIdentifier @"myProductAbstractCellIdentifier"
#define myBuyedProductInfoCellIdentifier @"myBuyedProductInfoCellIdentifier"
#define myTotalEarningsCellIdentifier @"myTotalEarningsCellIdentifier"

#define MYBUYEDPRODUCTIONINFOSECTION_TITLE_IDENTIFIER @"mybuyedproductioninfosection_title_identifier"

@interface QMMyProductInfoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation QMMyProductInfoViewController {
    UICollectionView *myFundTable;
    QMBuyedProductInfo *buyedProductInfo;
    
    UIToolbar *bottomBar;
    
    NSMutableArray *productResolves;
}

- (id)initViewControllerWithProduct:(QMBuyedProductInfo *)info {
    if (self = [super init]) {
        productResolves = [[NSMutableArray alloc] initWithCapacity:0];
        buyedProductInfo = info;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    [self initDataSource];
    [self setUpSubViews];
}

- (void)setUpSubViews {
    [self setUpBottomBar];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 0, 8);
    flowLayout.minimumLineSpacing = 0;
    myFundTable = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(bottomBar.frame)) collectionViewLayout:flowLayout];
//    [myFundTable registerClass:[QMBuyedProductRecordInfoHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MYBUYEDPRODUCTIONINFOSECTION_TITLE_IDENTIFIER];
    [myFundTable registerClass:[QMMyProductInfoAbstractCell class] forCellWithReuseIdentifier:myProductAbstractCellIdentifier];
    [myFundTable registerClass:[QMMyProductBuyRecordCell class] forCellWithReuseIdentifier:myBuyedProductInfoCellIdentifier];
    myFundTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    myFundTable.delegate = self;
    myFundTable.dataSource = self;
    myFundTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.view addSubview:myFundTable];
}

- (void)setUpBottomBar {
    CGFloat bottomBarHeight = 50;
    bottomBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - bottomBarHeight, CGRectGetWidth(self.view.frame), bottomBarHeight)];
    bottomBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    UIBarButtonItem *leftFixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftFixedSpaceItem.width = -16;
    
    // 购买按钮
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.backgroundColor = [UIColor redColor];
    [buyBtn setTitle:QMLocalizedString(@"qm_recommendation_buy_btn_title", @"购买") forState:UIControlStateNormal];
    buyBtn.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(bottomBar.frame));
    [buyBtn setBackgroundImage:[[UIImage imageNamed:@"products_buy_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:25] forState:UIControlStateNormal];
    [buyBtn setBackgroundImage:[[UIImage imageNamed:@"products_buy_bg_pressed.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:25] forState:UIControlStateHighlighted];
    //购买添加taget,点击购按钮跳入产品详情界面
    [buyBtn addTarget:self action:@selector(buyProductBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buyItem = [[UIBarButtonItem alloc] initWithCustomView:buyBtn];
    
    //
    UIBarButtonItem *rightFixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightFixedSpaceItem.width = -15;
    
    NSArray *items = [[NSArray alloc] initWithObjects:leftFixedSpaceItem, buyItem, rightFixedSpaceItem, nil];
    [bottomBar setItems:items];
    
    [self.view addSubview:bottomBar];
}

- (void)buyProductBtnClicked:(UIButton *)btn {
    QMProductInfo *info = [[QMProductInfo alloc] init];
    info.product_id = buyedProductInfo.productId;
    QMProductInfoViewController *con = [[QMProductInfoViewController alloc] initViewControllerWithProductInfo:info];
    con.isModel = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:^{

    }];
}

- (void)quxianBtnClicked:(UIButton *)btn {
    
}

- (void)reloadData {

}

- (void)doneLoadingTableViewData {
    [myFundTable reloadData];
}


- (void)initDataSource {
    [[NetServiceManager sharedInstance] getOrderResolveWithProductId:buyedProductInfo.buyedId
                                                            delegate:self
                                                             success:^(id responseObject) {
                                                                 [self handleFetchProductDetailSuccess:responseObject];
                                                             } failure:^(NSError *error) {
                                                                 [self handleFetchProductetailFailure:error];
                                                             }];
}

- (void)handleFetchProductDetailSuccess:(id)responseObject {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSArray *array = [responseObject objectForKey:@"productSubAccountList"];
        if (![array isKindOfClass:[NSArray class]]) {
            return;
        }
        
        for (NSDictionary *dict in array) {
            QMBuyedProductResolveModel *model = [[QMBuyedProductResolveModel alloc] initWithDictionary:dict];
            
            if (model) {
                [productResolves addObject:model];
            }
        }
    }
    
    [myFundTable reloadData];
}

- (void)handleFetchProductetailFailure:(NSError *)error {
    [CMMUtility showNoteWithError:error];
}
//-(UIBarButtonItem*)rightBarButtonItem
//{
//    UIBarButtonItem* rightButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
//    return rightButton;
//}
//-(void)rightBarButtonClick:(id)sender
//{
//    
//}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return QMProductInfoTableSection_Count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == QMProductInfoTableSection_Abstract) {
        return UIEdgeInsetsMake(8, 8, 10, 8);
    }else if (section == QMProductInfoTableSection_Product) {
        return UIEdgeInsetsMake(10, 8, 8, 8);
    }
    
    return UIEdgeInsetsZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger rowCount = 0;
    if (QMProductInfoTableSection_Abstract == section) {
        rowCount = 1;
    }else if(QMProductInfoTableSection_Product == section) {
        rowCount = 1;
    }
    
    return rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == QMProductInfoTableSection_Abstract) {
        QMMyProductInfoAbstractCell *cell = (QMMyProductInfoAbstractCell *)[collectionView dequeueReusableCellWithReuseIdentifier:myProductAbstractCellIdentifier forIndexPath:indexPath];

        [cell configureWithFundInfo:buyedProductInfo];
        
        return cell;
    }else if (indexPath.section == QMProductInfoTableSection_Product) {
        QMMyProductBuyRecordCell *cell = (QMMyProductBuyRecordCell *)[collectionView dequeueReusableCellWithReuseIdentifier:myBuyedProductInfoCellIdentifier forIndexPath:indexPath];
       
        [cell configureCurrentController:self];
        [cell configureBuyedProductResolves:productResolves];
        
//        if (indexPath.row < [productResolves count]) {
//            QMBuyedProductResolveModel *info = [productResolves objectAtIndex:indexPath.row];
//            
//            [cell configureCellWithProductInfo:info];
//        }
//        
//        UIImageView *backgroundView = (UIImageView *)cell.backgroundView;
//        cell.horizontalLineView.hidden = NO;
//        if ([productResolves count] == 1) {
//            backgroundView.image = [QMImageFactory commonBackgroundImageBottomPart];
//            cell.horizontalLineView.hidden = YES;
//        }else {
//            if (indexPath.row == 0) {
//                backgroundView.image = [QMImageFactory commonBackgroundImageCenterPart];
//            }else if (indexPath.row == [productResolves count] - 1) {
//                backgroundView.image = [QMImageFactory commonBackgroundImageBottomPart];
//                cell.horizontalLineView.hidden = YES;
//            }else {
//                backgroundView.image = [QMImageFactory commonBackgroundImageCenterPart];
//            }
//        }
        
        return cell;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == QMProductInfoTableSection_Abstract) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 10, [QMMyProductInfoAbstractCell getAbstractViewHeightForFundInfo:nil]);
    }else if (indexPath.section == QMProductInfoTableSection_Product) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 10, [QMMyProductBuyRecordCell getCellHeightForProductInfo:nil]);
    }
    
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == QMProductInfoTableSection_Abstract) {
        
    }else if (indexPath.section == QMProductInfoTableSection_Product) {
        
    
    }
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == QMProductInfoTableSection_Product) {
//        QMBuyedProductRecordInfoHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MYBUYEDPRODUCTIONINFOSECTION_TITLE_IDENTIFIER forIndexPath:indexPath];
//        
//        return header;
//    }else {
//        return nil;
//    }
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    if (section == QMProductInfoTableSection_Product) {
//        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
//        CGSize size = CGSizeMake(CGRectGetWidth(collectionView.frame) - layout.sectionInset.left - layout.sectionInset.right, [QMBuyedProductRecordInfoHeaderView getProductInfoHeaderHeight]);
//        
//        return size;
//    }
//    
//    return CGSizeZero;
//}
//
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
#pragma mark -
#pragma mark Override
- (NSString *)title {
    return buyedProductInfo.productName;
}

@end
