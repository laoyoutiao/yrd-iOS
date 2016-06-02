//
//  QMStringUtil.m
//  MotherMoney
//

#import "QMStringUtil.h"

@implementation QMStringUtil

+ (NSString *)getPromptPhoneNumberWithPhoneNumber:(NSString *)phoneNumber {
    if ([CMMUtility isStringOk:phoneNumber]) {
        if (phoneNumber.length > 7) {
            NSString *accountPart1 = [phoneNumber substringToIndex:2];//186
            NSString *accountPart2 = [phoneNumber substringFromIndex:7];//0368

            return [NSString stringWithFormat:@"%@****%@",accountPart1,accountPart2];
        }
    }
    
    return nil;
}

+ (NSString *)formattedPhoneNumberFromPhoneNumber:(NSString *)phoneNumber {
    if (QM_IS_STR_NIL(phoneNumber)) {
        return nil;
    }
    
    if ([phoneNumber length] > 7) {
        return [NSString stringWithFormat:@"%@ %@ %@", [phoneNumber substringToIndex:3], [phoneNumber substringWithRange:NSMakeRange(3, 4)], [phoneNumber substringFromIndex:7]];
    }else if ([phoneNumber length] > 3) {
        return [NSString stringWithFormat:@"%@ %@", [phoneNumber substringToIndex:3], [phoneNumber substringFromIndex:3]];
    }else {
        return phoneNumber;
    }
}

+ (NSString *)formattedBankCardIdFromCardId:(NSString *)cardId; {
    if (QM_IS_STR_NIL(cardId)) {
        return nil;
    }
    
    NSInteger length = [cardId length];
    NSInteger index = 0;
    NSMutableArray *components = [NSMutableArray arrayWithCapacity:0];
    for (index = 0; index < length; index += 4) {
        NSString *subString = nil;
        if (index + 4 <= length) {
            subString = [cardId substringWithRange:NSMakeRange(index, 4)];
        }else {
            subString = [cardId substringFromIndex:index];
        }
        
        if (!QM_IS_STR_NIL(subString)) {
            [components addObject:subString];
        }
    }
    
    return [components componentsJoinedByString:@" "];
}

@end
