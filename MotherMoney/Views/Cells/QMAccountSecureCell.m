//
//  QMAccountSecureCell.m
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import "QMAccountSecureCell.h"

@implementation QMAccountSecureCell {
    UIImageView *verticalLine;
    UIImageView *horizonLine;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (CGRectGetHeight(self.frame) - 33) / 2.0f, 37, 33)];
        self.iconImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:self.iconImageView];
        
        // vertical line
        verticalLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tradelogLine.png"]];
        CGRect frame = verticalLine.frame;
        frame.origin.y = 0;
        frame.origin.x = 55;
        frame.size.height = CGRectGetHeight(self.frame);
        verticalLine.frame = frame;
        verticalLine.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:verticalLine];
        
        // horizon line
        horizonLine = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(verticalLine.frame), CGRectGetHeight(self.frame) / 2.0f, CGRectGetWidth(self.frame) - CGRectGetMidX(verticalLine.frame), 1)];
        horizonLine.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f];
        horizonLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:horizonLine];
        
        
        self.modifyLoginPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.modifyLoginPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.modifyLoginPwdBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 235, 0, 0);
        [self.modifyLoginPwdBtn setImage:[UIImage imageNamed:@"arrow_right.png"] forState:UIControlStateNormal];
        self.modifyLoginPwdBtn.frame = CGRectMake(60, 0, CGRectGetWidth(self.frame) - 60, CGRectGetHeight(self.frame) / 2.0f);
        self.modifyLoginPwdBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        self.modifyLoginPwdBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.modifyLoginPwdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.modifyLoginPwdBtn];
        
        self.modifyTradePwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.modifyTradePwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.modifyTradePwdBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 235, 0, 0);
        [self.modifyTradePwdBtn setImage:[UIImage imageNamed:@"arrow_right.png"] forState:UIControlStateNormal];
        self.modifyTradePwdBtn.frame = CGRectMake(60, CGRectGetMaxY(self.modifyLoginPwdBtn.frame), CGRectGetWidth(self.modifyLoginPwdBtn.frame), CGRectGetHeight(self.modifyLoginPwdBtn.frame));
        self.modifyTradePwdBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;;
        self.modifyTradePwdBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.modifyTradePwdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [self.contentView addSubview:self.modifyTradePwdBtn];
    }
    
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
