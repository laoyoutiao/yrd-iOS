//
//  QMGoodsListItem.h
//  MotherMoney
//

#import <Foundation/Foundation.h>

@interface QMGoodsListItem : NSObject
@property (nonatomic, strong) NSString *prizeId;
@property (nonatomic, strong) NSString *prizeName;
@property (nonatomic, strong) NSString *prizeAmount;
@property (nonatomic, strong) NSString *prizeDesc;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *fixedNumber;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *totalWinnerNum;
@property (nonatomic, strong) NSString *leaveNum;
@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, strong) NSString *exchange;
@property (nonatomic, strong) NSString *needScore;
@property (nonatomic, strong) NSString *status;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
