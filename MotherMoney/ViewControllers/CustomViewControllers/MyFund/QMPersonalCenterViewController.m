//
//  QMPersonalCenterViewController.m
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import "QMPersonalCenterViewController.h"
#import "QMSwitchCell.h"
#import "QMAccountSecureCell.h"
#import "QMPersonalCenterItemInfoCell.h"
#import "QMResetRecPwdViewController.h"
#import "QMIdentityAuthenticationViewController.h"
#import "QMResetPwdForPhoneViewController.h"
#import "QMSetPayPasswordViewController.h"
#import "QMModifyPayPwdViewController.h"
#import "QMResetPasswordViewController.h"
#import "QMGoodsListViewController.h"
#import "QMConfirmPayPwdViewController.h"
#import "QMMyBankCardViewController.h"

@interface QMPersonalCenterViewController () <UITableViewDataSource, UITableViewDelegate, QMResetRecPwdViewControllerDelegate, QMIdentityAuthenticationViewControllerDelegate, QMSetPayPasswordViewControllerDelegate, /*QMModifyPayPwdViewControllerDelegate,*/ QMConfirmPayPwdViewControllerDelegate, QMResetPasswordViewControllerDelegate>

@end

@implementation QMPersonalCenterViewController {
    NSMutableArray *itemList;
    
    UITableView *accountInfoTable;
    
    QMAccountInfo *accountInfo;
    
    NSString *intergral;
    
    NSString *score;
}

- (id)initViewControllerWithAccountInf:(QMAccountInfo *)info {
    if (self = [super init]) {
        accountInfo = info;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    intergral = @"0";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    [self initOrUpdateDataSource];
    [self setUpAccountInfoTable];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reloadData];
}

- (void)setUpAccountInfoTable {
    accountInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.view.frame) - 2 * 10, CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    accountInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    accountInfoTable.backgroundColor = [UIColor clearColor];
    accountInfoTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    accountInfoTable.sectionHeaderHeight = 10.0f;
    accountInfoTable.sectionFooterHeight = 0;
    accountInfoTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(accountInfoTable.frame), 10)];
    accountInfoTable.delegate = self;
    accountInfoTable.dataSource = self;
    [self.view addSubview:accountInfoTable];
}

