//
//  CMMUtility.h
//  MotherMoney
//
//

#import <Foundation/Foundation.h>

@interface CMMUtility : NSObject

// basic auth
+(NSString *)authBasicValueWithUserName:(NSString *)userName password:(NSString *)pwd;

// base64 Encode
+(NSString *) Base64EncodedStringFromString:(NSString *)string;

// show alert view with content
+(void)showNote:(NSString *)content;

+ (void)showNoteWithError:(NSError *)error;

+ (void)showNoteMsgWithError:(NSError *)error;

// show temp login view
+(void)showTMPLogin;

// show alert view with delegate and alert String
+(void)showAlertWith:(NSString *)alertStr target:(id)target tag:(int)tag;

// show network Indicator
+(void)showWaitingAlertView;

// hide network Indicator
+(void)hideWaitingAlertView;

// 显示成功信息
+ (void)showSuccessMessage:(NSString *)message;

// verify phone number with regex
+(BOOL)checkPhoneNumber:(NSString *)phone;

// verify user identifier number with regex
+(BOOL)checkIdNumber:(NSString *)idNumber;

// verfy string is legal
+(BOOL)isStringOk:(NSString *)str;

// verfy number is legal
+(BOOL)isNumberData:(id)data;

+(void)shakeView:(UIView *)view;

+(NSString *)formatterNumberWithComma:(id)number;

+(NSString *)formatterFourNumberWithComma:(id)number;

+(NSString *)obtainDeviceIDFV;

+(NSString *)obtainDeviceIDFA;

+(NSString *)osVersion;

+(NSString *)openUDID;

+ (NSString *) macaddress;



@end
