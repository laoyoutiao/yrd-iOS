//
//  QMProductIntroductionModel.h
//  MotherMoney
//

#import <Foundation/Foundation.h>

// 项目介绍
@interface QMProductIntroductionModel : NSObject
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *productDescription;
@property (nonatomic, strong) NSString *productDesciptionTitle;
@property (nonatomic, strong) NSString *mortgageDesc;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *introlTitle;

// intro


// detail intro
//@property (nonatomic, strong) NSString *detailIntroTitle;
//@property (nonatomic, strong) NSString *detailIntro;

@property (nonatomic, strong) NSArray *imageList;


- (id)initWithDictionary:(NSDictionary *)dict;


@end


