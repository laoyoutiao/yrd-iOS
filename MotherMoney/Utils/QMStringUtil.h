//
//  QMStringUtil.h
//  MotherMoney

#import <Foundation/Foundation.h>

@interface QMStringUtil : NSObject

+ (NSString *)getPromptPhoneNumberWithPhoneNumber:(NSString *)phoneNumber;

+ (NSString *)formattedPhoneNumberFromPhoneNumber:(NSString *)phoneNumber;

+ (NSString *)formattedBankCardIdFromCardId:(NSString *)cardId;

@end

