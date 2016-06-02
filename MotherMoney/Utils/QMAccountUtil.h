//
//  QMAccountUtil.h
//  MotherMoney
//

#import <Foundation/Foundation.h>

#define QM_ACCOUNT_INFO_DID_SAVE @"qm_account_info_did_save"

@interface QMAccountUtil : NSObject

+ (QMAccountUtil *)sharedInstance;

- (QMAccountInfo *)currentAccount;

- (void)saveCurrentAccountInfo;

- (void)closeRectPwd;

- (void)openRectPwd:(NSString *)rectpwd;

- (BOOL)userHasLogin;

- (BOOL)isUserUsingRectPwd;

- (void)clearCurrentAccountInfo;

@end
