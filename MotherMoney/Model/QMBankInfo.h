//
//  QMBankInfo.h
//  MotherMoney

#import "QMSearchItem.h"

@interface QMBankInfo : QMSearchItem
@property (nonatomic, strong) NSString *bankCode;
@property (nonatomic, strong) NSString *bankDayLimit;
@property (nonatomic, strong) NSString *bankTimeLimit;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankPicPath;
@property (nonatomic, strong) NSString *enable;
@property (nonatomic, strong) NSString *productChannelId;
@property (nonatomic, strong) NSString *bankCardId;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
