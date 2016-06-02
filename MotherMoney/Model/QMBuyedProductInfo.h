//
//  QMBuyedProductInfo.h
//  MotherMoney

#import <Foundation/Foundation.h>
#import "QMBankCardModel.h"

@interface QMBuyedProductInfo : NSObject
@property (nonatomic, strong) NSString *buyedId;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *todayTotalEarnings;
@property (nonatomic, strong) NSString *totalBuyAmount;
@property (nonatomic, strong) NSString *totalEarnings;

@property (nonatomic, strong) QMBankCardModel *bandInfo;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
