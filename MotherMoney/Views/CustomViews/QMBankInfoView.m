//
//  QMBankInfoView.m
//  MotherMoney
//
//  Created by on 14-8-9.
//  Copyright (c) 2014年. All rights reserved.
//

#import "QMBankInfoView.h"
#import "UIImageView+WebCache.h"

#define BANK_ICON_SIZE 10

@implementation QMBankInfoView {
    UIImageView *iconImageView;
    UILabel *cardIdLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // icon
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.centerY.equalTo(self.mas_centerY);
            make.size.equalTo(CGSizeMake(BANK_ICON_SIZE, BANK_ICON_SIZE));
        }];
        
        // bank id
        cardIdLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        cardIdLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        cardIdLabel.font = [UIFont systemFontOfSize:11];
        cardIdLabel.textColor = QM_COMMON_TEXT_COLOR;
        cardIdLabel.highlightedTextColor = QM_COMMON_TEXT_COLOR;
        [self addSubview:cardIdLabel];
        [cardIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(5.0f);
            make.top.equalTo(self.mas_top);
            make.width.equalTo(40.0f);
            make.height.equalTo(self.mas_height);
        }];
    }
    
    return self;
}

- (void)configureWithBankCardInfo:(QMBankCardModel *)bankInfo {
    UIImage *placeHolderImage = nil;
    if (!QM_IS_STR_NIL(bankInfo.bankPicPath)) {
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:bankInfo.bankPicPath]
                         placeholderImage:placeHolderImage
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    // todo
                                }];
    }else {
        [iconImageView setImage:placeHolderImage];
    }
    
    // card id
    if ([bankInfo.bankCardNumber length] >= 4) {
        cardIdLabel.text = [bankInfo.bankCardNumber substringFromIndex:(bankInfo.bankCardNumber.length - 4)];
    }else {
        cardIdLabel.text = @"";
    }
}

@end
