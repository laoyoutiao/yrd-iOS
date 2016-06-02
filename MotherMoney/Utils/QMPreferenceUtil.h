//
//  QMPreferenceUtil.h
//  MotherMoney
//

//

#import <Foundation/Foundation.h>
//配置
@interface QMPreferenceUtil : NSObject

//Global
+ (void)setGlobalKey:(NSString *)key
               value:(NSString*)value
           syncWrite:(BOOL)syncWrite;
+ (NSString *)getGlobalKey:(NSString *)key;

+ (void)setGlobalBoolKey:(NSString *)key
                   value:(BOOL)value
               syncWrite:(BOOL)syncWrite;
+ (BOOL)getGlobalBoolKey:(NSString *)key;

+ (void)setGlobalIntegerKey:(NSString *)key
                      value:(NSInteger)value
                  syncWrite:(BOOL)syncWrite;
+ (NSInteger)getGlobalIntegerKey:(NSString *)key;

+ (void)setGlobalDoubleKey:(NSString *)key
                     value:(double)value
                 syncWrite:(BOOL)syncWrite;
+ (double)getGlobalDoubleKey:(NSString *)key;

+ (void)setGlobalDictKey:(NSString*)key
                   value:(NSDictionary*)value
               syncWrite:(BOOL)syncWrite;
+ (NSDictionary*)getGlobalDictKey:(NSString *)key;

+ (void)setGlobalArrayKey:(NSString*)key
                    value:(NSArray*)value
                syncWrite:(BOOL)syncWrite;
+ (NSArray*)getGlobalArrayKey:(NSString*)key;

+ (void)removeGlobalKey:(NSString*)key
              syncWrite:(BOOL)syncWrite;

//User-Related
+ (void)setKey:(NSString *)key
         value:(NSString*)value
        userId:(NSString *)userId
     syncWrite:(BOOL)syncWrite;
+ (NSString*)getKey:(NSString *)key
             userId:(NSString *)userId;
+ (void)removeUserKey:(NSString *)key
               userId:(NSString *)userId
            syncWrite:(BOOL)syncWrite;

+ (void)setBoolKey:(NSString *)key
             value:(BOOL)value
            userId:(NSString *)userId
         syncWrite:(BOOL)syncWrite;
+ (BOOL)getBoolKey:(NSString *)key
            userId:(NSString *)userId;

+ (void)setDoubleKey:(NSString *)key
               value:(double)value
              userId:(NSString *)userId
           syncWrite:(BOOL)syncWrite;
+ (double)getDoubleKey:(NSString *)key
                userId:(NSString *)userId;

+ (void)setIntegerKey:(NSString *)key
                value:(NSInteger)value
               userId:(NSString *)userId
            syncWrite:(BOOL)syncWrite;
+ (NSInteger)getIntegerKey:(NSString *)key
                    userId:(NSString *)userId;

+ (void)setLongLongKey:(NSString *)key
                 value:(long long)value
                userId:(NSString *)userId
             syncWrite:(BOOL)syncWrite;
+ (long long)getLongLongKey:(NSString *)key
                     userId:(NSString *)userId;

+ (void)setArrayKey:(NSString*)key
              value:(NSArray*)value
             userId:(NSString *)userId
          syncWrite:(BOOL)syncWrite;
+ (NSArray*)getArrayKey:(NSString*)key
                 userId:(NSString *)userId;

+ (void)setDictKey:(NSString*)key
             value:(NSDictionary*)value
            userId:(NSString *)userId
         syncWrite:(BOOL)syncWrite;
+ (NSDictionary*)getDictKey:(NSString *)key
                     userId:(NSString *)userId;

@end
