//
//  QMProductInfoViewController.m
//  MotherMoney
//
//  Created by   on 14-8-7.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMProductInfoViewController.h"
#import "QMProductInfoCell.h"
#import "QMProductInfoItemCell.h"
#import "QMProductInfoActionCell.h"
#import "QMProductInfoNumberCell.h"
#import "QMProductInfoAbstractCell.h"
#import "QMBuyProductInputMoneyViewController.h"
#import "QMCalculatorView.h"
#import "QMSetPayPasswordViewController.h"
#import "QMIdentityAuthenticationViewController.h"
#import "QMProductIntroductionViewController.h"
#import "QMProductWindControlViewController.h"
#import "QMOpenChannelAccoutViewController.h"
#import "QMProductDescriptionCell.h"
#import "QMBuyProductInputMoneyViewControllerV2.h"
#import "BlockActionSheet.h"
#import "UMSocialSnsPlatformManager.h"

#define QMProductInfoItemCellIdentifier @"QMProductInfoItemCellIdentifier"
#define QMProductInfoActionCellIdentifier @"QMProductInfoActionCellIdentifier"
#define QMProductInfoDescriptionCellIdentifier @"QMProductInfoDescriptionCellIdentifier"
#define QMProductInfoNumberCellIdentifier @"QMProductInfoNumberCellIdentifier"
#define QMProductInfoAbstractCellIdentifier @"QMProductInfoAbstractCellIdentifier"

#define ACCOUNT_SECURE_ALERT_VIEW_TAG 5001

#define QM_AUTH_REAL_NAME_ALERT_VIEW_TAG 6001
#define QM_SET_PAY_PASSWORD_ALERT_VIEW_TAG 6002

typedef enum {
    QMProductInfoTableRow_Abstract = 0, // 摘要
    QMProductInfoTableRow_Amount, // 数字信息
    QMProductInfoTableRow_ProductDescription,// 理财期限、描述等信息
    QMProductInfoTableRow_Introduction, // 项目描述
//    QMProductInfoTableRow_windControl, // 风控措施
    QMProductInfoTableRow_ContractTemplate, // 合同模版
    QMProductInfoTableRow_Action,
    QMProductInfoTableRow_Count,
    QMProductInfoTableRow_FinanceLimit, // 理财期限
    QMProductInfoTableRow_PurchaseAmount, // 起购金额
    QMProductInfoTableRow_Risk, // 风险 暂时不要这行
}QMProductInfoTableRow;
//详情界面
@interface QMProductInfoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate, QMOpenChannelAccoutViewControllerDelegate>

@end

@implementation QMProductInfoViewController {
    QMProductInfo *mProductInfo;
    UICollectionView *productInfoTable;
    UIToolbar *bottomBar;
}

- (id)initViewControllerWithProductInfo:(QMProductInfo *)product {
    if (self = [super init]) {
        mProductInfo = product;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpBottomBar];
    [self setUpProductInfoTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (QM_IS_STR_NIL(mProductInfo.product_id)) {
        return;
    }
    
    // 获取产品详情
    [[NetServiceManager sharedInstance] getProductDetailWithProductId:mProductInfo.product_id
                                                             delegate:self
                                                              success:^(id responseObject) {
                                                                  // 更新产品信息
                                                                  if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                                      NSDictionary *dict = [responseObject objectForKey:@"product"];
                                                                      if (QM_IS_DICT_NIL(dict)) {
                                                                          return;
                                                                      }
                                                                      NSLog(@"%@",dict);
                                                                      QMProductInfo *productInfo = [[QMProductInfo alloc] initWithDictionary:dict];
                                                                      mProductInfo = productInfo;
                                                                  }
                                                                  
                                                                  [productInfoTable reloadData];
                                                                  [self setUpBottomBar];
                                                              } failure:^(NSError *error) {
                                                                  [SVProgressHUD showErrorWithStatus:QMLocalizedString(@"qm_get_product_detail_failed", @"获取产品详情失败")];
                                                              }];
}

