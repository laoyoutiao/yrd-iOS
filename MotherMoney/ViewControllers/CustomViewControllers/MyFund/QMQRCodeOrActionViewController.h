//
//  QMQRCodeOrActionViewController.h
//  MotherMoney
//
//  Created by cgt cgt on 2017/8/9.
//  Copyright © 2017年 cgt cgt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMQRCodeOrActionViewController : QMViewController

@property (assign, nonatomic) BOOL isQRCode;
@property (nonatomic, strong) NSString *channelID;
@end