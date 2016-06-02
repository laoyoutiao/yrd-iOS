//
//  QMProductIntroductionCellHeader.m
//  MotherMoney
//

#import "QMProductIntroductionCellHeader.h"

#define INTRO_ICON_SIZE_WIDTH 14.5
#define INTRO_ICON_SIZE_HEIGHT 15

#define HORIZON_LINE_TOP_PADDING 10
#define HORIZON_LINE_BOTTOM_PADDING 10

#define DETAIL_BOTTOM_PADDING 20

#define INTRO_TITLE_CONTENT_PADDING 7

@implementation QMProductIntroductionCellHeader {
    UIImageView *iconImageView;
    UILabel *titleLabel;
    UIImageView *horizontalLine;
    
    UILabel *introductionLabel;
    UIImageView *bgView;
    
    // detail
    UILabel *detailTitleLabel;
    UILabel *detailIntroLabel;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:containerView];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
        
        bgView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImageTopPart]];
        [containerView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(containerView.mas_left).offset(8);
            make.right.equalTo(containerView.mas_right).offset(-8);
            make.top.equalTo(containerView.mas_top).offset(8);
            make.bottom.equalTo(containerView.mas_bottom);
        }];
        
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        iconImageView.image = [UIImage imageNamed:@"product_intro_icon.png"];
        [containerView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(15);
            make.top.equalTo(bgView.mas_top).offset(8.0f);
            make.size.equalTo(CGSizeMake(INTRO_ICON_SIZE_WIDTH, INTRO_ICON_SIZE_HEIGHT));
        }];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [containerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(5.0f);
            make.top.equalTo(iconImageView.mas_top);
            make.bottom.equalTo(iconImageView.mas_bottom);
        }];
        
        introductionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        introductionLabel.font = [UIFont systemFontOfSize:11];
        introductionLabel.numberOfLines = 0;
        introductionLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        [containerView addSubview:introductionLabel];
        [introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_left);
            make.top.equalTo(iconImageView.mas_bottom).offset(INTRO_TITLE_CONTENT_PADDING);
            make.right.equalTo(bgView.mas_right).offset(-15.0f);
            
        }];
        
        horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        [containerView addSubview:horizontalLine];
        [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(introductionLabel.mas_left);
            make.top.equalTo(introductionLabel.mas_bottom).offset(HORIZON_LINE_TOP_PADDING);
            make.right.equalTo(introductionLabel.mas_right);
            make.height.equalTo(1.0f);
        }];
        
        detailTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        detailTitleLabel.font = [UIFont systemFontOfSize:13];
        detailTitleLabel.textColor = [UIColor blackColor];
        detailTitleLabel.textAlignment = NSTextAlignmentLeft;
        [containerView addSubview:detailTitleLabel];
        [detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(horizontalLine.mas_left);
            make.right.equalTo(horizontalLine.mas_right);
            make.top.equalTo(horizontalLine.mas_bottom).offset(HORIZON_LINE_BOTTOM_PADDING);
            make.height.equalTo(15.0f);
        }];
        
        detailIntroLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        detailIntroLabel.font = [UIFont systemFontOfSize:11];
        detailIntroLabel.numberOfLines = 0;
        detailIntroLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        [containerView addSubview:detailIntroLabel];
        [detailIntroLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(detailTitleLabel.mas_left);
            make.top.equalTo(detailTitleLabel.mas_bottom).offset(8);
            make.right.equalTo(bgView.mas_right).offset(-15.0f);
        }];
    }
    
    return self;
}

- (void)configureHeaderWithWindControlModel:(QMProductIntroductionModel *)model {
    titleLabel.text = model.introlTitle;
    introductionLabel.text = model.productDescription;
    detailTitleLabel.text = model.productDesciptionTitle;
    detailIntroLabel.text = model.mortgageDesc;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    detailIntroLabel.text = @"";
    detailTitleLabel.text = @"";
    introductionLabel.text = @"";
    titleLabel.text = @"";
}

+ (CGSize)getHeaderSizeWithWindControlModel:(QMProductIntroductionModel *)model {
    CGFloat height = 8 + 15 + INTRO_ICON_SIZE_HEIGHT + INTRO_TITLE_CONTENT_PADDING + HORIZON_LINE_TOP_PADDING + HORIZON_LINE_BOTTOM_PADDING + 16 + DETAIL_BOTTOM_PADDING;

    CGSize size = [model.productDescription boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * (8 + 15), 1000)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11], NSFontAttributeName, nil]
                                                              context:nil].size;
    
    CGSize size1 = [model.mortgageDesc boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * (8 + 15), 1000)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11], NSFontAttributeName, nil]
                                                          context:nil].size;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 2 * (8 + 15);
    
    return CGSizeMake(width, height + size.height + size1.height);
}

@end
