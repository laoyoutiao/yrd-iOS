
#import "CMMUtility.h"
#import "SVProgressHUD.h"
#import "RegexKitLite.h"
#import "OpenUDID.h"
#import <AdSupport/AdSupport.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation CMMUtility

+(NSString *)authBasicValueWithUserName:(NSString *)userName password:(NSString *)pwd
{
    NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", userName, pwd];
    NSString *basicValue = [NSString stringWithFormat:@"Basic %@",[CMMUtility Base64EncodedStringFromString:basicAuthCredentials]];
    if (basicValue) {
        return basicValue;
    }else{
        return @"";
    }
}

+ (NSString *) Base64EncodedStringFromString:(NSString *)string {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

+ (void)showNoteWithError:(NSError *)error {
    
    
    
    NSString *errorMsg = [error.userInfo objectForKey:kNetWorErrorMsg];
    NSLog(@"%@",errorMsg);
    
    if (!QM_IS_STR_NIL(errorMsg)) {
        UIAlertView *alertInstance  = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertInstance show];
        
        
        
        
    }
}

//不可以购买时显示的错误信息提示
+ (void)showNoteMsgWithError:(NSError *)error {
    NSString *errorMsg = [error.userInfo objectForKey:kNetWorErrorMsg];
    [SVProgressHUD showErrorWithStatus:errorMsg];
}

+(void)showNote:(NSString *)alertContent
{
    UIAlertView *alertInstance  = [[UIAlertView alloc] initWithTitle:@"提示" message:alertContent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertInstance show];
    
    

    
    
}

+(void)showTMPLogin {
    [[AppDelegate appDelegate] handleUserNotNotLoginError];
}

+(void)showAlertWith:(NSString *)alertStr target:(id)target tag:(int)tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:alertStr delegate:target cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = tag;
    alertView.delegate = target;
    [alertView show];
}

+ (void)showSuccessMessage:(NSString *)message {
    [SVProgressHUD showSuccessWithStatus:message];
}

+(void)showWaitingAlertView
{
    
    
    [SVProgressHUD show];
}

+(void)hideWaitingAlertView
{
    [SVProgressHUD dismiss];
}

+(BOOL)isStringOk:(NSString *)str {
    if (![str isKindOfClass:[NSString class]]) {
        return NO;
    }
    if ([[str lowercaseString] isEqualToString:@"(null)"]) {
        return NO;
    }
    if ([[str lowercaseString] isEqualToString:@"<null>"]) {
        return NO;
    }
    if ([[str lowercaseString] isEqualToString:@"null"]) {
        return NO;
    }
    if (str != nil && [str length] >0 && ![@"" isEqualToString:str]) {
        return YES;
    }else {
        return NO;
    }
}

+(BOOL)checkIdNumber:(NSString *)idNumber
{
    idNumber = [idNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![CMMUtility isStringOk:idNumber]) {
        return NO;
    }else {
        NSRange range = [idNumber rangeOfRegex:CMMRegexIdNumber];
        if (range.location != NSNotFound && range.length == idNumber.length) {
            return YES;
        }else {
            return NO;
        }
    }
//    if ([idNumber isMatchedByRegex:CMMRegexIdNumber]) {
//        return YES;
//    }else {
//        return NO;
//    }
}

+(BOOL)checkPhoneNumber:(NSString *)phone
{
    if (![CMMUtility isStringOk:phone]) {
        return NO;
    }else if ([phone isMatchedByRegex:kPhoneReg]) {
        return YES;
    }else {
        return NO;
    }
}

+(BOOL)isNumberData:(id)data {
    if ([data isKindOfClass:[NSNumber class]]) {
        return YES;
    }else {
        return NO;
    }
}

+(void)shakeView:(UIView *)view {
    CALayer *lbl = [view layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-10, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+10, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [lbl addAnimation:animation forKey:nil];
}

+(NSString *)formatterNumberWithComma:(id)number {
    NSString *numString;
    if ([number isKindOfClass:[NSNumber class]]) {
        numString = [NSString stringWithFormat:@"%lf",[number doubleValue]];
    }else{
        numString = (NSString *)number;
    }
    
    numString = [NSString stringWithFormat:@"%.2lf",[numString doubleValue]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];
    
    NSNumber *num = [NSNumber numberWithDouble:[numString doubleValue]];
    
    NSString *result = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:num]];
    return  result;
    
}

+(NSString *)formatterFourNumberWithComma:(id)number {
    NSString *numString;
    if ([number isKindOfClass:[NSNumber class]]) {
        numString = [NSString stringWithFormat:@"%lf",[number doubleValue]];
    }else{
        numString = (NSString *)number;
    }
    
    numString = [NSString stringWithFormat:@"%.4lf",[numString doubleValue]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    [formatter setMaximumFractionDigits:4];
    [formatter setMinimumFractionDigits:4];
    
    NSNumber *num = [NSNumber numberWithDouble:[numString doubleValue]];
    
    NSString *result = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:num]];
    return  result;
    
}

#pragma mark MAC地址
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
+ (NSString *) macaddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        return NULL;
    }
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

#pragma mark----openUDID

+(NSString *)openUDID
{
    NSError *error = nil;
    NSString * udid = [OpenUDID valueWithError:&error];
    if (error) {
        NSLog(@"获取openid出错%@",error);
        return @"";
    }else{
        return udid;
    }
}


#pragma mark-----系统版本号

+(NSString *)osVersion
{
    NSString *strSysVersion = [[UIDevice currentDevice] systemVersion]; // "2.2.1"
    return strSysVersion;
}
#pragma mark---idfa
+(NSString *)obtainDeviceIDFA
{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if (adId == nil) {
        adId = @"";
    }
    return adId;
}

#pragma mark---idfv
+(NSString *)obtainDeviceIDFV
{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    if (idfv) {
        return idfv;
    }else {
        return @"";
    }
}

@end
