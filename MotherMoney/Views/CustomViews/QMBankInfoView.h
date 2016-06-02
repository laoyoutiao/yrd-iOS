//
//  QMBankInfoView.h
//  MotherMoney
//
//  Created by on 14-8-9.
//  Copyright (c) 2014年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBankCardModel.h"

@interface QMBankInfoView : UIView

- (void)configureWithBankCardInfo:(QMBankCardModel *)bankInfo;

@end
