//
//  MoreViewController.m
//  MotherMoney
//
//  Created by on 14-8-3.
//  Copyright (c) 2014年. All rights reserved.
//

#import "MoreViewController.h"
#import "QMMoreItemInfo.h"
#import "QMMoreItemInfoCell.h"
#import "QMMoreInfoTableFooterView.h"
#import "QMMessageCenterViewController.h"
#import "QMActivityCenterViewController.h"
#import "QMAssistCenterViewController.h"
#import "QMAboutViewController.h"
#import "UMFeedbackViewController.h"
#import "QMUMTookKitManager.h"
#import "QMGoodsListViewController.h"
#import "BlockActionSheet.h"
#import "UMSocialDataService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialConfig.h"
#import "WXApi.h"
#import "UMSocialAccountManager.h"

#import "QMWebViewController.h"
#define MORE_ITEM_CELL_IDENTIFIER @"more_item_cell_identifier"
#define MORE_ITEM_TABLE_FOOTER_IDENTIFIER @"more_item_table_footer_identifier"

#define HAS_UPDATE_ALERT_VIEW_TAG 6002
#define CONFIRM_LOGOUT_ALERT_VIEW_TAG 6005
#define GOTO_WECHAT_ALERT_VIEW_TAG 6007

#define UM_SINA_ALREADY_FOLLOWED_KEY @"UM_SINA_ALREADY_FOLLOWED_KEY"

@interface MoreViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>

@end

@implementation MoreViewController {
    NSMutableArray *arrMoreItems;
    UICollectionView *moreInfoTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataSource];
    [self setUpMoreInfoTable];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:QM_ACCOUNT_INFO_DID_SAVE
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                                                          [self updateLeftBarButtonItem];
                                                      }];
    [self registerNotification];
}

- (void)setUpMoreInfoTable {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 0, 8);
    moreInfoTable = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    moreInfoTable.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [moreInfoTable registerClass:[QMMoreItemInfoCell class] forCellWithReuseIdentifier:MORE_ITEM_CELL_IDENTIFIER];
    [moreInfoTable registerClass:[QMMoreInfoTableFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MORE_ITEM_TABLE_FOOTER_IDENTIFIER];
    moreInfoTable.delegate = self;
    moreInfoTable.dataSource = self;
    [self.view addSubview:moreInfoTable];
    [moreInfoTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
}

- (void)initDataSource {
    arrMoreItems = [[NSMutableArray alloc] initWithCapacity:0];
    //获取plist 内容
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MoreInfo" ofType:@"plist"];
    NSArray *arrInfo = [NSMutableArray arrayWithContentsOfFile:filePath];
    for (NSArray *array in arrInfo) {
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dict in array) {
            QMMoreItemInfo *item = [[QMMoreItemInfo alloc] initWithDictionary:dict];
            if (item) {
                [tmpArray addObject:item];
            }
            
            // 处理关于的情况
            if ([item.itemTitle isEqualToString:QMLocalizedString(@"qm_more_about_us_title", nil)]) {
                NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                item.itemSubTitle = [NSString stringWithFormat:@"V%@", version];
            }
        }
        [arrMoreItems addObject:tmpArray];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateLeftBarButtonItem];
    [self reloadData];
    
    [self getMessageAndActivityUpdateInformation];
}

- (void)updateLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem = [self leftBarButtonItem];
}

- (UIBarButtonItem *)leftBarButtonItem {
    if (![[QMAccountUtil sharedInstance] userHasLogin]) {
        return [QMNavigationBarItemFactory createNavigationItemWithTitle:QMLocalizedString(@"qm_recommendation_login_btn_title", @"登录")
                                                                  target:self
                                                                selector:@selector(loginBtnClicked:)
                                                                  isLeft:YES];
    }
    
    return nil;
}

- (void)loginBtnClicked:(id)sender {
    // 打点
    [QMUMTookKitManager event:USER_LOGIN_KEY label:@"用户登录"];
    
    LNLogInfo(@"loginBtnClicked !!!");
    [QMLoginManagerUtil showLoginViewControllerFromViewController:self.navigationController];
}

