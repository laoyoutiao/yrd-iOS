//
//  QMPreferenceUtil.m
//  MotherMoney
//

//

#import "QMPreferenceUtil.h"

@implementation QMPreferenceUtil

/*
 * Global表示所有用户都只共享该键值
 * User-Related表示与用户相关的键值
 */

// Global
+ (void)setGlobalKey:(NSString *)key
               value:(NSString*)value
           syncWrite:(BOOL)syncWrite
{
	if (QM_IS_STR_NIL(key)) {
		return;
	}
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setObject:value forKey:key];
    
    if (syncWrite)
    {
        [userDefault synchronize];
    }
}

+ (NSString*)getGlobalKey:(NSString *)key
{
	if (QM_IS_STR_NIL(key)) {
		return nil;
	}
	
	NSString *ret = [[NSUserDefaults standardUserDefaults] stringForKey:key];
	return ret;
}

+ (void)setGlobalDictKey:(NSString*)key
                   value:(NSDictionary*)value
               syncWrite:(BOOL)syncWrite
{
	if (QM_IS_STR_NIL(key)) {
		return;
	}
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setObject:value forKey:key];
    
    if (syncWrite)
    {
        [userDefault synchronize];
    }
}

+ (NSDictionary*)getGlobalDictKey:(NSString *)key
{
	if (QM_IS_STR_NIL(key)) {
		return nil;
	}
	
	NSDictionary *ret = [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
	return ret;
}

+ (void)setGlobalBoolKey:(NSString *)key
                   value:(BOOL)value
               syncWrite:(BOOL)syncWrite
{
	if (QM_IS_STR_NIL(key)) {
		return;
	}
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setBool:value forKey:key];
    
    if (syncWrite)
    {
        [userDefault synchronize];
    }
}

+ (BOOL)getGlobalBoolKey:(NSString *)key
{
	if (QM_IS_STR_NIL(key)) {
		return NO;
	}
	
	BOOL ret = [[NSUserDefaults standardUserDefaults] boolForKey:key];
	return ret;
}

+ (void)setGlobalIntegerKey:(NSString *)key
                      value:(NSInteger)value
                  syncWrite:(BOOL)syncWrite
{
	if (QM_IS_STR_NIL(key)) {
		return;
	}
	
	[[NSUserDefaults standardUserDefaults] setInteger:value forKey:key] ;
    if (syncWrite)
    {
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSInteger)getGlobalIntegerKey:(NSString *)key
{
	if (QM_IS_STR_NIL(key)) {
		return 0;
	}
	
	NSInteger ret = [[NSUserDefaults standardUserDefaults] integerForKey:key];
	return ret;
}

+ (void)setGlobalDoubleKey:(NSString *)key
                     value:(double)value
                 syncWrite:(BOOL)syncWrite
{
	NSString *dKey = key;
	if (QM_IS_STR_NIL(dKey)) {
		return;
	}
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setDouble:value forKey:dKey];
    
    if (syncWrite)
    {
        [userDefault synchronize];
    }
}

+ (double)getGlobalDoubleKey:(NSString *)key
{
	if (QM_IS_STR_NIL(key)) {
		return 0;
	}
	
	double ret = [[NSUserDefaults standardUserDefaults] doubleForKey:key];
	return ret;
}

+ (void)setGlobalArrayKey:(NSString*)key
                    value:(NSArray*)value
                syncWrite:(BOOL)syncWrite
{
	if (QM_IS_STR_NIL(key)) {
		return;
	}
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setObject:value forKey:key];
    
    if (syncWrite)
    {
        [userDefault synchronize];
    }
}

+ (NSArray*)getGlobalArrayKey:(NSString*)key
{
	if (QM_IS_STR_NIL(key)) {
		return nil;
	}
	
	NSArray *ret = [[NSUserDefaults standardUserDefaults] arrayForKey:key];
	return ret;
}

+ (void)removeGlobalKey:(NSString*)key
              syncWrite:(BOOL)syncWrite
{
    if (QM_IS_STR_NIL(key)) {
        return;
    }
    
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:key];
    
    if (syncWrite)
    {
        [userDefault synchronize];
    }
}

// User-Related
+ (void)setKey:(NSString *)key
         value:(NSString*)value
        userId:(NSString *)userId
     syncWrite:(BOOL)syncWrite
{
	if (QM_IS_STR_NIL(userId) || QM_IS_STR_NIL(key)) {
		return;
	}
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *existDict = [userDefault dictionaryForKey:key];
	if (QM_IS_DICT_NIL(existDict)) {
		NSMutableDictionary *initDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        if (value != nil) {
            [initDict setObject:value forKey:userId];
        }
		[userDefault setObject:initDict forKey:key];
	} else {
		NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithDictionary:existDict];
		if (value == nil) {
			[tmpDict removeObjectForKey:userId];
		} else {
			[tmpDict setObject:value forKey:userId];
		}
		[userDefault setObject:tmpDict forKey:key];
	}
    
    if (syncWrite)
    {
		[userDefault synchronize];
    }
}

