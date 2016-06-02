//
//  QMOpenChannelAccoutViewController.h
//  MotherMoney
//
//  Created by 赵国辉 on 15/1/3.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMViewController.h"

@protocol QMOpenChannelAccoutViewControllerDelegate;
@interface QMOpenChannelAccoutViewController : QMViewController
@property (nonatomic, weak) id<QMOpenChannelAccoutViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isModel;

- (id)initViewControllerWithChannelId:(NSString *)channelId;

@end

@protocol QMOpenChannelAccoutViewControllerDelegate <NSObject>

- (void)channelAccountDidOpenSuccess:(QMOpenChannelAccoutViewController *)controller;

@end