#pragma mark -
#pragma mark SetUp
- (void)setUpProductInfoTable {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    flowLayout.minimumLineSpacing = 0;
    
    productInfoTable = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(bottomBar.frame)) collectionViewLayout:flowLayout];
    productInfoTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    productInfoTable.alwaysBounceVertical = YES;
    
    [productInfoTable registerClass:[QMProductInfoItemCell class] forCellWithReuseIdentifier:QMProductInfoItemCellIdentifier];
    //理财期限
    [productInfoTable registerClass:[QMProductDescriptionCell class] forCellWithReuseIdentifier:QMProductInfoDescriptionCellIdentifier];
    //查看产品详情、账户资金安全。。保护的cell
    [productInfoTable registerClass:[QMProductInfoActionCell class] forCellWithReuseIdentifier:QMProductInfoActionCellIdentifier];
    //融资金额、购买人数、起购资金的cell
    [productInfoTable registerClass:[QMProductInfoNumberCell class] forCellWithReuseIdentifier:QMProductInfoNumberCellIdentifier];
    //预期年化率、产品名称的cell
    [productInfoTable registerClass:[QMProductInfoAbstractCell class] forCellWithReuseIdentifier:QMProductInfoAbstractCellIdentifier];
    
    productInfoTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    productInfoTable.delegate = self;
    productInfoTable.dataSource = self;
    [self.view addSubview:productInfoTable];
}

- (void)onBack {
    if (self.isModel) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (UIBarButtonItem *)leftBarButtonItem {
    if (self.isModel) {
        return [QMNavigationBarItemFactory createNavigationBackItemWithTarget:self selector:@selector(onBack)];
    }
    
    return nil;
}

- (UIBarButtonItem *)rightBarButtonItem {
    return [QMNavigationBarItemFactory createNavigationItemWithTitle:@"分享" target:self selector:@selector(shareToPlatform) isLeft:NO];
}

- (void)shareToPlatform {
    NSString* shareStr1=SHARE_PRODUCT_BASE;
    NSString* shareStr2=[shareStr1 stringByAppendingString:mProductInfo.product_id];
    __block NSString *shareUrl = shareStr2;
    __block NSString *shareContent =@"这个产品棒棒哒，一块来买吧！";
    __block NSString *platform = nil;
    UIImage *shareImage = nil;
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@"分享到"];
    // 短信
    [sheet addButtonWithTitle:@"短信" imageName:@"message_icon.png" block:^{
        platform = UMShareToSms;
//        [self shareTo:platform content:shareContent image:shareImage];
        
        [self shareTo:platform content:shareContent image:shareImage shareUrl:shareUrl];
    }];
    
    // 微信好友
    [sheet addButtonWithTitle:@"微信好友" imageName:@"wechat_icon.png" block:^{
        platform = UMShareToWechatSession;
        [self shareTo:platform content:shareContent image:shareImage shareUrl:shareUrl];
    }];
    
    // 微信朋友圈
    [sheet addButtonWithTitle:@"微信朋友圈" imageName:@"wechat_favirate_icon.png" block:^{
        platform = UMShareToWechatTimeline;
        [self shareTo:platform content:shareContent image:shareImage shareUrl:shareUrl];
    }];

    // 新浪微博
    [sheet addButtonWithTitle:@"新浪微博" imageName:@"sina_icon.png" block:^{
        platform = UMShareToSina;
        [self shareTo:platform content:shareContent image:shareImage shareUrl:shareUrl];
    }];
    
    // QQ
    [sheet addButtonWithTitle:@"QQ" imageName:@"qq_icon.png" block:^{
        platform = UMShareToQQ;
        [self shareTo:platform content:shareContent image:shareImage shareUrl:shareUrl];
    }];
    
    [sheet setDestructiveButtonWithTitle:@"取消" block:^{
        
    }];
    
    [sheet showInView:self.tabBarController.view];
}

- (void)shareTo:(NSString *)platform
        content:(NSString *)content
          image:(UIImage *)image
       shareUrl:(NSString *)shareUrl
{
    
//    [QMUMTookKitManager shareTo:platform title:nil content:content image:image presentedController:self  completion:^(UMSocialResponseEntity *response) {
//        // 提示用户分享成功
//    }];
    [QMUMTookKitManager shareTo:platform title:nil content:content image:image shareUrl:shareUrl presentedController:self completion:^(UMSocialResponseEntity *response) {
        
    }];
}


