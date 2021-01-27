//
//  QMBusinessCell.m
//  MotherMoney
//
//  Created by cgt cgt on 2017/8/9.
//  Copyright © 2017年 cgt cgt. All rights reserved.
//

#import "QMBusinessCell.h"

@implementation QMBusinessCell
{
    UILabel *peopleNumberLbl;
    UILabel *annualRateLbl;
    UILabel *commissionLbl;
    UILabel *timeLbl;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        peopleNumberLbl = [self setupLbl:CGRectZero];
        annualRateLbl = [self setupLbl:CGRectZero];
        commissionLbl = [self setupLbl:CGRectZero];
        timeLbl = [self setupLbl:CGRectZero];
        [self addSubview:peopleNumberLbl];
        [self addSubview:annualRateLbl];
        [self addSubview:commissionLbl];
        [self addSubview:timeLbl];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)setupLbl:(CGRect)rect
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    return label;
}

- (void)setupBusinessText:(NSString *)text
{
    UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width, 40)];
    textLbl.text = text;
    textLbl.font = [UIFont systemFontOfSize:14];
    textLbl.textColor = [UIColor blackColor];
    [self addSubview:textLbl];
}

- (void)setupFrame:(CGRect)rect
{
    [peopleNumberLbl setFrame:CGRectMake(rect.size.width / 4 * 1, 0, rect.size.width / 8, 40)];
    [annualRateLbl setFrame:CGRectMake(rect.size.width / 4 * 1.5, 0, rect.size.width / 4 * 1.5, 40)];
    [commissionLbl setFrame:CGRectMake(rect.size.width / 4 * 3, 0, rect.size.width / 4, 40)];
    [timeLbl setFrame:CGRectMake(0, 0, rect.size.width / 4, 40)];
}

- (void)configureCellWithItemInfo:(QMBusinessInfoModel *)info
{
    peopleNumberLbl.text = info.accountnumber;
    annualRateLbl.text = info.annualrat;
    commissionLbl.text = info.commission;
    timeLbl.text = info.time;
}

@end
