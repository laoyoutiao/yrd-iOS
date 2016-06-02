//
//  QMBankBranchInfoCell.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/14.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMBankBranchInfoCell.h"

@implementation QMBankBranchInfoCell {
    UILabel *textLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.font = [UIFont systemFontOfSize:14.0f];
        textLabel.textColor = [UIColor blackColor];
        textLabel.numberOfLines = 0;
        [self.contentView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10.0f);
            make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithBranchInfo:(QMBankBranchInfo *)info {
    textLabel.text = info.branchName;
}

+ (CGFloat)getCellHeightWithBranchInfo:(QMBankBranchInfo *)info {
    NSString *branchName = info.branchName;
    if (!QM_IS_STR_NIL(branchName)) {
        CGRect windowFrame = [UIScreen mainScreen].bounds;
        CGSize size = [branchName boundingRectWithSize:CGSizeMake(CGRectGetWidth(windowFrame) - 2 * 10, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, nil] context:nil].size;
        return size.height + 10 * 2;
    }
    
    return 0;
}

@end
