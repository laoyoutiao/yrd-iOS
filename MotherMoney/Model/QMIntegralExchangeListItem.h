//
//  QMIntegralExchangeListItem.h
//  MotherMoney

#import <Foundation/Foundation.h>

@interface QMIntegralExchangeListItem : NSObject
@property (nonatomic, strong) NSString *prizeId;
@property (nonatomic, strong) NSString *prizeName;
@property (nonatomic, strong) NSString *prizeTime;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *acitivityId;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *prizeUniqueId;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