- (void)setUpBottomBar {
    if (bottomBar.superview != nil) {
        [bottomBar removeFromSuperview];
    }
    
    CGFloat bottomBarHeight = 50;
    bottomBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - bottomBarHeight, CGRectGetWidth(self.view.frame), bottomBarHeight)];
    bottomBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    UIBarButtonItem *leftFixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftFixedSpaceItem.width = -16;
    
    // 计算按钮
    UIButton *calculateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    calculateBtn.backgroundColor = [UIColor greenColor];
    [calculateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [calculateBtn setBackgroundImage:[[UIImage imageNamed:@"products_computer_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:25] forState:UIControlStateNormal];
    [calculateBtn setImage:[UIImage imageNamed:@"products_computer.png"] forState:UIControlStateNormal];
    [calculateBtn setImage:[UIImage imageNamed:@"products_computer_pressed.png"] forState:UIControlStateHighlighted];
    calculateBtn.frame = CGRectMake(0, 0, 54, CGRectGetHeight(bottomBar.frame));
    [calculateBtn addTarget:self action:@selector(calculateEarningsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *calculateItem = [[UIBarButtonItem alloc] initWithCustomView:calculateBtn];
    
    
    // 购买按钮
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.backgroundColor = [UIColor redColor];
    if ([mProductInfo.productChannelId isEqualToString:QM_DEFAULT_CHANNEL_ID]) { // 钱宝宝
        [buyBtn setTitle:QMLocalizedString(@"qm_recommendation_buy_btn_title", @"购买") forState:UIControlStateNormal];
        [buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
        
        //label			
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:11.0f];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"剩余份额%@份", [NSNumber numberWithInteger:[mProductInfo.remainingAmount integerValue]]];
        [buyBtn addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(buyBtn.mas_left);
            make.right.equalTo(buyBtn.mas_right);
            make.bottom.equalTo(buyBtn.mas_bottom).offset(-5.0f);
        }];
    }else if([mProductInfo.productChannelId isEqualToString:@"1"]) { // 钱生钱
        [buyBtn setTitle:QMLocalizedString(@"qm_recommendation_buy_btn_title", @"购买") forState:UIControlStateNormal];
    }
    buyBtn.frame = CGRectMake(0, 0, 250, CGRectGetHeight(bottomBar.frame));
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [buyBtn setBackgroundImage:[[UIImage imageNamed:@"products_buy_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:25] forState:UIControlStateNormal];
    [buyBtn setBackgroundImage:[[UIImage imageNamed:@"products_buy_bg_pressed.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:25] forState:UIControlStateHighlighted];
    //点击即使购买按钮
    [buyBtn addTarget:self action:@selector(buyProductBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buyItem = [[UIBarButtonItem alloc] initWithCustomView:buyBtn];
    
    //
    UIBarButtonItem *rightFixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightFixedSpaceItem.width = -15;
    
    NSArray *items = [[NSArray alloc] initWithObjects:leftFixedSpaceItem, buyItem, calculateItem, rightFixedSpaceItem, nil];
    [bottomBar setItems:items];
    
    [self.view addSubview:bottomBar];
    
    [calculateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(54.0f);
        make.top.equalTo(bottomBar.mas_top);
        make.bottom.equalTo(bottomBar.mas_bottom);
        make.right.equalTo(bottomBar.mas_right);
    }];
    
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomBar.mas_left);
        make.top.equalTo(bottomBar.mas_top);
        make.bottom.equalTo(bottomBar.mas_bottom);
        make.right.equalTo(bottomBar.mas_right).offset(-54);
    }];
}

#pragma mark -
#pragma mark action
- (void)buyProductBtnClicked:(UIButton *)btn {
    // 打点
    btn.enabled = NO;
    [QMUMTookKitManager event:USER_CLICK_BUY_INDETAILVIEW_KEY label:@"用户在详情点击购买"];

    [[NetServiceManager sharedInstance] checkProductCanBuyWithProductId:mProductInfo.product_id
                                                               delegate:self
                                                                success:^(id responseObject) {
                                                                    // 可以购买
                                                                    [self handleCheckResult:responseObject];
                                                                    btn.enabled = YES;
                                                                } failure:^(NSError *error) {
                                                                    // 不可以购买
                                                                    [CMMUtility showNoteWithError:error];
                                                                    btn.enabled = YES;
                                                                }];
}

- (void)handleCheckResult:(id)response {
    NSDictionary *result = (NSDictionary *)response;
    
    if (!QM_IS_DICT_NIL(response)) {
        BOOL hasPayPassword = [[result objectForKey:@"hasPayPassword"] boolValue];
        BOOL hasRealName = [[result objectForKey:@"idCardAuth"] boolValue];
        BOOL subAccount = [[response objectForKey:@"subAccount"] boolValue];

        if (NO == hasRealName) { // 如果没有实名认证，先执行实名认证
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:QMLocalizedString(@"qm_check_update_alert_title", @"提示")
                                                                message:QMLocalizedString(@"qm_real_name_auth_prompt", @"您还没有实名认证，现在实名认证?")
                                                               delegate:self
                                                      cancelButtonTitle:QMLocalizedString(@"qm_cancel_alert_btn_title", @"取消")
                                                      otherButtonTitles:QMLocalizedString(@"qm_ok_alert_btn_title", @"确定"), nil];
            alertView.tag = QM_AUTH_REAL_NAME_ALERT_VIEW_TAG;
            [alertView show];
            
            return;
        }
        
        if (NO == hasPayPassword) { // 没有设置支付密码，设置支付密码
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:QMLocalizedString(@"qm_check_update_alert_title", @"提示")
                                                                message:QMLocalizedString(@"qm_pay_password_set_prompt", @"您还没设置支付密码，现在设置?")
                                                               delegate:self
                                                      cancelButtonTitle:QMLocalizedString(@"qm_cancel_alert_btn_title", @"取消")
                                                      otherButtonTitles:QMLocalizedString(@"qm_ok_alert_btn_title", @"确定"), nil];
            alertView.tag = QM_SET_PAY_PASSWORD_ALERT_VIEW_TAG;
            [alertView show];
            
            return;
        }
        //?????????
        if (NO == subAccount) {
            // 开通渠道账户
            [self gotoOpenChannelAccountViewController];
            return;
        }
        
        [self gotoGetProductPage];
    }
}

- (void)gotoOpenChannelAccountViewController {
    QMOpenChannelAccoutViewController *con = [[QMOpenChannelAccoutViewController alloc] initViewControllerWithChannelId:mProductInfo.productChannelId];
    con.delegate = self;
    con.isModel = YES;
    
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav
                                            animated:YES
                                          completion:^{
                                              
                                          }];
}

- (void)gotoGetProductPage {
    // 既实名认证，也设置了支付密码
    if ([mProductInfo.productChannelId isEqualToString:QM_DEFAULT_CHANNEL_ID]) {
        QMBuyProductInputMoneyViewControllerV2 *con = [[QMBuyProductInputMoneyViewControllerV2 alloc] initViewControllerWithProductInfo:mProductInfo];
        [self.navigationController pushViewController:con animated:YES];
    }else if ([mProductInfo.productChannelId isEqualToString:@"1"]) {
        QMBuyProductInputMoneyViewController *con = [[QMBuyProductInputMoneyViewController alloc] initViewControllerWithProductInfo:mProductInfo];
        [self.navigationController pushViewController:con animated:YES];
    }
}


- (void)calculateEarningsBtnClicked:(UIButton *)btn {
    // 打点
    [QMUMTookKitManager event:USER_CALCULATER_KEY label:@"用户使用计算器"];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    QMCalculatorView *calculator = [[QMCalculatorView alloc] initWithFrame:keyWindow.bounds andProductInfo:mProductInfo];
    [calculator show];
}

- (void)viewProductDetailInfoBtnClicked:(UIButton *)btn {
    // 打点
    [QMUMTookKitManager event:USER_CLICK_PRODUCTDETAIL_HTML_KEY label:@"用户点击详情网页"];
    
    [[NetServiceManager sharedInstance] getDetailProductInfoWithProductId:mProductInfo.product_id
                                                                 delegate:self
                                                                  success:^(id responseObject) {
                                                                      [self gotoProductDetailPageWithResponse:responseObject];
                                                                  } failure:^(NSError *error) {
                                                                      [CMMUtility showNoteWithError:error];
                                                                  }];
}

- (void)gotoProductDetailPageWithResponse:(NSDictionary *)response {
    if (![response isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *detailContent = [response objectForKey:@"productDetail"];
    [QMWebViewController3 showWebViewWithContent:detailContent
                                       navTitle:QMLocalizedString(@"qm_product_detail_html_nav_title", @"产品详情")
                                        isModel:YES
                                           from:self];
}

- (void)gotoProductDetailPage:(NSString *)strUrl {
    if (QM_IS_STR_NIL(strUrl)) {
        return;
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl]];
    
    [QMWebViewController3 showWebViewWithRequest:request navTitle:QMLocalizedString(@"qm_product_more_detail_nav_title", @"详细信息") isModel:YES from:self];
}


- (void)secureBtnClicked:(UIButton *)btn {
    // 打点
//    [QMUMTookKitManager event:USER_CLICK_PRODUCTSAFE_HTML_KEY label:@"用户点击详情安全页面"];
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:QMLocalizedString(@"qm_account_secure_text", @"账户资金安全由平安保险全额承保，发生风险100%赔付，赔付金额无上限")
//                                                       delegate:self
//                                              cancelButtonTitle:nil
//                                              otherButtonTitles:QMLocalizedString(@"qm_account_secure_detail", @"了解详情"), QMLocalizedString(@"qm_account_secure_known", @"知道了"), nil];
//    alertView.tag = ACCOUNT_SECURE_ALERT_VIEW_TAG;
//    [alertView show];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ACCOUNT_SECURE_ALERT_VIEW_TAG: {
            if (buttonIndex == 0) {
                // 了解详情
                [self gotoViewAccountSecureDetailViewController];
            }else {
                // 取消
                
            }
        }
            break;
        case QM_AUTH_REAL_NAME_ALERT_VIEW_TAG: {
            if (buttonIndex == 1) {
                // 实名认证
                [self gotoRealNameAuthenticateViewController];
            }else {
                // 取消
            }
        }
            break;
        case QM_SET_PAY_PASSWORD_ALERT_VIEW_TAG: {
            if (buttonIndex == 1) {
                // 设置支付密码
                [self gotoSetPayPasswordViewController];
            }else {
                // 取消
            }
        }
            break;
        default:
            break;
    }
}

- (void)gotoRealNameAuthenticateViewController {
    // 打点
    [QMUMTookKitManager event:USER_AUTH_REAL_NAME_KEY label:@"用户实名认证"];
    
    QMIdentityAuthenticationViewController *con = [[QMIdentityAuthenticationViewController alloc] init];
    con.isModel = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)gotoSetPayPasswordViewController {
    // 打点
    [QMUMTookKitManager event:USER_SET_PAYPWD_KEY label:@"用户设置支付密码"];
    
    QMSetPayPasswordViewController *con = [[QMSetPayPasswordViewController alloc] init];
    con.title = @"设置交易密码";
    con.isModel = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [nav updateNavigationBarBgWithCurrentBackgroundImage];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)gotoViewAccountSecureDetailViewController {
    [[NetServiceManager sharedInstance] getSecurityTemplateWithDelegate:self
                                                                success:^(id responseObject) {
                                                                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                                        NSDictionary *template = [responseObject objectForKey:@"template"];
                                                                        
                                                                        NSString *agreementContent = [template objectForKey:@"content"];
                                                                        
                                                                        NSString *name = [template objectForKey:@"name"];
                                                                        
                                                                        NSString *navTitle = name;
                                                                        if (QM_IS_STR_NIL(navTitle)) {
                                                                            navTitle = QMLocalizedString(@"qm_safe_Insurance_title", @"平安保险");
                                                                        }
                                                                        
                                                                        [QMWebViewController showWebViewWithContent:agreementContent
                                                                                                           navTitle:navTitle
                                                                                                            isModel:YES
                                                                                                               from:self];
                                                                    }
                                                                } failure:^(NSError *error) {
                                                                    [CMMUtility showNoteWithError:error];
                                                                }];
}

#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return QMProductInfoTableRow_Count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == QMProductInfoTableRow_Abstract) { // 摘要信息，预期年化率
        QMProductInfoAbstractCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMProductInfoAbstractCellIdentifier forIndexPath:indexPath];
        [cell configureCellWithProductInfo:mProductInfo];
        
        return cell;
    }else if (indexPath.item == QMProductInfoTableRow_Amount) {// 融资金额，购买人数，起购金额
        QMProductInfoNumberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMProductInfoNumberCellIdentifier forIndexPath:indexPath];
        [cell configureCellWithProductInfo:mProductInfo];
        
        return cell;
    }else if (indexPath.item == QMProductInfoTableRow_Action) {//  查看产品详情，和安全信息
        QMProductInfoActionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMProductInfoActionCellIdentifier forIndexPath:indexPath];
        [cell.viewProductDetailBtn addTarget:self
                                      action:@selector(viewProductDetailInfoBtnClicked:)
                            forControlEvents:UIControlEventTouchUpInside];