#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [arrMoreItems count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section < [arrMoreItems count]) {
        return [[arrMoreItems objectAtIndex:section] count];
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMMoreItemInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MORE_ITEM_CELL_IDENTIFIER forIndexPath:indexPath];
    
    if (indexPath.section < [arrMoreItems count]) {
        NSArray *items = [arrMoreItems objectAtIndex:indexPath.section];
        if (indexPath.row < [items count]) {
            QMMoreItemInfo *info = [items objectAtIndex:indexPath.row];
            [cell configureCellWithMoreItemInfo:info];
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIEdgeInsets insets = ((UICollectionViewFlowLayout *)collectionView.collectionViewLayout).sectionInset;
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - insets.left - insets.right, [QMMoreItemInfoCell getCellHeightForItemInfo:nil]);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == [arrMoreItems count] - 1) {
        QMMoreInfoTableFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MORE_ITEM_TABLE_FOOTER_IDENTIFIER forIndexPath:indexPath];
        [footerView.actionBtn addTarget:self action:@selector(logoutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        if ([[QMAccountUtil sharedInstance] userHasLogin]) {
            footerView.actionBtn.enabled = YES;
        }else {
            footerView.actionBtn.enabled = NO;
        }
        
        return footerView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == [arrMoreItems count] - 1) {
        // 最后一个
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 100);
    }else {
        return CGSizeZero;
    }
}

- (void)logoutBtnClicked {
    // 打点
    [QMUMTookKitManager event:LOG_OUT_KEY label:@"退出登录"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:QMLocalizedString(@"qm_confirm_logout_title", @"确定退出登录")
                                                       delegate:self
                                              cancelButtonTitle:QMLocalizedString(@"qm_alertview_cancel_title", @"取消")
                                              otherButtonTitles:QMLocalizedString(@"qm_alertview_ok_title", @"确定"), nil];
    alertView.tag = CONFIRM_LOGOUT_ALERT_VIEW_TAG;
    [alertView show];
}

- (void)postLogoutNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:QM_LOGOUT_SUCCESS_NOTIFICATION_KEY object:nil userInfo:nil];
}

- (void)handleLogoutSuccess:(id)responseObject {
    [self postLogoutNotification];
}

- (void)handleLogoutFailure:(NSError *)error {
    [self postLogoutNotification];
}


//在线客服

- (void)gotoFeedbackViewController {
    [self showNativeFeedbackWithAppkey:[QMUMTookKitManager UMAppKey]];
//    UMFeedbackViewController* feedBackCtrl=[[UMFeedbackViewController alloc] init];
//    [self.navigationController pushViewController:feedBackCtrl animated:YES];
}

// 转发好友
- (void)gotoForwardBtnClicked {
    __block NSString *shareContent = @"";
    __block NSString *platform = nil;
    UIImage *shareImage = nil;
    
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@"分享到"];
    // 短信
    [sheet addButtonWithTitle:@"短信" imageName:@"message_icon.png" block:^{
        platform = UMShareToSms;
        [self shareTo:platform content:shareContent image:shareImage];
    }];
    
    // 微信好友
    [sheet addButtonWithTitle:@"微信好友" imageName:@"wechat_icon.png" block:^{
        platform = UMShareToWechatSession;
        [self shareTo:platform content:shareContent image:shareImage];
    }];
    
    // 微信朋友圈
    [sheet addButtonWithTitle:@"微信朋友圈" imageName:@"wechat_favirate_icon.png" block:^{
        platform = UMShareToWechatTimeline;
        [self shareTo:platform content:shareContent image:shareImage];
    }];
    
    // 新浪微博
    [sheet addButtonWithTitle:@"新浪微博" imageName:@"sina_icon.png" block:^{
        platform = UMShareToSina;
        [self shareTo:platform content:shareContent image:shareImage];
    }];
    
    // QQ
    [sheet addButtonWithTitle:@"QQ" imageName:@"qq_icon.png" block:^{
        platform = UMShareToQQ;
        [self shareTo:platform content:shareContent image:shareImage];
    }];
    
    [sheet setDestructiveButtonWithTitle:@"取消" block:^{
        
    }];
    
    [sheet showInView:self.tabBarController.view];
}

- (void)shareTo:(NSString *)platform
        content:(NSString *)content
          image:(UIImage *)image {
//    [QMUMTookKitManager shareTo:platform title:nil content:nil image:image presentedController:self completion:^(UMSocialResponseEntity *response) {
//        // 提示用户分享成功
//    }];
    [QMUMTookKitManager shareTo:platform title:nil content:nil image:image shareUrl:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        
    }];
}

// 关注我们
- (void)gotoFocusBtnClicked {
    NSArray *array = [arrMoreItems objectAtIndex:1];
    QMMoreItemInfo *item = [array objectAtIndex:2];
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:QMLocalizedString(item.itemTitle, nil)];
    // 微信
    [sheet addButtonWithTitle:@"微信公众号" imageName:@"wechat_icon.png" block:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您可在微信-通讯录-添加朋友-查找公众号中搜索\"粤融金服\"，点击关注，可更方便的获取我们的最新信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去关注", nil];
        alert.tag = GOTO_WECHAT_ALERT_VIEW_TAG;
        [alert show];
    }];
    
    // 新浪微博
