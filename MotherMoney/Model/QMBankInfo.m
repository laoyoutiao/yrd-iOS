//
//  QMBankInfo.m
//  MotherMoney
#import "QMBankInfo.h"

@implementation QMBankInfo

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        NSString *bankCode = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankCode"]];
        if ([CMMUtility isStringOk:bankCode]) {
            self.bankCode = bankCode;
        }
        
        NSString *bankDayLimit = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankDayLimit"]];
        if ([CMMUtility isStringOk:bankDayLimit]) {
            self.bankDayLimit = bankDayLimit;
        }
        
        NSString *bankTimeLimit = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankTimeLimit"]];
        if ([CMMUtility isStringOk:bankTimeLimit]) {
            self.bankTimeLimit = bankTimeLimit;
        }
        
        NSString *bankName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankName"]];
        if ([CMMUtility isStringOk:bankName]) {
            self.bankName = bankName;
        }
        
        NSString *bankPicPath = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankPicPath"]];
        if ([CMMUtility isStringOk:bankPicPath]) {
            self.bankPicPath = bankPicPath;
        }
        
        NSString *enable = [NSString stringWithFormat:@"%@", [dict objectForKey:@"enable"]];
        if ([CMMUtility isStringOk:enable]) {
            self.enable = enable;
        }
        
        NSString *productChannelId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"productChannelId"]];
        if ([CMMUtility isStringOk:productChannelId]) {
            self.productChannelId = productChannelId;
        }
        
        NSString *bankCardId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        if ([CMMUtility isStringOk:bankCardId]) {
            self.bankCardId = bankCardId;
        }
        
        self.itemTitle = self.bankName;
        self.itemSubTitle = @"";
    }
    
    return self;
}

@end