//        [cell.productSecureBtn addTarget:self action:@selector(secureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }else if (indexPath.item == QMProductInfoTableRow_ProductDescription) {
        QMProductDescriptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMProductInfoDescriptionCellIdentifier forIndexPath:indexPath];
        [cell configureCellWithProductInfo:mProductInfo];
        
        return cell;
    }else {
        QMProductInfoItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMProductInfoItemCellIdentifier forIndexPath:indexPath];
        
        if (indexPath.row == QMProductInfoTableRow_Risk) {
            cell.showsIndicator = YES;
            cell.itemTitleLabel.text = @"风险";
            cell.itemValueLabel.text = @"有一定风险3R";
        }else if (indexPath.row == QMProductInfoTableRow_FinanceLimit) {
            cell.showsIndicator = NO;
            cell.itemTitleLabel.text = QMLocalizedString(@"qm_calculator_finance_date_title", @"理财期限");
            cell.itemValueLabel.text = mProductInfo.maturityDuration;
        }else if (indexPath.row == QMProductInfoTableRow_PurchaseAmount) {
            cell.showsIndicator = NO;
            cell.itemTitleLabel.text = QMLocalizedString(@"qm_product_info_page_purchaseAmountLimit_title", @"起购金额");
            cell.itemValueLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:[mProductInfo.minAmount integerValue]]];
        }else if(indexPath.row == QMProductInfoTableRow_Introduction) {
            cell.showsIndicator = YES;
            cell.itemTitleLabel.text = QMLocalizedString(@"qm_product_introduction", @"项目描述");
            cell.itemValueLabel.text = @"";
        }else if (indexPath.row == QMProductInfoTableRow_ContractTemplate) {
            // 合同模版
            cell.showsIndicator = YES;
            cell.itemTitleLabel.text = QMLocalizedString(@"qm_product_contract_template", @"合同模版");
            cell.itemValueLabel.text = @"";
        }
        
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    UIEdgeInsets insets = flowLayout.sectionInset;
    
    if (indexPath.row == QMProductInfoTableRow_Abstract) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - insets.left - insets.right, [QMProductInfoAbstractCell getCellHeightForProductInfo:mProductInfo]);
    }else if (indexPath.row == QMProductInfoTableRow_Amount) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - insets.left - insets.right, [QMProductInfoNumberCell getCellHeightForProductInfo:mProductInfo]);
    }else if (indexPath.row == QMProductInfoTableRow_Action) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - insets.left - insets.right, [QMProductInfoActionCell getCellHeightForProductInfo:mProductInfo]);
    }else if (indexPath.item == QMProductInfoTableRow_ProductDescription) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - insets.left - insets.right, [QMProductDescriptionCell getCellHeightForProductInfo:mProductInfo]);
    }else {
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - insets.left - insets.right, [QMProductInfoItemCell getCellHeightForProductInfo:mProductInfo]);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == QMProductInfoTableRow_windControl) {
//        QMProductWindControlViewController *con = [[QMProductWindControlViewController alloc] initViewControllerWithProductId:mProductInfo.product_id];
//        [self.navigationController pushViewController:con animated:YES];
//    }else
    
        
    if (indexPath.row == QMProductInfoTableRow_Introduction)
    {
        NSString* string1=@"http://m.yrdloan.com/wap/product/productDetail?showNav=0&productId=";
//        NSString* str=@"http://m.qianmama.com/wap/product/productDetail?productId=979&showNav=0";
        NSString* string2=[string1 stringByAppendingString:mProductInfo.product_id];
        NSURL* url=[NSURL URLWithString:string2];
//        NSURL* url1=[NSURL URLWithString:str];
        NSURLRequest* request=[NSURLRequest requestWithURL:url];
        
        [QMWebViewController showWebViewWithRequest:request navTitle:@"产品描述" isModel:YES from:self];
        
        
    }else if (indexPath.row == QMProductInfoTableRow_ContractTemplate) {
        [self showContractTemplate];
    }
}

- (void)showContractTemplate {
    [[NetServiceManager sharedInstance] getContractTemplateForProduct:mProductInfo.product_id
                                                             delegate:self
                                                              success:^(id responseObject) {
                                                                  if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                                      NSDictionary *template = [responseObject objectForKey:@"agreementTemplate"];
                                                                      
                                                                      NSString *agreementContent = [template objectForKey:@"agreementContent"];
                                                                      
                                                                      [QMWebViewController3 showWebViewWithContent:agreementContent
                                                                                                         navTitle:QMLocalizedString(@"qm_product_contract_template", @"合同模版")
                                                                                                          isModel:YES
                                                                                                             from:self];
                                                                  }
                                                              } failure:^(NSError *error) {
                                                                  [CMMUtility showNoteWithError:error];
                                                              }];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_product_detail_nav_title", @"详情");
}

#pragma mark -
#pragma mark QMOpenChannelAccoutViewControllerDelegate
- (void)channelAccountDidOpenSuccess:(QMOpenChannelAccoutViewController *)controller {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
