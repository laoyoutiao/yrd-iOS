//
//  QMProductImageItemModel.h
//  MotherMoney
//

#import <Foundation/Foundation.h>

@interface QMProductImageItemModel : NSObject
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) UIImage *image;

- (id)initWithDictionary:(NSDictionary *)dict;

@end

