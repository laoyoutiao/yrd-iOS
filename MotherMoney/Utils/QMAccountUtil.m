//
//  QMAccountUtil.m
//  MotherMoney

#import "QMAccountUtil.h"
#import "LockBox/Lockbox.h"

#define QM_CURRENT_ACCOUNT_KEY @"qm_current_account"

@implementation QMAccountUtil {
    QMAccountInfo *mCurrentAccount;
}

+ (QMAccountUtil *)sharedInstance {
    static QMAccountUtil *sharedInstance_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [[QMAccountUtil alloc] init];
    });
    
    return sharedInstance_;
}

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginSuccessNotification:) name:QM_LOGIN_SUCCESS_NOTIFICATION_KEY object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRegisterSuccessNotification:) name:QM_REGISTER_SUCCESS_NOTIFICATION_KEY object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogoutSuccessNotification:) name:QM_LOGOUT_SUCCESS_NOTIFICATION_KEY object:nil];
        
        // 保证账号已经存在
        [self currentAccount];
    }

    return self;
}

- (void)handleLoginSuccessNotification:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSString *phonenumber = [userInfo objectForKey:QM_PHONE_NUMBER_KEY];
    NSString *password = [userInfo objectForKey:QM_USER_PASSWORD_KEY];
    
    QMAccountInfo *account = self.currentAccount;
    if (!QM_IS_STR_NIL(phonenumber)) {
        account.phoneNumber = phonenumber;
    }
    
    if (!QM_IS_STR_NIL(password)) {
        account.password = password;
    }
    
    [self saveCurrentAccountInfo];
}

// 清除缓存的数据
- (void)handleLogoutSuccessNotification:(NSNotification *)noti {
    [self clearCurrentAccountInfo];
}

- (void)handleRegisterSuccessNotification:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSString *phonenumber = [userInfo objectForKey:QM_PHONE_NUMBER_KEY];
    NSString *password = [userInfo objectForKey:QM_USER_PASSWORD_KEY];
    
    QMAccountInfo *account = self.currentAccount;
    if (!QM_IS_STR_NIL(phonenumber)) {
        account.phoneNumber = phonenumber;
    }
    
    if (!QM_IS_STR_NIL(password)) {
        account.password = password;
    }
    
    [self saveCurrentAccountInfo];
}

- (QMAccountInfo *)currentAccount {
    if (nil == mCurrentAccount) {
        NSDictionary *dict = [QMPreferenceUtil getGlobalDictKey:QM_CURRENT_ACCOUNT_KEY];
        
        QMAccountInfo *info = [[QMAccountInfo alloc] initWithDictionary:dict];
        // 尝试设置密码和手势密码
        
        NSDictionary *dictPwd = [Lockbox dictionaryForKey:QM_PASSSORD_KEY];
        if (!QM_IS_DICT_NIL(dictPwd)) {
            info.password = [dictPwd objectForKey:QM_USER_PASSWORD_KEY];
            info.recPwd = [dictPwd objectForKey:QM_RECT_PASSWORD_KEY];
        }

        mCurrentAccount = info;
    }
    
    return mCurrentAccount;
}

- (void)saveCurrentAccountInfo {
    NSDictionary *dict = [mCurrentAccount dictAccountInfo];
    if (QM_IS_DICT_NIL(dict)) {
        [QMPreferenceUtil removeGlobalKey:QM_CURRENT_ACCOUNT_KEY syncWrite:YES];
        [self clearPasswordFromKeyChain];
    }else {
        [QMPreferenceUtil setGlobalDictKey:QM_CURRENT_ACCOUNT_KEY value:dict syncWrite:YES];
        [self savePasswordToKeyChain];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:QM_ACCOUNT_INFO_DID_SAVE object:nil userInfo:nil];
}

- (void)savePasswordToKeyChain {
    NSString *password = mCurrentAccount.password;
    NSString *rectPwd = mCurrentAccount.recPwd;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (!QM_IS_STR_NIL(password)) {
        [dict setObject:password forKey:QM_USER_PASSWORD_KEY];
    }
    
    if (!QM_IS_STR_NIL(rectPwd)) {
        [dict setObject:rectPwd forKey:QM_RECT_PASSWORD_KEY];
    }
    
    [Lockbox setDictionary:dict forKey:QM_PASSSORD_KEY];
}

- (void)clearPasswordFromKeyChain {
    // 从keychain中删除
    [Lockbox setDictionary:nil forKey:QM_PASSSORD_KEY];
}

// 暂时只清除密码和手势密码
- (void)clearCurrentAccountInfo {
    mCurrentAccount.password = nil;
    mCurrentAccount.recPwd = nil;
    
    [self clearPasswordFromKeyChain];
}

- (void)closeRectPwd {
    mCurrentAccount.recPwd = nil;
    [self savePasswordToKeyChain];
}

- (void)openRectPwd:(NSString *)rectpwd {
    mCurrentAccount.recPwd = rectpwd;
    
    [self savePasswordToKeyChain];
}

- (BOOL)userHasLogin {
    return [mCurrentAccount isLogin];
}

- (BOOL)isUserUsingRectPwd {
    return [mCurrentAccount isUsingRecPwd];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QM_LOGIN_SUCCESS_NOTIFICATION_KEY object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QM_REGISTER_SUCCESS_NOTIFICATION_KEY object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QM_LOGOUT_SUCCESS_NOTIFICATION_KEY object:nil];
}

@end
