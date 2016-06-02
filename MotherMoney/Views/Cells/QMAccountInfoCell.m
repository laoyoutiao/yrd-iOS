//
//  QMAccountInfoCell.m
//  MotherMoney
//
//  Created by   on 14-8-9.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMAccountInfoCell.h"

@implementation QMAccountInfoCell {
    UIImageView *iconImageView;
    UILabel *accountNameLabel;
    UILabel *phoneNumberLabel;
}
@synthesize iconImageView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // icon，头像
        iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_person_take_image.png"]];
        iconImageView.frame = CGRectMake(10, (CGRectGetHeight(self.frame) - CGRectGetHeight(iconImageView.frame)) / 2.0f, iconImageView.frame.size.width, iconImageView.frame.size.height);
        iconImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:iconImageView];
        
        // name information
        accountNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 10, 0, 100, CGRectGetHeight(self.frame))];
        accountNameLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:accountNameLabel];
        
        // indicator
        self.indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shearhead_2.png"]];
        self.indicatorView.frame = CGRectMake(CGRectGetWidth(frame) - 15 - 10, (CGRectGetHeight(frame) - 15.0f) / 2.0f, 15, 15);
        [self.contentView addSubview:self.indicatorView];
        
        // phone number
        phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.indicatorView.frame) - 130, 0, 130, CGRectGetHeight(self.frame))];
        phoneNumberLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:phoneNumberLabel];
    }
    
    return self;
}

+ (CGFloat)getCellHeightWithAccountInfo:(QMAccountInfo *)accountInfo {
    return 50.0f;
}

- (void)configureCellWithAccountInfo:(QMAccountInfo *)accountInfo {
    if (!QM_IS_STR_NIL(accountInfo.userName)) {
        accountNameLabel.text = accountInfo.userName;
    }else {
        accountNameLabel.text = QMLocalizedString(@"qm_not_authorized_user", @"未认证用户");
    }
    
    if (!QM_IS_STR_NIL(accountInfo.phoneNumber)) {
        phoneNumberLabel.text = accountInfo.phoneNumber;
    }else {
        phoneNumberLabel.text = @"";
    }
}

@end
