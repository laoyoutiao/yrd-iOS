//
//  QMLogUtil.h
//  MotherMoney
//
//  Created by   on 14-8-4.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"

#define LN_LOG_CONTEXT 0211

#define LN_LOG_FLAG_ERROR   (1 << 0) // 0...00001
#define LN_LOG_FLAG_WARN    (1 << 1) // 0...00010
#define LN_LOG_FLAG_INFO    (1 << 2) // 0...00100
#define LN_LOG_FLAG_VERBOSE (1 << 3) // 0...01000

#define LN_LOG_LEVEL_OFF     0                                              // 0...00000
#define LN_LOG_LEVEL_ERROR   (LN_LOG_LEVEL_OFF   | LN_LOG_FLAG_ERROR)   // 0...00001
#define LN_LOG_LEVEL_WARN    (LN_LOG_LEVEL_ERROR | LN_LOG_FLAG_WARN)    // 0...00011
#define LN_LOG_LEVEL_INFO    (LN_LOG_LEVEL_WARN  | LN_LOG_FLAG_INFO)    // 0...00111
#define LN_LOG_LEVEL_VERBOSE (LN_LOG_LEVEL_INFO  | LN_LOG_FLAG_VERBOSE) // 0...01111

// 只有Distribution版本使用info级别的log，AD HOC、staging和debug版本均使用Verbose
#if DISTRIBUTION
#define LN_LOG_LEVEL_VALUE  (LN_LOG_LEVEL_INFO)
#else
#define LN_LOG_LEVEL_VALUE  (LN_LOG_LEVEL_VERBOSE)
#endif

#define LN_LOG_ASYNC_ENABLED   YES

#define LN_LOG_ASYNC_ERROR     ( NO && LN_LOG_ASYNC_ENABLED)
#define LN_LOG_ASYNC_WARN      (YES && LN_LOG_ASYNC_ENABLED)
#define LN_LOG_ASYNC_INFO      (YES && LN_LOG_ASYNC_ENABLED)
#define LN_LOG_ASYNC_VERBOSE   (YES && LN_LOG_ASYNC_ENABLED)

// Define logging primitives.
// OBJC wrapper
#define LNLogError(frmt, ...)    LOG_OBJC_MAYBE(LN_LOG_ASYNC_ERROR,   LN_LOG_LEVEL_VALUE, LN_LOG_FLAG_ERROR,  \
LN_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LNLogWarn(frmt, ...)     LOG_OBJC_MAYBE(LN_LOG_ASYNC_WARN,    LN_LOG_LEVEL_VALUE, LN_LOG_FLAG_WARN,   \
LN_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LNLogInfo(frmt, ...)     LOG_OBJC_MAYBE(LN_LOG_ASYNC_INFO,    LN_LOG_LEVEL_VALUE, LN_LOG_FLAG_INFO,    \
LN_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LNLogVerbose(frmt, ...)  LOG_OBJC_MAYBE(LN_LOG_ASYNC_VERBOSE, LN_LOG_LEVEL_VALUE, LN_LOG_FLAG_VERBOSE, \
LN_LOG_CONTEXT, frmt, ##__VA_ARGS__)

@interface QMLogUtil : NSObject

+(void)startLog;
+(void)rollLogFile;
+(NSString*)getLogDir;
+(void)purgeFiles;
+(NSString*)getLogFile;

@end
