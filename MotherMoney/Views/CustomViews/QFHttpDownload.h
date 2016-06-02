//
//  QFHttpDownload.h
//  JSON
//
//  Created by xiang_jj on 14-3-25.
//  Copyright (c) 2014年 xiang_jj. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QFHttpDownload;

@protocol QFHttpDownloadDelegate <NSObject>

-(void)downloadSuccess:(QFHttpDownload *)httpdownload;

@end

@interface QFHttpDownload : NSObject<NSURLConnectionDataDelegate>

@property(nonatomic,assign)id<QFHttpDownloadDelegate> delegate;
@property(nonatomic,retain)NSMutableData *downloadData;

- (id)initWithUrl:(NSString *)string;

@end
