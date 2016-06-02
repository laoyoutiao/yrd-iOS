//
//  QMOrderModel.h
//  MotherMoney

#import <Foundation/Foundation.h>

@interface QMOrderModel : NSObject
@property (nonatomic, strong) NSString *productId; // 产品Id
@property (nonatomic, strong) NSString *productChannelId;
@property (nonatomic, strong) NSString *amount; // 购买金额
@property (nonatomic, strong) NSString *bankCardNumber; // 银行卡号
@property (nonatomic, strong) NSString *bankCode; // 银行代码
@property (nonatomic, strong) NSString *bankProvince; // 开户省份
@property (nonatomic, strong) NSString *bankCity; // 开户城市
@property (nonatomic, strong) NSString *productName; // 产品名称

@end
