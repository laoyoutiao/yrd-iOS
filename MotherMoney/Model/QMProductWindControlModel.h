//
//  QMProductWindControlModel.h
//  MotherMoney
//

#import <Foundation/Foundation.h>

@interface QMProductWindControlModel : NSObject
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *productTitle;
@property (nonatomic, strong) NSString *windControlIntroduction;
@property (nonatomic, strong) NSArray *imageList;

- (id)initWithDictionary:(NSDictionary *)dict;

@end