- (void)initOrUpdateDataSource {
    if (nil == itemList) {
        itemList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [itemList removeAllObjects];
    
    // 账户
    QMPersonalCenterItemInfo *accountInfoItem = [[QMPersonalCenterItemInfo alloc] init];
    accountInfoItem.iconImageName = @"no_authentication_head.png";
    accountInfoItem.itemName = QMLocalizedString(@"qm_account_center_cell_title", @"账户");
    accountInfoItem.accessoryType = UITableViewCellAccessoryNone;
    accountInfoItem.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!QM_IS_STR_NIL(accountInfo.phoneNumber)) {
        accountInfoItem.itemSubName = [QMStringUtil getPromptPhoneNumberWithPhoneNumber:accountInfo.phoneNumber];
    }
    [itemList addObject:accountInfoItem];
    
    // 实名认证
    QMPersonalCenterItemInfo *realNameItem = [[QMPersonalCenterItemInfo alloc] init];
    realNameItem.iconImageName = @"real_name_authentication.png";
    realNameItem.itemName = QMLocalizedString(@"qm_account_center_realname", @"实名认证");
    realNameItem.accessoryType = UITableViewCellAccessoryNone;
    realNameItem.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!QM_IS_STR_NIL(accountInfo.realName)) {
        realNameItem.itemSubName = [accountInfo.realName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
        realNameItem.accessoryType = UITableViewCellAccessoryNone;
        realNameItem.selectionStyle = UITableViewCellSelectionStyleNone;

        
    }
    if (NO == accountInfo.hasRealName) {
        realNameItem.selectorName = @"gotoRealNameAuthenticateViewController";
        realNameItem.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        realNameItem.selectionStyle = UITableViewCellSelectionStyleDefault;
    }

    [itemList addObject:realNameItem];
    
    // 身份认证
    QMPersonalCenterItemInfo *idCardItem = [[QMPersonalCenterItemInfo alloc] init];
    idCardItem.iconImageName = @"identity_authentication.png";
    idCardItem.itemName = QMLocalizedString(@"qm_account_center_idcard", @"身份认证");
    
    NSLog(@"%u",accountInfo.hasRealName);
    
    if (accountInfo.hasRealName) {
        idCardItem.accessoryType = UITableViewCellAccessoryNone;
        idCardItem.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *idStr = nil;
        
        if (accountInfo.identifierCardId.length == 18) {
            
            
            
            idStr = [NSString stringWithFormat:@"%@****%@",[accountInfo.identifierCardId substringToIndex:5],[accountInfo.identifierCardId substringFromIndex:15]];
        }else if(accountInfo.identifierCardId.length <18 && accountInfo.identifierCardId.length >= 14) {
            idStr = [NSString stringWithFormat:@"%@****%@",[accountInfo.identifierCardId substringToIndex:4],[accountInfo.identifierCardId substringFromIndex:12]];
        }
        idCardItem.itemSubName = idStr;
    }else {
        // 加上箭头
        idCardItem.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        idCardItem.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    if (NO == accountInfo.hasRealName) {
        idCardItem.selectorName = @"gotoRealNameAuthenticateViewController";
    }
    [itemList addObject:idCardItem];
    
    // 我的银行卡
    QMPersonalCenterItemInfo *myBandCardItem = [[QMPersonalCenterItemInfo alloc] init];
    myBandCardItem.iconImageName = @"bank_management.png";
    myBandCardItem.itemName = @"我的银行卡";
    myBandCardItem.selectorName = @"gotoBankCardViewController";
    myBandCardItem.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    myBandCardItem.selectionStyle = UITableViewCellSelectionStyleDefault;
    [itemList addObject:myBandCardItem];
    
    // 交易密码
    QMPersonalCenterItemInfo *tradePwdItem = [[QMPersonalCenterItemInfo alloc] init];
    tradePwdItem.iconImageName = @"change_password.png";
    tradePwdItem.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    tradePwdItem.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (accountInfo.isHasPayPwd) {
        tradePwdItem.itemName = QMLocalizedString(@"qm_account_center_modify_trade_pwd", @"修改交易密码");
        tradePwdItem.selectorName = @"gotoModifyPayPasswordViewController";
    }else {
        tradePwdItem.itemName = QMLocalizedString(@"qm_account_center_set_trade_pwd", @"设置交易密码");
        tradePwdItem.selectorName = @"gotoSetPayPasswordViewController";
    }
    [itemList addObject:tradePwdItem];
    
    // 登录密码
    QMPersonalCenterItemInfo *loginPwdItem = [[QMPersonalCenterItemInfo alloc] init];
    loginPwdItem.iconImageName = @"set_password.png";
    loginPwdItem.itemName = QMLocalizedString(@"qm_account_center_modify_login_pwd", @"修改登录密码");
    loginPwdItem.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    loginPwdItem.selectionStyle = UITableViewCellSelectionStyleDefault;
    loginPwdItem.selectorName = @"gotoModifyLoginPwdViewController";
    [itemList addObject:loginPwdItem];
    
    // 修改手势密码
    if ([[QMAccountUtil sharedInstance] isUserUsingRectPwd]) {
        QMPersonalCenterItemInfo *modifyGesturePwdItem = [[QMPersonalCenterItemInfo alloc] init];
        modifyGesturePwdItem.iconImageName = @"gesture_password.png";
        modifyGesturePwdItem.itemName = QMLocalizedString(@"qm_modify_gesture_pwd", @"修改手势密码");
        modifyGesturePwdItem.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        modifyGesturePwdItem.selectionStyle = UITableViewCellSelectionStyleDefault;
        if ([[QMAccountUtil sharedInstance] isUserUsingRectPwd]) {
            modifyGesturePwdItem.selectorName = @"gotoResetRecPwdViewController";
        }
        [itemList addObject:modifyGesturePwdItem];
    }
    
    // 钱豆信息
    QMPersonalCenterItemInfo *myBeanValueItem = [[QMPersonalCenterItemInfo alloc] init];
    myBeanValueItem.iconImageName = @"bean_password.png";
    myBeanValueItem.itemSubName = intergral;
    myBeanValueItem.selectorName = @"gotoBeanValueViewController";
    myBeanValueItem.itemName = QMLocalizedString(@"qm_my_score_title", @"我的金币");
    myBeanValueItem.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    myBeanValueItem.selectionStyle = UITableViewCellSelectionStyleDefault;
    [itemList addObject:myBeanValueItem];
    
    // 手势密码开关
    QMPersonalCenterItemInfo *gestureSwitchItem = [[QMPersonalCenterItemInfo alloc] init];
    gestureSwitchItem.itemName = [self rectPasswordText];
    gestureSwitchItem.isUsingSwitch = YES;
    gestureSwitchItem.accessoryType = UITableViewCellAccessoryNone;
    gestureSwitchItem.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([[QMAccountUtil sharedInstance] isUserUsingRectPwd]) {
        gestureSwitchItem.switchValue = YES;
    }else {
        gestureSwitchItem.switchValue = NO;
    }
    gestureSwitchItem.selectorName = @"rectActionBtnClicked:";
    [itemList addObject:gestureSwitchItem];
    
    // Touch ID开关
//    if ([VENTouchLock canUseTouchID]) {
//        QMPersonalCenterItemInfo *touchIDSwitchItem = [[QMPersonalCenterItemInfo alloc] init];
//        touchIDSwitchItem.itemName = [self touchIDPasswordText];
//        touchIDSwitchItem.selectorName = @"touchIDActionBtnClicked:";
//        if ([VENTouchLock shouldUseTouchID]) { // touch id为激活状态
//            
//            
//            
//            touchIDSwitchItem.switchValue = YES;
//        }else {
//            touchIDSwitchItem.switchValue = NO;
//        }
//        
//        touchIDSwitchItem.isUsingSwitch = YES;
//        touchIDSwitchItem.accessoryType = UITableViewCellAccessoryNone;
//        touchIDSwitchItem.selectionStyle = UITableViewCellSelectionStyleNone;
//        [itemList addObject:touchIDSwitchItem];
//    }
}


//修改登录密码
- (void)gotoModifyLoginPwdViewController {
    QMResetPasswordViewController *con = [[QMResetPasswordViewController alloc] init];
    con.isModel = YES;
    con.delegate = self;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
//我的银行卡
- (void)gotoBankCardViewController {
    QMMyBankCardViewController *con = [[QMMyBankCardViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}
//我的钱豆
- (void)gotoBeanValueViewController {
    QMGoodsListViewController *con = [[QMGoodsListViewController alloc] init];
    con.currentScoreValue=self.currentAvailabelScore;
    [self.navigationController pushViewController:con animated:YES];
    
}
- (void)updateRectpwdState {
    QMPersonalCenterItemInfo *info = [[QMPersonalCenterItemInfo alloc] init];
    info.iconImageName = nil;
    info.itemName = [self rectPasswordText];
    
    [itemList replaceObjectAtIndex:[itemList count] - 1 withObject:info];
}

//- (NSString *)touchIDPasswordText {
////    if ([VENTouchLock shouldUseTouchID]) {
////        return @"Touch ID解锁";
////    }else {
////        return @"Touch ID解锁";
////    }
//}

- (NSString *)rectPasswordText {
    if ([[QMAccountUtil sharedInstance] isUserUsingRectPwd]) {
        return QMLocalizedString(@"qm_account_center_close_gesture_pwd", @"关闭手势");
    }else {
        return QMLocalizedString(@"qm_account_center_open_gesture_pwd", @"开启手势");
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 获取我的积分信息
    [[NetServiceManager sharedInstance] getIntegralWithDelegate:self success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *customerScore = [responseObject objectForKey:@"customerScore"];
            if ([customerScore isKindOfClass:[NSDictionary class]]) {
                NSString *myIntegral = [NSString stringWithFormat:@"%@", [customerScore objectForKey:@"availableScore"]];
                if ([CMMUtility isStringOk:myIntegral]) {
                    intergral = myIntegral;
                }else {
                    intergral = @"0";
                }
            }
        }

        [self reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [itemList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"normalCellIdentifier";
    
    QMPersonalCenterItemInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[QMPersonalCenterItemInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    QMPersonalCenterItemInfo *info = nil;
    if (indexPath.row < [itemList count]) {
        info = [itemList objectAtIndex:indexPath.row];
    }
    
    UIImageView *backgroundView = (UIImageView *)cell.backgroundView;
    UIImageView *selectedBackgroundView = (UIImageView *)cell.selectedBackgroundView;
    cell.horizontalLine.hidden = NO;
    if (indexPath.row == 0) {
        backgroundView.image = [QMImageFactory commonBackgroundImageTopPart];
        selectedBackgroundView.image = [QMImageFactory commonBackgroundImageTopPartPressed];
    }else if (indexPath.row == [itemList count] - 1) {
        backgroundView.image = [QMImageFactory commonBackgroundImageBottomPart];
        selectedBackgroundView.image = [QMImageFactory commonBackgroundImageBottomPartPressed];
        cell.horizontalLine.hidden = YES;
    }else {
        backgroundView.image = [QMImageFactory commonBackgroundImageCenterPart];
        selectedBackgroundView.image = [QMImageFactory commonBackgroundImageCenterPartPressed];
    }
    
    cell.selectionStyle = info.selectionStyle;
    cell.accessoryType = info.accessoryType;
    if (info.isUsingSwitch && !QM_IS_STR_NIL(info.selectorName)) {
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [sw addTarget:self action:NSSelectorFromString(info.selectorName) forControlEvents:UIControlEventValueChanged];
        [sw setOn:info.switchValue];
        
        cell.accessoryView = sw;
    }
    
    [cell configureCellWithItemInfo:info];
    
    return cell;
}

- (void)touchIDActionBtnClicked:(UISwitch *)sw {
    [VENTouchLock setShouldUseTouchID:sw.on];
    if (sw.isOn) {
        NSString *password = [[QMAccountUtil sharedInstance] currentAccount].password;
        [[VENTouchLock sharedInstance] setPasscode:password];
    }
}

- (void)rectActionBtnClicked:(UISwitch *)sw {
    if (!sw.isOn) {
        // 关闭手势密码
        [[QMAccountUtil sharedInstance] closeRectPwd];
        [self reloadData];
        
    }else {
        
        // 开启手势密码
        
        [self gotoResetRecPwdViewController];
    }
}

- (void)gotoResetRecPwdViewController {
    
    QMResetRecPwdViewController *gestureCon = [[QMResetRecPwdViewController alloc] initWithShowPass:YES];
    
    gestureCon.delegate = self;
    
    QMNavigationController *gestureNavCon = [[QMNavigationController alloc] initWithRootViewController:gestureCon];
    
    [self.navigationController presentViewController:gestureNavCon animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 40 + 30;
    }else if (indexPath.row == [itemList count] - 1) {
        return 55;
    }else {
        return 44.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QMPersonalCenterItemInfo *info = nil;
    if (indexPath.row < [itemList count]) {
        info = [itemList objectAtIndex:indexPath.row];
    }
    
    if (!QM_IS_STR_NIL(info.selectorName) && info.isUsingSwitch == NO) {
        SEL selector = NSSelectorFromString(info.selectorName);
        [self performSelector:selector withObject:nil];
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
    con.delegate = self;
    con.isModel = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [nav updateNavigationBarBgWithCurrentBackgroundImage];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

// 修改支付密码
- (void)gotoModifyPayPasswordViewController {
    QMConfirmPayPwdViewController *con = [[QMConfirmPayPwdViewController alloc] init];
    con.isModel = YES;
    con.delegate = self;
    
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [nav updateNavigationBarBgWithCurrentBackgroundImage];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark -
#pragma mark QMConfirmPayPwdViewControllerDelegate
- (void)confirmPayPwdViewControllerDidResetPayPasswordSuccess:(QMConfirmPayPwdViewController *)controller {
    if (controller.isModel) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popToViewController:self animated:YES];
    }
}

/*
// 修改支付密码
- (void)gotoModifyPayPasswordViewController {
    QMModifyPayPwdViewController *con = [[QMModifyPayPwdViewController alloc] init];
    con.isModel = YES;
    con.delegate = self;
    
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [nav updateNavigationBarBgWithCurrentBackgroundImage];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark -
#pragma mark QMConfirmPayPwdViewControllerDelegate
- (void)modifyPayPwdViewControllerDidResetPayPasswordSuccess:(QMModifyPayPwdViewController *)controller {
    if (controller.isModel) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popToViewController:self animated:YES];
    }
}
 */


#pragma mark -
#pragma mark QMResetRecPwdViewControllerDelegate
- (void)rectPwdViewController:(QMResetRecPwdViewController *)controller
           didSetSuccessfully:(NSString *)newRecPwd {
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self updateRectpwdState];
    
    [self reloadData];
}

- (void)reloadData {
    [self initOrUpdateDataSource];
    [accountInfoTable reloadData];
}

#pragma mark -
#pragma mark QMIdentityAuthenticationViewControllerDelegate
- (void)authenticationViewController:(QMIdentityAuthenticationViewController *)controller
         didAuthenticateWithRealName:(NSString *)realName
                              idCard:(NSString *)idCard {
    
    accountInfo.realName = realName;
    accountInfo.identifierCardId = idCard;
    

    accountInfo.hasRealName = YES;
    
    [self reloadData];
}

#pragma mark -
#pragma mark QMSetPayPasswordViewControllerDelegate
- (void)payPasswordViewController:(QMSetPayPasswordViewController *)controller didSetPayPassword:(NSString *)payPassword {
    accountInfo.isHasPayPwd = YES;
    [self reloadData];
}

#pragma mark -
#pragma mark QMResetPasswordViewControllerDelegate

- (void)passwordDidResetSuccess:(QMResetPasswordViewController *)controller {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_account_center_nav_title", @"账户中心");
}

@end
