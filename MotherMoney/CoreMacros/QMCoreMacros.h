//
//  QMCoreMacros.h
//  MotherMoney
//
//  Created by   on 14-8-3.
//  Copyright (c) 2014年  . All rights reserved.
//

#ifndef MotherMoney_QMCoreMacros_h
#define MotherMoney_QMCoreMacros_h

// 判断对象是否为空
// 字符串
#define QM_IS_STR_NIL(objStr) (![objStr isKindOfClass:[NSString class]] || objStr == nil || [objStr length] <= 0)
// 字典
#define QM_IS_DICT_NIL(objDict) (![objDict isKindOfClass:[NSDictionary class]] || objDict == nil || [objDict count] <= 0)
// 数组
#define QM_IS_ARRAY_NIL(objArray) (![objArray isKindOfClass:[NSArray class]] || objArray == nil || [objArray count] <= 0)
// float
#define QM_IS_FLOAT_NIL(objFloat) (objFloat == nil)
// 判断delegate是否响应某个selector
#define QM_IS_DELEGATE_RSP_SEL(iDel, iSel) (iDel != nil && [iDel respondsToSelector:@selector(iSel)])

#define QMLocalizedString(key, comment)     NSLocalizedString(key, comment)

// 判断系统版本
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define QM_THEME_COLOR [UIColor colorWithRed:254.0f / 255.0f green:155.0f / 255.0f blue:60.0f / 255.0f alpha:1.0f]


#define QM_COMMON_BACKGROUND_COLOR [UIColor colorWithRed:218.0f / 255.0f green:218.0f / 255.0f blue:218.0f / 255.0f alpha:1.0f]
//颜色标记
#define QM_COMMON_TEXT_COLOR [UIColor colorWithRed:52.0f / 255.0f green:52.0f / 255.0f blue:52.0f / 255.0f alpha:1.0f]

#define QM_COMMON_SUB_TITLE_COLOR [UIColor colorWithRed:153.0f / 255.0f green:153.0f / 255.0f blue:153.0f / 255.0f alpha:1.0f]

#define QM_COMMON_CELL_HIGHLIGHTED_COLOR [UIColor whiteColor]

#define    kBGTimeKey   @"kBGTimeKey"

#define QM_OFFICIAL_SITE @"http://www.yrdloan.com"
#define QM_OFFICIAL_PHONE_NUMBER @"400-097-3073"

// 手机号已经注册
//#define QM_PHONE_NUMBER_REGISTERED 0
#define QM_PHONE_NUMBER_REGISTERED 30008

// 通知相关key
#define QM_LOGIN_SUCCESS_NOTIFICATION_KEY @"qm_login_success_notification_key" // 登录成功
#define QM_REGISTER_SUCCESS_NOTIFICATION_KEY @"qm_register_success_notification_key" // 注册成功
#define QM_LOGOUT_SUCCESS_NOTIFICATION_KEY @"qm_logout_success_notification_ey"   //退出成功

#define QM_SCORE_SUCCESS_NOTIFICATION_KEY @"qm_score_success_notification_ey"

#define kAppId @"1058299408"

#define AppStoreTemp  @"itms-apps://itunes.apple.com/app/id%@"

#define QM_FETCH_PAGE_SIZE 10

#define QM_DEFAULT_CHANNEL_ID @"2"//钱宝宝channelId

#endif
