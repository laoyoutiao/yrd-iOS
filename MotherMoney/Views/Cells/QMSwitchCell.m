//
//  QMSwitchCell.m
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import "QMSwitchCell.h"

@implementation QMSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 90, (CGRectGetHeight(self.frame) - 20) / 2, 60, 20)];
        CGRect frame = self.switchBtn.frame;
        frame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(self.switchBtn.frame)) / 2.0f;
        
        self.switchBtn.frame = frame;
        
        [self.contentView addSubview:self.switchBtn];
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
