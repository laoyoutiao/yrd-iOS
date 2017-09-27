//
//  QMBankInfo.m
//  MotherMoney
#import "QMBankInfo.h"

@implementation QMBankInfo

+(NSDictionary *)getBankInfoWithGuiZhou
{
    NSDictionary *bankInfoDict = @{ @"农行": @"ABC",
                                    @"工商银行": @"ICBC",
                                    @"中国银行": @"BOC",
                                    @"招行": @"CMB",
                                    @"建设银行": @"CCB",
                                    @"兴业银行": @"CIB",
                                    @"华夏银行": @"HXB",
                                    @"中信银行": @"CITIC",
                                    @"民生银行": @"CMBC",
                                    @"邮储银行": @"PSBC",
                                    @"光大银行": @"CEB",
                                    @"广发银行": @"GDB",
                                    @"杭州银行": @"HZCB",
                                    @"深发银行": @"SDB",
                                    @"平安银行": @"PINGAN",
                                    @"渤海银行": @"CBHB",
                                    @"南京银行": @"NJCB",
                                    @"上海农村商业银行": @"SRCB",
                                    @"交通银行": @"BOCOM",
                                    @"浙商银行": @"CZB",
                                    @"上海银行": @"BOS",
                                    @"浦发": @"SPDB",
                                    @"东亚银行": @"HKBEA",
                                    @"北京银行": @"BCCB",
                                    @"北京农村商业银行": @"BJRCB"};
    return bankInfoDict;
}


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