+ (NSString*)getKey:(NSString *)key
             userId:(NSString *)userId
{
	if (QM_IS_STR_NIL(userId) || QM_IS_STR_NIL(key)) {
		return nil;
	}
	
	NSDictionary *existDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
	if (QM_IS_DICT_NIL(existDict)) {
		return nil;
	}
	
	NSString *ret = [existDict objectForKey:userId];
	
	return ret;
}

+ (void)setBoolKey:(NSString *)key
             value:(BOOL)value
            userId:(NSString *)userId
         syncWrite:(BOOL)syncWrite
{
	if (QM_IS_STR_NIL(userId) || QM_IS_STR_NIL(key)) {
		return;
	}
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *existDict = [userDefault dictionaryForKey:key];
	
	if (QM_IS_DICT_NIL(existDict)) {
		NSDictionary *initDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:value], userId, nil];
		[userDefault setObject:initDict forKey:key];
	} else {
		NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithCapacity:0];
		[tmpDict addEntriesFromDictionary:existDict];
		[tmpDict setObject:[NSNumber numberWithBool:value] forKey:userId];
		[userDefault setObject:tmpDict forKey:key];
	}
    
    if (syncWrite)
    {
		[userDefault synchronize];
    }
}

+ (BOOL)getBoolKey:(NSString *)key
            userId:(NSString *)userId
{
	if (QM_IS_STR_NIL(userId) || QM_IS_STR_NIL(key)) {
		return NO;
	}
	
	NSDictionary *existDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
    
	if (QM_IS_DICT_NIL(existDict)) {
		return NO;
	}
	
	BOOL ret = [[existDict objectForKey:userId] boolValue];
	
	return ret;
}

+ (void)setDoubleKey:(NSString *)key
               value:(double)value
              userId:(NSString *)userId
           syncWrite:(BOOL)syncWrite
{
	if (QM_IS_STR_NIL(userId) || QM_IS_STR_NIL(key)) {
		return;
	}
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *existDict = [userDefault dictionaryForKey:key];
	
	if (QM_IS_DICT_NIL(existDict)) {
		NSDictionary *initDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithDouble:value], userId, nil];
		[userDefault setObject:initDict forKey:key];
	} else {
		NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithCapacity:0];
		[tmpDict addEntriesFromDictionary:existDict];
		[tmpDict setObject:[NSNumber numberWithDouble:value] forKey:userId];
		[userDefault setObject:tmpDict forKey:key];
	}
    
    if (syncWrite)
    {
		[userDefault synchronize];
    }
}

+ (double)getDoubleKey:(NSString *)key
                userId:(NSString *)userId
{
	if (QM_IS_STR_NIL(userId) || QM_IS_STR_NIL(key)) {
		return 0;
	}
	
	NSDictionary *existDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
	
	if (QM_IS_DICT_NIL(existDict)) {
		return 0;
	}
	
	NSInteger ret = [[existDict objectForKey:userId] doubleValue];
	
	return ret;
}

+ (void)setIntegerKey:(NSString *)key
                value:(NSInteger)value
               userId:(NSString *)userId
            syncWrite:(BOOL)syncWrite
{
	if (QM_IS_STR_NIL(userId) || QM_IS_STR_NIL(key)) {
		return;
	}
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *existDict = [userDefault dictionaryForKey:key];
	
	if (QM_IS_DICT_NIL(existDict)) {
		NSDictionary *initDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:value], userId, nil];
		[userDefault setObject:initDict forKey:key];
	} else {
		NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithCapacity:0];
		[tmpDict addEntriesFromDictionary:existDict];
		[tmpDict setObject:[NSNumber numberWithInteger:value] forKey:userId];
		[userDefault setObject:tmpDict forKey:key];
	}
    
    if (syncWrite)
    {
		[userDefault synchronize];
    }
}

+ (NSInteger)getIntegerKey:(NSString *)key
                    userId:(NSString *)userId
{
	if (QM_IS_STR_NIL(userId) || QM_IS_STR_NIL(key)) {
		return 0;
	}
	
	NSDictionary *existDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
	
	if (QM_IS_DICT_NIL(existDict)) {
		return 0;
	}
	
	NSInteger ret = [[existDict objectForKey:userId] intValue];
	
	return ret;
}