//    [sheet addButtonWithTitle:@"新浪微博" imageName:@"sina_icon.png" block:^{
//        
//        
////        if ([QMPreferenceUtil getGlobalBoolKey:UM_SINA_ALREADY_FOLLOWED_KEY]) {
////            
////            // 提示已经关注过了
////            [CMMUtility showNote:@"已经关注过了"];
////            return;
////        }
//        
//        //这里判断是否授权
//        if ([UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina]) {
//            
//            
//            // 已经授权，直接关注
//            [self executeFollowOperation];
//        }else {
//            // 先直行授权操作
//            
//            
//            
//            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//                if (response.responseCode == UMSResponseCodeSuccess) {
//                    // 授权成功
//                    [self executeFollowOperation];
//                }
//            });
//        }
//    }];
    
    [sheet setDestructiveButtonWithTitle:@"取消" block:^{
        
    }];
    
    [sheet showInView:self.tabBarController.view];
}

- (void)executeFollowOperation {
    [[UMSocialDataService defaultDataService] requestAddFollow:UMShareToSina followedUsid:@[@"1970132703"] completion:^(UMSocialResponseEntity *response) {
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            // 提示关注微博成功
            [CMMUtility showNote:@"关注微博成功"];
            
            // 存储纪录
            [QMPreferenceUtil setGlobalBoolKey:UM_SINA_ALREADY_FOLLOWED_KEY value:YES syncWrite:YES];
        }
    }];
}

- (void)showNativeFeedbackWithAppkey:(NSString *)appkey {
    UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
    feedbackViewController.hidesBottomBarWhenPushed = YES;
    feedbackViewController.appkey = appkey;
    [self.navigationController pushViewController:feedbackViewController animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section < [arrMoreItems count]) {
        NSArray *items = [arrMoreItems objectAtIndex:indexPath.section];
        if (indexPath.row < items.count) {
            QMMoreItemInfo *item = [items objectAtIndex:indexPath.row];
            if (item.selector) {
                [self performSelector:item.selector withObject:nil];
            }
        }
    }
}

