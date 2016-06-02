//
//  QMProductWindControlViewController.m
//  MotherMoney
//
//

#import "QMProductWindControlViewController.h"
#import "QMWindControlHeaderCellHeader.h"
#import "QMProductImageCell.h"
#import "QMProductWindControlModel.h"

#define WIND_COLLECTION_HEADER_IDENTIFIER @"WIND_COLLECTION_HEADER_IDENTIFIER"
#define WIND_CELL_IDENTIFIER @"WIND_CELL_IDENTIFIER"
#define WIND_BOTTOM_IDENTIFIER @"WIND_BOTTOM_IDENTIFIER"

@interface QMProductWindControlViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation QMProductWindControlViewController {
    NSString *mProductId;
    UICollectionView *collectionView;
    
    QMProductWindControlModel *model;
}

- (id)initViewControllerWithProductId:(NSString *)productId {
    if (self = [super init]) {
        mProductId = productId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    [self asyncLoadDataFromServer];
    [self setUpSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleImageDownloadSuccessNotification:) name:PRODUCTIMAGECELL_IMAGE_DOWNLOAD_SUCCESS object:nil];
}

- (void)setUpSubViews {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 8, 8, 8);
    flowLayout.minimumLineSpacing = -1;
    flowLayout.minimumInteritemSpacing = 0;
    
    collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.alwaysBounceVertical = YES;
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [collectionView registerClass:[QMWindControlHeaderCellHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WIND_COLLECTION_HEADER_IDENTIFIER];
    [collectionView registerClass:[QMProductImageCell class] forCellWithReuseIdentifier:WIND_CELL_IDENTIFIER];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
}

- (void)asyncLoadDataFromServer {
    [[NetServiceManager sharedInstance] getProductWindControlWithProductId:mProductId
                                                                  delegate:self
                                                                   success:^(id responseObject) {
                                                                       [self loadDataFromServerSuccess:responseObject];
                                                                   } failure:^(NSError *error) {
                                                                       [self loadDataFromServerFailed:error];
                                                                   }];
}

- (void)loadDataFromServerSuccess:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        model = [[QMProductWindControlModel alloc] initWithDictionary:dict];
    }
    
    [collectionView reloadData];
}

- (void)loadDataFromServerFailed:(NSError *)error {
    [CMMUtility showNoteMsgWithError:error];
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[model imageList] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMProductImageCell *cell = (QMProductImageCell *)[collectionView1 dequeueReusableCellWithReuseIdentifier:WIND_CELL_IDENTIFIER forIndexPath:indexPath];
    
    UIImageView *bgView = (UIImageView *)cell.backgroundView;
    if (indexPath.row != [model.imageList count] - 1) {
        bgView.image = [QMImageFactory commonBackgroundImageCenterPart];
    }else {
        bgView.image = [QMImageFactory commonBackgroundImageBottomPart];
    }
    
    if (indexPath.item < [model.imageList count]) {
        QMProductImageItemModel *item = [model.imageList objectAtIndex:indexPath.item];
        [cell configureCellWithProductImageItem:item isLastOne:indexPath.item == model.imageList.count - 1];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < [model.imageList count]) {
        QMProductImageItemModel *item = [model.imageList objectAtIndex:indexPath.item];
        return [QMProductImageCell getCellSizeWithProductImageItem:item isLastOne:indexPath.item == model.imageList.count - 1];
    }
    
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView1 viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        QMWindControlHeaderCellHeader *header = [collectionView1 dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WIND_COLLECTION_HEADER_IDENTIFIER forIndexPath:indexPath];
        
        [header configureHeaderWithWindControlModel:model];
        
        return header;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return [QMWindControlHeaderCellHeader getHeaderSizeWithWindControlModel:model];
}

#pragma mark -
#pragma mark NSNotification
- (void)handleImageDownloadSuccessNotification:(NSNotification *)noti {
    [collectionView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PRODUCTIMAGECELL_IMAGE_DOWNLOAD_SUCCESS object:nil];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_product_wind_control", @"风控措施");
}

@end