+ (void)setLongLongKey:(NSString *)key
                 value:(long long)value
                userId:(NSString *)userId
             syncWrite:(BOOL)syncWrite
{
	if (QM_IS_STR_NIL(userId) || QM_IS_STR_NIL(key)) {
		return;
	}
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *existDict = [userDefault dictionaryForKey:key];
	
	if (QM_IS_DICT_NIL(existDict)) {
		NSDictionary *initDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithLongLong:value], userId, nil];
		[userDefault setObject:initDict forKey:key];
	} else {
		NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithCapacity:0];
		[tmpDict addEntriesFromDictionary:existDict];
		[tmpDict setObject:[NSNumber numberWithLongLong:value] forKey:userId];
		[userDefault setObject:tmpDict forKey:key];
	}
    
    if (syncWrite)
    {
		[userDefault synchronize];
    }
}

+ (long long)getLongLongKey:(NSString *)key
                     userId:(NSString *)userId
{
	if (QM_IS_STR_NIL(userId) || QM_IS_STR_NIL(key)) {
		return 0;
	}
	
	NSDictionary *existDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
	
	if (QM_IS_DICT_NIL(existDict)) {
		return 0;
	}
	
	long long ret = [[existDict objectForKey:userId] longLongValue];
	
	return ret;
}

+ (void)setArrayKey:(NSString*)key
              value:(NSArray*)value
             userId:(NSString *)userId
          syncWrite:(BOOL)syncWrite
{
	if (QM_IS_STR_NIL(userId) || QM_IS_STR_NIL(key)) {
		return;
	}
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *existDict = [userDefault dictionaryForKey:key];
	
	if (QM_IS_DICT_NIL(existDict)) {
		NSDictionary *initDict = [[NSDictionary alloc] initWithObjectsAndKeys:value, userId, nil];
		[userDefault setObject:initDict forKey:key];
	} else {
		NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithCapacity:0];
		[tmpDict addEntriesFromDictionary:existDict];
		[tmpDict setObject:value forKey:userId];
		[userDefault setObject:tmpDict forKey:key];
	}
    
    if (syncWrite)
    {
		[userDefault synchronize];
    }
}


+ (NSArray*)getArrayKey:(NSString*)key
                 userId:(NSString *)userId
{
	if (QM_IS_STR_NIL(userId) || QM_IS_STR_NIL(key)) {
		return nil;
	}
	
	NSDictionary *existDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
	
	if (QM_IS_DICT_NIL(existDict)) {
		return nil;
	}
	
	NSArray *ret = [existDict objectForKey:userId];
	
	return ret;
}

+ (void) removeUserKey:(NSString *)key
                userId:(NSString *)userId
             syncWrite:(BOOL)syncWrite
{
    if (QM_IS_STR_NIL(userId) || QM_IS_STR_NIL(key)) {
		return;
	}
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *existDict = [userDefault dictionaryForKey:key];
	
	if (!QM_IS_DICT_NIL(existDict)) {
		NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithCapacity:0];
		[tmpDict addEntriesFromDictionary:existDict];
		[tmpDict removeObjectForKey:userId];
        if (QM_IS_DICT_NIL(tmpDict)) {
            [userDefault removeObjectForKey:key];
        }
        else{
            [userDefault setObject:tmpDict forKey:key];
        }
        if (syncWrite)
        {
            [userDefault synchronize];
        }
	}
}

+ (void)setDictKey:(NSString*)key
             value:(NSDictionary*)value
            userId:(NSString *)userId
         syncWrite:(BOOL)syncWrite
{
	if (QM_IS_STR_NIL(userId) || QM_IS_STR_NIL(key)) {
		return;
	}
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *existDict = [userDefault dictionaryForKey:key];
	
    if (QM_IS_DICT_NIL(existDict)) {
		NSDictionary *initDict = [[NSDictionary alloc] initWithObjectsAndKeys:value, userId, nil];
		[userDefault setObject:initDict forKey:key];
	} else {
		NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithCapacity:0];
		[tmpDict addEntriesFromDictionary:existDict];
		[tmpDict setObject:value forKey:userId];
		[userDefault setObject:tmpDict forKey:key];
	}
    
    if (syncWrite)
    {
		[userDefault synchronize];
    }
}

+ (NSDictionary*)getDictKey:(NSString *)key
                     userId:(NSString *)userId
{
	if (QM_IS_STR_NIL(userId) || QM_IS_STR_NIL(key)) {
		return nil;
	}
	
    NSDictionary *existDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
	
	if (QM_IS_DICT_NIL(existDict)) {
		return nil;
	}
    
	NSDictionary *ret = [existDict objectForKey:userId];
	return ret;
}

@end
