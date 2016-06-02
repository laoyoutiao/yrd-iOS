//
//  QMAboutViewController.m
//  MotherMoney
//

#import "QMAboutViewController.h"
#import "QMSingleLineCollectionCell.h"
#import "QMAboutHeaderView.h"
#import "QMWelcomeViewController.h"
#import "QMUMTookKitManager.h"
#import "LLViewController.h"
#import "NetServiceManager.h"
#import "QMWebViewController3.h"
#import "QMAboutModel.h"
typedef enum {
    QMAboutTableRow_WelcomeRow = 0,
    QMAboutTableRow_HotlineRow,
    QMAboutTableRow_EmailRow,
    QMAboutTableRow_WebSiteRow,
    QMAboutTableRow_Count
}QMAboutTableRow;

#define ABOUT_SINGLE_LINE_CELL_IDENTIFIER @"about_single_line_cell_identifier"
#define ABOUT_HEADER_VIEW_IDENTIFIER @"about_header_view_identifier"
#define ABOUT_DECORATE_VIEW_IDENTIFIER @"about_decorate_view_identifier"

@interface QMAboutViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation QMAboutViewController {
    UIImageView *logoImageView;
    UILabel *aboutInfoLabel;
    UICollectionView *aboutTable;
    NSMutableArray *itemList;
    QMAboutModel *aboutModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initDataSource];
    [self setUpSubViews];
}

- (void)initDataSource {
    itemList = [[NSMutableArray alloc] initWithCapacity:0];
    
    // 欢迎页
    [itemList addObject:QMLocalizedString(@"qm_about_page_welcome_title", @"欢迎页")];
    
    
    [[NetServiceManager sharedInstance] getAboutMessageWithdelegate:self success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        aboutModel = [[QMAboutModel alloc] initWithDictionary:responseObject];
        
        [aboutTable reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
    // 客服热线
//    [itemList addObject:[NSString stringWithFormat:QMLocalizedString(@"qm_about_page_hotline_title", @"客服热线:%@"), QM_OFFICIAL_PHONE_NUMBER]];
//    
//    // 邮箱
//    [itemList addObject:[NSString stringWithFormat:QMLocalizedString(@"qm_about_page_email_title", @"客服邮箱:%@"), @"service@yrdai168.com"]];
//    
//    // 网站
//    [itemList addObject:[NSString stringWithFormat:QMLocalizedString(@"qm_about_page_website_title", @"网站:%@"), QM_OFFICIAL_SITE]];
}

- (void)setUpSubViews {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    flowLayout.minimumLineSpacing = 0;
    aboutTable = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    aboutTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    aboutTable.dataSource = self;
    aboutTable.delegate = self;
    [aboutTable registerClass:[QMSingleLineCollectionCell class] forCellWithReuseIdentifier:ABOUT_SINGLE_LINE_CELL_IDENTIFIER];
    [aboutTable registerClass:[QMAboutHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ABOUT_HEADER_VIEW_IDENTIFIER];
    [self.view addSubview:aboutTable];
    [aboutTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return QMAboutTableRow_Count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMSingleLineCollectionCell *cell = (QMSingleLineCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ABOUT_SINGLE_LINE_CELL_IDENTIFIER forIndexPath:indexPath];
    cell.textLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
    
//    NSString *string = [itemList objectAtIndex:indexPath.row];
//    cell.textLabel.text = string;
    
    UIImageView *backgroundView = (UIImageView *)cell.backgroundView;
    UIImageView *selectedBackgroundView = (UIImageView *)cell.selectedBackgroundView;
    cell.horizontalLine.hidden = NO;
    cell.indicatorView.hidden = NO;
    cell.textLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
    if (indexPath.row == 0) {
        backgroundView.image = [QMImageFactory commonBackgroundImageTopPart];
        selectedBackgroundView.image = [QMImageFactory commonBackgroundImageTopPartPressed];
        cell.textLabel.text = [itemList objectAtIndex:0];
    }else if(indexPath.row == 1) {
        backgroundView.image = [QMImageFactory commonBackgroundImageBottomPart];
        selectedBackgroundView.image = [QMImageFactory commonBackgroundImageBottomPartPressed];
        cell.horizontalLine.hidden = YES;
        cell.textLabel.text = [NSString stringWithFormat:@"客服电话:%@",aboutModel.phoneNumber];
    }else if(indexPath.row == 2) {
        backgroundView.image = [QMImageFactory commonBackgroundImageCenterPart];
        cell.indicatorView.hidden = YES;
        selectedBackgroundView.image = nil;
        cell.textLabel.highlightedTextColor = cell.textLabel.textColor;
        cell.textLabel.text = [NSString stringWithFormat:@"客服邮箱:%@",aboutModel.email];
    }else {
        backgroundView.image = [QMImageFactory commonBackgroundImageCenterPart];
        selectedBackgroundView.image = [QMImageFactory commonBackgroundImageCenterPartPressed];
        
        cell.textLabel.text = [NSString stringWithFormat:@"网站:%@",aboutModel.url];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 8, 50.0f);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==  0) {
        QMAboutHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ABOUT_HEADER_VIEW_IDENTIFIER forIndexPath:indexPath];
        [header setAboutInfo:aboutModel.introduce];
        
        return header;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return [QMAboutHeaderView sizeForHeaderView:aboutModel.introduce];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == QMAboutTableRow_WelcomeRow) {
        [self gotoWelcomViewController];
    }else if (indexPath.row == QMAboutTableRow_WebSiteRow) { // 进入网站
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:aboutModel.url]];
        
        [QMWebViewController3 showWebViewWithRequest:request navTitle:nil isModel:YES from:self];
    }else if (indexPath.row == QMAboutTableRow_HotlineRow) { // 打电话  
        [self makePhoneCall:aboutModel.phoneNumber];
    }
}

- (void)makePhoneCall:(NSString *)phoneNumber {
    if (QM_IS_STR_NIL(phoneNumber)) {
        return;
    }
    NSLog(@"%@",phoneNumber);
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",phoneNumber]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
}

- (void)gotoWelcomViewController {
    QMWelcomeViewController *con = [[QMWelcomeViewController alloc] initWithStart:NO];
    [self.navigationController presentViewController:con animated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_more_about_us_title", @"关于粤融贷");
}

@end
