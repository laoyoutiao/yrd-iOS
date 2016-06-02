//
//  QMWindControlHeaderCellHeader.m
//  MotherMoney
//

#import "QMWindControlHeaderCellHeader.h"

#define HEADER_ICON_SIZE_W 14.5
#define HEADER_ICON_SIZE_H 15

#define BG_TOP_PADDING 8

#define TITLE_INTRODUCTION_PADDING 10

#define PRODUCTION_INTRODUCTION_BOTTOM_PADDING 15

@implementation QMWindControlHeaderCellHeader {
    UIImageView *bgView;
    UIImageView *iconImageView;
    UILabel *titleLabel;
    
    UILabel *introductionLabel;;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *containerView = [[UIView alloc] initWithFrame:self.bounds];
        containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:containerView];
        
        bgView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImageTopPart]];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        bgView.frame = CGRectMake(8, 8, CGRectGetWidth(self.frame) - 2 * 8, CGRectGetHeight(containerView.bounds) - 6);
        [containerView addSubview:bgView];
        
        // icon
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(bgView.frame) + 15, BG_TOP_PADDING + 15, HEADER_ICON_SIZE_W, HEADER_ICON_SIZE_H)];
        [containerView addSubview:iconImageView];
        
        // title
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 5, CGRectGetMinY(iconImageView.frame), 100, CGRectGetHeight(iconImageView.frame))];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [containerView addSubview:titleLabel];
        
        // introduction
        introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(iconImageView.frame), CGRectGetMaxY(iconImageView.frame), CGRectGetWidth(self.frame) - CGRectGetMinX(iconImageView.frame) * 2, 100)];
        introductionLabel.font = [UIFont systemFontOfSize:10];
        introductionLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        introductionLabel.numberOfLines = 0;
        introductionLabel.textAlignment = NSTextAlignmentLeft;
        [containerView addSubview:introductionLabel];
    }
    
    return self;
}

- (void)configureHeaderWithWindControlModel:(QMProductWindControlModel *)model {
    iconImageView.image = [UIImage imageNamed:@"wind_control_icon.png"];
    
    titleLabel.text = model.productTitle;
    
    CGSize size = [model.windControlIntroduction boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * (8 + 15), 1000)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10], NSFontAttributeName, nil]
                                                              context:nil].size;
    CGRect frame = introductionLabel.frame;
    frame.origin.y = CGRectGetMaxY(iconImageView.frame) + TITLE_INTRODUCTION_PADDING;
    frame.size.height = size.height;
    introductionLabel.frame = frame;
    introductionLabel.text = model.windControlIntroduction;
}

- (void)prepareForReuse {
    iconImageView.image = nil;
    titleLabel.text = @"";
    introductionLabel.text = @"";
}

+ (CGSize)getHeaderSizeWithWindControlModel:(QMProductWindControlModel *)model {
    CGFloat height = 15 + HEADER_ICON_SIZE_H + TITLE_INTRODUCTION_PADDING + PRODUCTION_INTRODUCTION_BOTTOM_PADDING + BG_TOP_PADDING;
    
    CGSize size = [model.windControlIntroduction boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * (8 + 15), 1000)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10], NSFontAttributeName, nil]
                                                              context:nil].size;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 2 * 15;
    return CGSizeMake(width, height + size.height);
}


@end
