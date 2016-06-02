//
//  QMProductInfoActionCell.m
//  MotherMoney
//
//  Created by   on 14-8-16.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMProductInfoActionCell.h"

@implementation QMProductInfoActionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImageBottomPart]];
        
        // 查看产品详细信息
        self.viewProductDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.viewProductDetailBtn.frame = CGRectMake(0, 5, CGRectGetWidth(frame), 80);
        self.viewProductDetailBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.viewProductDetailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.viewProductDetailBtn setTitle:QMLocalizedString(@"qm_product_info_page_product_detail_info", @"查看产品详细信息") forState:UIControlStateNormal];
        [self.contentView addSubview:self.viewProductDetailBtn];
        
        // 资金安全
        self.productSecureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.productSecureBtn.frame = CGRectMake(0, CGRectGetMaxY(self.viewProductDetailBtn.frame), CGRectGetWidth(frame), 40);
//        self.productSecureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [self.productSecureBtn setTitleColor:[UIColor colorWithRed:40.0f / 255.0f green:153.0f / 255.0f blue:0 alpha:1.0f] forState:UIControlStateNormal];
//        [self.productSecureBtn setTitle:QMLocalizedString(@"qm_product_info_page_secure_btn_title", @"账户资金安全由平安保险全额承保") forState:UIControlStateNormal];
//        [self.contentView addSubview:self.productSecureBtn];
    }

    return self;
}

+ (CGFloat)getCellHeightForProductInfo:(QMProductInfo *)info {
    return 100.0f;
}

@end
