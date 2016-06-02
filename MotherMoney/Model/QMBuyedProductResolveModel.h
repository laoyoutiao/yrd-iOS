//
//  QMBuyedProductResolveModel.h
//  MotherMoney
//

#import <Foundation/Foundation.h>

@interface QMBuyedProductResolveModel : NSObject
@property (nonatomic, strong) NSString *bankCardNumer;
@property (nonatomic, strong) NSString *bankIco;
@property (nonatomic, strong) NSString *buyTime;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *statusValue;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *todayTotalEarnings;
@property (nonatomic, strong) NSString *totalBuyAmount;
@property (nonatomic, strong) NSString *totalEarnings;
@property (nonatomic, strong) NSString *resolveModelId;
@property (nonatomic, strong) NSString *errorMsg;
@property (nonatomic, assign) BOOL isSuccess;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
