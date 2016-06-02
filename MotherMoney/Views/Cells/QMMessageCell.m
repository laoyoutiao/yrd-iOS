//
//  QMMessageCell.m
//  MotherMoney
//
//  Created by   on 14-8-9.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMMessageCell.h"

#define CONTENT_VIEW_WIDTH [UIScreen mainScreen].bounds.size.width - 80 // 240

@implementation QMMessageCell {
    UIImageView *msgContainerView;
    
    UIImageView *dotImageView;
    //垂直线视图
    UIImageView *verticalLine;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *superView = self.contentView;
        
        // dot
        verticalLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tradelogLine.png"]];
        verticalLine.frame = CGRectMake(24, 0, 8, CGRectGetHeight(self.frame));
        verticalLine.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:verticalLine];
        //对垂直线进行位置约束设置
        [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            //左边距离父视图24
            make.left.equalTo(superView.mas_left).offset(24);
            make.top.equalTo(superView.mas_top);
            make.width.equalTo(8);
            make.height.equalTo(superView.mas_height);
        }];
        
        dotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg_system_read.png"]];
        [self.contentView addSubview:dotImageView];
        //信息图片视图的位置约束设置
        [dotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.mas_left).offset(10);
            make.top.equalTo(superView.mas_top).offset(10);
            make.size.equalTo(CGSizeMake(36, 36));
        }];
        
        // container
        msgContainerView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"msg_content_bg.png"] stretchableImageWithLeftCapWidth:16 topCapHeight:35]];
        [self.contentView addSubview:msgContainerView];
        [msgContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.mas_left).offset(45);
            make.top.equalTo(superView.mas_top).offset(10);
            make.right.equalTo(superView.mas_right).offset(-15.0f);
            make.bottom.equalTo(superView.mas_bottom);
        }];
        
        // msg title
        self.msgTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.msgTitleLabel.font = [UIFont systemFontOfSize:14];
        self.msgTitleLabel.textColor = [UIColor lightGrayColor];
        [msgContainerView addSubview:self.msgTitleLabel];
        [self.msgTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(msgContainerView.mas_left).offset(15.0f);
            make.top.equalTo(msgContainerView.mas_top).offset(5);
            make.size.equalTo(CGSizeMake(70, 16));
        }];
        
        // date
        self.msgDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.msgDateLabel.textAlignment = NSTextAlignmentRight;
        self.msgDateLabel.font = [UIFont systemFontOfSize:14];
        self.msgDateLabel.textColor = [UIColor lightGrayColor];
        [msgContainerView addSubview:self.msgDateLabel];
        [self.msgDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.msgTitleLabel.mas_top);
            make.right.equalTo(msgContainerView.mas_right).offset(-5);
            make.size.equalTo(CGSizeMake(200, 16));
        }];
        
        // content
        self.msgContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.msgContentLabel.numberOfLines = 0;
        self.msgContentLabel.font = [UIFont systemFontOfSize:14];
        self.msgContentLabel.textColor = [UIColor lightGrayColor];
        [msgContainerView addSubview:self.msgContentLabel];
        [self.msgContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.msgTitleLabel.mas_left);
            make.top.equalTo(self.msgTitleLabel.mas_bottom).offset(10);
            make.width.equalTo(msgContainerView.mas_width).offset(-20.0f);
            make.height.equalTo(10.0f);
        }];
    }
    return self;
}

+ (CGSize)sizeForString:(NSString *)str {
    CGFloat height = 0;
    if (!QM_IS_STR_NIL(str)) {
        CGSize size = [str boundingRectWithSize:CGSizeMake(CONTENT_VIEW_WIDTH, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] context:nil].size;
        height += size.height;
    }
    
    return CGSizeMake(320, height);
}

- (void)configureCellWithMessage:(QMMessageInfo *)info {
    if (!QM_IS_STR_NIL(info.messageTitle)) {
        self.msgTitleLabel.text = info.messageTitle;
    }else {
        self.msgTitleLabel.text = @"";
    }
    
    if (!QM_IS_STR_NIL(info.updateTime)) {
        self.msgDateLabel.text = info.updateTime;
    }else {
        self.msgDateLabel.text = @"";
    }
    
    self.msgContentLabel.text = info.messageContent;
    CGSize size = [[self class] sizeForString:info.messageContent];
    [self.msgContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        make.left.equalTo(self.msgTitleLabel.mas_left);
        make.top.equalTo(self.msgTitleLabel.mas_bottom).offset(10);
        make.width.equalTo(msgContainerView.mas_width).offset(-20.0f);
        make.height.equalTo(ceil(size.height));
    }];
}

+ (CGFloat)getCellHeightForMessage:(QMMessageInfo *)info {
    return [self sizeForString:info.messageContent].height + 10 + 5 + 16 + 10 + 5;
}

@end
