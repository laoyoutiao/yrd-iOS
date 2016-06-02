//
//  QMProductCouponViewController.m
//  MotherMoney
//
//  Created by liuyanfang on 15/9/16.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMProductCouponViewController.h"
#import "QMProductCouponCollectionViewCell.h"
#import "QMProductCouponTableViewCell.h"
#import "QMBuyProductInputMoneyViewControllerV2.h"
#import "NetServiceManager.h"
#define CELL_PRODUCT_COUPON_IDENTIFIER @"cell_product_coupon_identifier"
#define NAMECOLOR [UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f]

#define VALUECOLOR [UIColor colorWithRed:221.0f / 255.0f green:46.0f / 255.0f blue:28.0f / 255.0f alpha:1.0f]
#define TIMECOLOR [UIColor colorWithRed:153.0f / 255.0f green:153.0f / 255.0f blue:153.0f / 255.0f alpha:1.0f]
@interface QMProductCouponViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation QMProductCouponViewController{
    UICollectionView *couponTable;
    UITableView *couponTabView;
    UIView *selecView;
    UILabel *couponName;
    UILabel *couponValue;
    UILabel *timeLabel;
    NSMutableArray *couponList;
    NSString *name;
    NSNumber* value;
    NSNumber *useLimit;
    NSString *useCode;
    NSMutableArray *useArr;
    NSMutableArray *valueArr;
    NSMutableArray *nameArr;
    NSMutableArray *useLimitArr;
}
- (id)initViewControllerWithUseCode:(NSString *)ticketCode{
    if (self = [super init]) {

        self.ticketCode = ticketCode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 8;
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 10, 8, 10);
    couponTable = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-52) collectionViewLayout:flowLayout];
    couponTabView.alwaysBounceVertical = YES;
    couponTabView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [couponTable registerClass:[QMProductCouponCollectionViewCell class] forCellWithReuseIdentifier:CELL_PRODUCT_COUPON_IDENTIFIER];
    couponTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    couponTable.dataSource = self;
    couponTable.delegate = self;
    [self.view addSubview:couponTable];
    
    useArr = [[NSMutableArray alloc] init];
    valueArr = [[NSMutableArray alloc] init];
    nameArr = [[NSMutableArray alloc] init];
    useLimitArr = [[NSMutableArray alloc] init];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    couponList = [[NSMutableArray alloc] initWithCapacity:0];
    [[NetServiceManager sharedInstance] getUsableDJQWithProductId:self.productId delegate:self success:^(id responseObject) {
        NSArray *list = [responseObject objectForKeyedSubscript:@"list"];
        
        for (NSDictionary *dic in list) {
            QMProductCouponModel *model = [[QMProductCouponModel alloc] initWithDictionary:dic];

            [couponList addObject:model];
            

        }

        [self reloadData];
    } failure:^(NSError *error) {
        
}];
    
}
- (UIBarButtonItem *)rightBarButtonItem{
    return [QMNavigationBarItemFactory createNavigationItemWithTitle:QMLocalizedString(@"qm_recommendation_login_btn_right", @"取消使用")
                                                              target:self
                                                            selector:@selector(cancelCoupon:)
                                                              isLeft:NO];
}

- (void)cancelCoupon:(id)sender{
    NSString *val = nil;
    NSString *limit = nil;
    [self.delegate userSelectedWithName:nil value:[val floatValue] useCode:nil useLimit:[limit doubleValue]];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)reloadData{
    [couponTable reloadData];
    
    if (QM_IS_ARRAY_NIL(couponList)) {
        [self showEmptyView];
    }else {
        [self hideEmptyView];
    }

}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [couponList count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QMProductCouponCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_PRODUCT_COUPON_IDENTIFIER forIndexPath:indexPath];
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.frame)-20, 104)];
    cell.model = couponList[indexPath.item];
    QMProductCouponModel *model = [[QMProductCouponModel alloc] init];
    model = couponList[indexPath.item];
    name = model.ticketName;
    value = model.value;
    useCode = model.useCode;
    useLimit = model.useLimit;
    [useArr addObject:useCode];
    [valueArr addObject:value];
    [nameArr addObject:name];
    [useLimitArr addObject:useLimit];
    
    if ([model.useCode isEqualToString:self.ticketCode]) {

        
            
            cell.selected = YES;
        
    }
    backgroundView.image = [UIImage imageNamed:@"pay_radio_default"];
    backgroundView.contentMode = UIViewContentModeRight;
    UIImageView *selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.frame)-20, 104)];
    selectImage.image = [UIImage imageNamed:@"pay_radio_selected"];
    selectImage.contentMode = UIViewContentModeRight;
    cell.backgroundView = backgroundView;
    cell.selectedBackgroundView = selectImage;
    return cell;
}
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    return NO;
//}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = useArr[indexPath.item];
    NSNumber *val = valueArr[indexPath.item];
    NSString *ticketName = nameArr[indexPath.item];
    NSNumber *limit = useLimitArr[indexPath.item];
        [self.delegate userSelectedWithName:ticketName value:[val floatValue] useCode:str useLimit:[limit doubleValue]];
    
        [self.navigationController popViewControllerAnimated:YES];

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetWidth(couponTable.frame)-20, 104);
}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(5, 0, 5, 0);
//}

- (NSString *)title{
    
    return @"可用的代金券";
    
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
