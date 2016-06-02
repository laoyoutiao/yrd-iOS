//
//  QMProductIntroductionViewController.m
//  MotherMoney
//

#import "QMProductIntroductionViewController.h"
#import "QMProductIntroductionModel.h"
#import "QMProductImageCell.h"
#import "QMProductIntroductionCellHeader.h"

#define INTRO_COLLECTION_HEADER_IDENTIFIER @"WIND_COLLECTION_HEADER_IDENTIFIER"
#define INTRO_CELL_IDENTIFIER @"WIND_CELL_IDENTIFIER"
#define INTRO_BOTTOM_IDENTIFIER @"INTRO_BOTTOM_IDENTIFIER"

@interface QMProductIntroductionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation QMProductIntroductionViewController {
    NSString *mProductId;
    UICollectionView *collectionView;
    QMProductIntroductionModel *introlModel;
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
    [collectionView registerClass:[QMProductIntroductionCellHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:INTRO_COLLECTION_HEADER_IDENTIFIER];
    [collectionView registerClass:[QMProductImageCell class] forCellWithReuseIdentifier:INTRO_CELL_IDENTIFIER];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
}

- (void)asyncLoadDataFromServer {
    [[NetServiceManager sharedInstance] getProductIntroductionWithProductId:mProductId
                                                                  delegate:self
                                                                   success:^(id responseObject) {
                                                                       [self loadDataFromServerSuccess:responseObject];
                                                                   } failure:^(NSError *error) {
                                                                       [self loadDataFromServerFailed:error];
                                                                   }];
}

- (void)loadDataFromServerSuccess:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        introlModel = [[QMProductIntroductionModel alloc] initWithDictionary:dict];
    }
    
    [collectionView reloadData];
}

- (void)loadDataFromServerFailed:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [CMMUtility showNoteMsgWithError:error];
    });
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[introlModel imageList] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMProductImageCell *cell = (QMProductImageCell *)[collectionView1 dequeueReusableCellWithReuseIdentifier:INTRO_CELL_IDENTIFIER forIndexPath:indexPath];
    
    if (indexPath.item < [introlModel.imageList count]) {
        QMProductImageItemModel *item = [introlModel.imageList objectAtIndex:indexPath.item];
        [cell configureCellWithProductImageItem:item isLastOne:indexPath.item == introlModel.imageList.count - 1];
    }
    
    UIImageView *bgView = (UIImageView *)cell.backgroundView;
    
    if (indexPath.item == [introlModel.imageList count] - 1) {
        bgView.image = [QMImageFactory commonBackgroundImageBottomPart];
    }else {
        bgView.image = [QMImageFactory commonBackgroundImageCenterPart];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < [introlModel.imageList count]) {
        QMProductImageItemModel *item = [introlModel.imageList objectAtIndex:indexPath.item];
        return [QMProductImageCell getCellSizeWithProductImageItem:item isLastOne:indexPath.item == introlModel.imageList.count - 1];
    }
    
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView1 viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        QMProductIntroductionCellHeader *header = [collectionView1 dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:INTRO_COLLECTION_HEADER_IDENTIFIER forIndexPath:indexPath];
        
        [header configureHeaderWithWindControlModel:introlModel];
        
        return header;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return [QMProductIntroductionCellHeader getHeaderSizeWithWindControlModel:introlModel];
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
    return QMLocalizedString(@"qm_product_introduction", @"项目描述");
}


@end
