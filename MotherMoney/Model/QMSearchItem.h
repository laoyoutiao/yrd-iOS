//
//  QMSearchItem.h
//  MotherMoney
//


#import <Foundation/Foundation.h>

@interface QMSearchItem : NSObject
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) NSString *itemSubTitle;

@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *itemCode;

@property (nonatomic, strong) NSString *provinceId;

- (id)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle;
@end
