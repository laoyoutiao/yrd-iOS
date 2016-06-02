//
//  QMProductDescriptionCell.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/4/6.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMProductDescriptionCell.h"

@implementation QMProductDescriptionCell {
    UIImageView *timeIconImageView;
    UILabel *timeTextLabel;
    UIImageView *productIconImageView;
    UILabel *productNameLabel;
    UIImageView *separatorLine;
    UILabel *productDescriptionLabel;
    UIImageView *separatorLine2;
    UILabel *productdetailedTextLabel;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImageCenterPart]];
        
        // 车辆图标
        productIconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        productIconImageView.image = [UIImage imageNamed:@"car_icon.png"];
        [self.contentView addSubview:productIconImageView];
        [productIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(6.5f);
            make.size.equalTo(CGSizeMake(12, 12));
        }];
        
        // 车辆名字信息
        productNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        productNameLabel.textAlignment = NSTextAlignmentLeft;
        productNameLabel.font = [UIFont systemFontOfSize:14.0f];
        productNameLabel.textColor = QM_COMMON_TEXT_COLOR;
        [self.contentView addSubview:productNameLabel];
        [productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(productIconImageView.mas_right).offset(3.0f);
            make.top.equalTo(productIconImageView.mas_top);
            make.bottom.equalTo(productIconImageView.mas_bottom);
            make.width.equalTo(100);
        }];
        
        productdetailedTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        productdetailedTextLabel.textAlignment = NSTextAlignmentLeft;
        productdetailedTextLabel.font = [UIFont systemFontOfSize:13.0f];
        productdetailedTextLabel.textColor = QM_COMMON_TEXT_COLOR;
        productdetailedTextLabel.numberOfLines = 0;
//        productdetailedTextLabel.text = @"工商银行广东省佛山朝东支行工商银行广东省佛山朝东支行";
        [self.contentView addSubview:productdetailedTextLabel];
        [productdetailedTextLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(productIconImageView.mas_left);
            make.top.equalTo(productIconImageView.mas_bottom).offset(5.0f);
            make.width.equalTo(200);
//            make.height.equalTo(40.0f);
        }];
        
        // 时间描述
        timeTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeTextLabel.textAlignment = NSTextAlignmentLeft;
        timeTextLabel.font = [UIFont systemFontOfSize:14.0f];
        timeTextLabel.textColor = QM_COMMON_TEXT_COLOR;
        [self.contentView addSubview:timeTextLabel];
        [timeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
            make.top.equalTo(productNameLabel.mas_top);
            make.bottom.equalTo(productNameLabel.mas_bottom);
            make.width.equalTo(40);
        }];
        
        // 时间图标
        timeIconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        timeIconImageView.image = [UIImage imageNamed:@"time_icon.png"];
        [self.contentView addSubview:timeIconImageView];
        [timeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(timeTextLabel.mas_left).offset(-3.0f);
            make.top.equalTo(timeTextLabel.mas_top);
            make.size.equalTo(CGSizeMake(12, 12));
        }];
        
        // 分割线
        separatorLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        separatorLine.image = [QMImageFactory commonHorizontalLineImage];
        [self.contentView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(productIconImageView.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
            make.top.equalTo(productdetailedTextLabel.mas_bottom).offset(10.0f);
            make.height.equalTo(0.5f);
        }];
        
        // 产品描述信息
        productDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        productDescriptionLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        productDescriptionLabel.numberOfLines = 0;
        productDescriptionLabel.textAlignment = NSTextAlignmentLeft;
        productDescriptionLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:productDescriptionLabel];
        [productDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(separatorLine.mas_left);
            make.right.equalTo(separatorLine.mas_right);
            make.top.equalTo(separatorLine.mas_bottom).offset(5.0f);
        }];
        
        // 分割线
        separatorLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 200, 10)];
        separatorLine2.image = [QMImageFactory commonHorizontalLineImage];
        [self.contentView addSubview:separatorLine2];
        [separatorLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(separatorLine.mas_left);
            make.right.equalTo(separatorLine.mas_right);
            make.top.equalTo(self.contentView.mas_bottom).offset(-1.0f);
            make.height.equalTo(0.5f);
        }];
    }
    
    return self;
}

+ (CGFloat)getCellHeightForProductInfo:(QMProductInfo *)info {
    CGFloat height = 10.0f + 15; // 图标
    height += 10; // 分割线上下的间距
    
    // 计算描述的高度
    CGSize size = [info.productDescription boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * 15 - 2 * 8, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f], NSFontAttributeName, nil] context:nil].size;
    height += size.height;
    
    height += 5;
    
    height += 3;
    
    return height;
}

- (void)configureCellWithProductInfo:(QMProductInfo *)info {
    // 理财期限
    timeTextLabel.text = info.maturityDuration;
    
    // 车辆质押
    productNameLabel.text = info.productText;
    
    productdetailedTextLabel.text = info.productDetailText;
    
    // 产品描述
    productDescriptionLabel.text = info.productDescription;
}

@end