#pragma mark -
#pragma mark Action
// 活动中心
- (void)gotoActivityCenterViewController {
    [QMUMTookKitManager event:SHOW_ACTIVITY_KEY label:@"显示活动"];
    
    QMActivityCenterViewController *con = [[QMActivityCenterViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

// 消息中心
- (void)gotoMessageCenterViewController {
    [QMUMTookKitManager event:SHOW_MSG_KEY label:@"显示消息中心"];
    
    QMMessageCenterViewController *con = [[QMMessageCenterViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

// 帮助中心
- (void)gotoHelpCenterViewController {
    [QMUMTookKitManager event:SHOW_HELP_KEY label:@"显示帮助"];
    
    QMAssistCenterViewController *con = [[QMAssistCenterViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

//在线客服
- (void)gotoFeedBackViewController {
    [self gotoFeedbackViewController];
     //http://123.57.51.29:6081/wap/product/productDetail?productId=944
//    NSMutableString* string=[NSMutableString stringWithString:URL_BASE];
//    [string appendString:kCustomerServer];
//    
//    NSURL* url=[NSURL URLWithString:string];
//
////    NSURL* url2=[NSURL URLWithString:@"https://www.baidu.com"];
////    NSURL* url1=[NSURL URLWithString:@"http://123.57.51.29:6081/wap/product/productDetail?productId=944"];
//    NSURLRequest* request=[[NSURLRequest alloc] initWithURL:url];
//    
//    [QMWebViewController showWebViewWithRequest:request navTitle:@"在线客服" isModel:NO from:self];
    
}

// 给我鼓励
- (void)openAppComment {
    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@", kAppId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

// 关于
- (void)gotoAboutViewController {
    QMAboutViewController *con = [[QMAboutViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)showNoUpdateNote {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:QMLocalizedString(@"qm_check_update_alert_title", @"提示")
                                                        message:QMLocalizedString(@"qm_check_update_no_update_message", @"当前已是最新版本!")
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:QMLocalizedString(@"qm_ok_alert_btn_title", @"确定"), nil];
    
    [alertView show];
}

- (void)showHasNormalUpdateNote {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:QMLocalizedString(@"qm_check_update_alert_title", @"提示")
                                                        message:QMLocalizedString(@"qm_check_update_has_new_version", @"有新版本，前去更新!")
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:QMLocalizedString(@"qm_ok_alert_btn_title", @"确定"), QMLocalizedString(@"qm_cancel_alert_btn_title", @"取消"), nil];
    alertView.tag = HAS_UPDATE_ALERT_VIEW_TAG;
    [alertView show];
}

- (void)openAppUpdate {
    NSString *url = [NSString stringWithFormat:AppStoreTemp,kAppId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case HAS_UPDATE_ALERT_VIEW_TAG: {
            if (buttonIndex == 0) {
                // 更新
                [self openAppUpdate];
            }
        }
            break;
        case CONFIRM_LOGOUT_ALERT_VIEW_TAG: {
            if (buttonIndex == 1) {
                [[NetServiceManager sharedInstance] userLogoutWithWithDelegate:self
                                                                       success:^(id responseObject) {
                                                                           // 登出成功
                                                                           [self handleLogoutSuccess:responseObject];
                                                                       } failure:^(NSError *error) {
                                                                           // 登出失败
                                                                           [self handleLogoutFailure:error];
                                                                       }];
            }
        }
            break;
        case GOTO_WECHAT_ALERT_VIEW_TAG: {
            if (buttonIndex == 1) {
                // 进入微信
                [WXApi openWXApp];
            }
        }
        default:
            break;
    }
}

- (void)handleLoginStatusNotification:(NSNotification *)noti {
    [self updateLeftBarButtonItem];
    [moreInfoTable reloadData];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginStatusNotification:) name:QM_LOGIN_SUCCESS_NOTIFICATION_KEY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginStatusNotification:) name:QM_REGISTER_SUCCESS_NOTIFICATION_KEY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginStatusNotification:) name:QM_LOGOUT_SUCCESS_NOTIFICATION_KEY object:nil];
    
    
}

- (void)getMessageAndActivityUpdateInformation {
    [[NetServiceManager sharedInstance] getMsgActivityLastUpdateTimeWithDelegate:self
                                                                         success:^(id responseObject) {
                                                                             NSLog(@"response:%@", responseObject);
                                                                             if (!QM_IS_DICT_NIL(responseObject)) {
                                                                                 [self handleMsgAndActivityUpdateInfoSuccess:responseObject];
                                                                             }
                                                                         } failure:^(NSError *error) {
                                                                             // 获取成功
                                                                             
                                                                         }];
}

- (void)handleMsgAndActivityUpdateInfoSuccess:(NSDictionary *)resposneObject {
    NSString *lastMessage = [NSString stringWithFormat:@"%@", [resposneObject objectForKey:@"lastMessage"]];
    NSString *lastActivity = [NSString stringWithFormat:@"%@", [resposneObject objectForKey:@"lastActivity"]];
    
    if ([CMMUtility isStringOk:lastMessage]) {
        [QMPreferenceUtil setGlobalKey:MESSAGE_LAST_UPDATE_TIME value:lastMessage syncWrite:YES];
    }
    
    if ([CMMUtility isStringOk:lastActivity]) {
        [QMPreferenceUtil setGlobalKey:ACTIVITY_LAST_UPDATE_TIME value:lastActivity syncWrite:YES];
    }
    
    [self reloadData];
}

- (void)reloadData {
    NSString *lastMessage = [QMPreferenceUtil getGlobalKey:MESSAGE_LAST_UPDATE_TIME];
    NSString *lastActivity = [QMPreferenceUtil getGlobalKey:ACTIVITY_LAST_UPDATE_TIME];
    
    NSString *lastMessageRead = [QMPreferenceUtil getGlobalKey:MESSAGE_LAST_READ_TIME];
    NSString *lastActivityRead = [QMPreferenceUtil getGlobalKey:ACTIVITY_LAST_READ_TIME];
    
    if ([CMMUtility isStringOk:lastMessage]) {
        [QMPreferenceUtil setGlobalKey:MESSAGE_LAST_UPDATE_TIME value:lastMessage syncWrite:YES];
    }
    
    if ([CMMUtility isStringOk:lastActivity]) {
        [QMPreferenceUtil setGlobalKey:ACTIVITY_LAST_UPDATE_TIME value:lastActivity syncWrite:YES];
    }
    
    NSArray *items = [arrMoreItems objectAtIndex:0];
    QMMoreItemInfo *activityItem = [items objectAtIndex:0];
    QMMoreItemInfo *messageItem = [items objectAtIndex:1];
    
    if ([lastMessage longLongValue] > [lastMessageRead longLongValue]) { // 消息有未读
        messageItem.hasUnReadInfo = YES;
    }else {
        messageItem.hasUnReadInfo = NO;
    }
    
    if ([lastActivity longLongValue] > [lastActivityRead longLongValue]) { // 活动有未读
        activityItem.hasUnReadInfo = YES;
    }else {
        activityItem.hasUnReadInfo = NO;
    }
    
    [moreInfoTable reloadData];
}

- (void)unRegisterNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QM_LOGIN_SUCCESS_NOTIFICATION_KEY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QM_REGISTER_SUCCESS_NOTIFICATION_KEY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QM_LOGOUT_SUCCESS_NOTIFICATION_KEY object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QM_ACCOUNT_INFO_DID_SAVE object:nil];
    [self unRegisterNotification];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_navigation_title_more", @"更多");
}

@end
