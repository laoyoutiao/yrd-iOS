//
//  QMLogUtil.m
//  MotherMoney
//
//  Created by   on 14-8-4.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMLogUtil.h"
#include <unistd.h>
#import "DDTTYLogger.h"
#import "DDFileLogger.h"

static NSString* logDir = nil;
static NSString* logFile = nil;
static DDFileLogger* fileLogger = nil;

@implementation QMLogUtil

+(void)startLog{
    [DDLog removeAllLoggers];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    fileLogger = [[DDFileLogger alloc] init];
    fileLogger.maximumFileSize = 1024 * 1024;
    // 内部版本保存10M大小的log
#if DISTRIBUTION
    fileLogger.logFileManager.maximumNumberOfLogFiles = 4;
#else
    fileLogger.logFileManager.maximumNumberOfLogFiles = 10;
#endif
    logDir = [fileLogger.logFileManager logsDirectory];
    [DDLog addLogger:fileLogger];
}

+(void)rollLogFile
{
    [fileLogger rollLogFileWithCompletionBlock:^{
        
    }];
}

+(NSString*)getLogDir{
    return logDir;
}

+(NSString*)getLogFile{
    if (logFile == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *logFileName = [documentsDirectory stringByAppendingPathComponent:@"log.zip"];
        logFile = [logFileName copy];
    }
    return logFile;
}

+(void)purgeFiles{
    [[NSFileManager defaultManager] removeItemAtPath:[self getLogFile] error:nil];
}

@end
