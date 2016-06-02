//
//  QMPersonalCenterItemInfoCell.m
//  MotherMoney
//
//  Created by   on 14-8-15.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMPersonalCenterItemInfoCell.h"

@implementation QMPersonalCenterItemInfoCell {
    UIImageView *iconImageView;
    UILabel *itemNameLabel;
    UILabel *itemSubNameLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *superView = self;
        
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(20.0f);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.equalTo(CGSizeMake(30, 30));
        }];
        
        itemNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        itemNameLabel.font = [UIFont systemFontOfSize:13];
        itemNameLabel.textColor = QM_COMMON_TEXT_COLOR;
        itemNameLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        itemNameLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:itemNameLabel];
        [itemNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(10);
            make.top.equalTo(self.contentView.mas_top);
            make.width.equalTo(200);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        itemSubNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 20 - 110, 0, 85, CGRectGetHeight(self.frame))];
        itemSubNameLabel.textAlignment = NSTextAlignmentRight;
        itemSubNameLabel.font = [UIFont systemFontOfSize:12];
        itemSubNameLabel.textColor = QM_COMMON_TEXT_COLOR;
        itemSubNameLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        itemSubNameLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:itemSubNameLabel];
        [itemSubNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-28);
            make.width.equalTo(120.0f);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        self.horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        [self.contentView addSubview:self.horizontalLine];
        [self.horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.mas_left).offset(15);
            make.right.equalTo(superView.mas_right).offset(-15.0f);
            make.bottom.equalTo(superView.mas_bottom);
            make.height.equalTo(1.0f);
        }];
    }
    return self;
}

- (void)configureCellWithItemInfo:(QMPersonalCenterItemInfo *)info {
    UIImage *image = nil;
    if (!QM_IS_STR_NIL(info.iconImageName)) {
        image = [UIImage imageNamed:info.iconImageName];
    }
    iconImageView.image = image;
    
    CGFloat scale = 1;
    if (scale == 0) {
        scale = 1;
    }
    if (nil != image) {
        [itemNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(10);
            make.top.equalTo(self.contentView.mas_top);
            make.width.equalTo(200);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }else {
        [itemNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.top.equalTo(self.contentView.mas_top);
            make.width.equalTo(200);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
    }
    
    if (!QM_IS_STR_NIL(info.itemName)) {
        itemNameLabel.text = info.itemName;
    }else {
        itemNameLabel.text = @"";
    }
    
    if (!QM_IS_STR_NIL(info.itemSubName)) {
        itemSubNameLabel.text = info.itemSubName;
    }else {
        itemSubNameLabel.text = @"";
    }
    
    CGRect frame = itemNameLabel.frame;
    if (iconImageView.image == nil) {
        frame.origin.x = 20;
    }else {
        frame.origin.x = CGRectGetMaxX(iconImageView.frame) + 10;
    }
    
    itemNameLabel.frame = frame;
}

@end
