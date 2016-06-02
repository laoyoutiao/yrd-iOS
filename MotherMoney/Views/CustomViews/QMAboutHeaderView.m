//
//  QMAboutHeaderView.m
//  MotherMoney
//

#import "QMAboutHeaderView.h"

@implementation QMAboutHeaderView {
    UIImageView *logoView;
    UILabel *aboutInfoLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        logoView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 60.0f) / 2.0f, 30.0f, 60, 60)];
        logoView.image = [UIImage imageNamed:@"icon_iphne120.png"];
        [self addSubview:logoView];
        
        CGSize size = [[self class] sizeForAboutInfo:nil];
        aboutInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, CGRectGetMaxY(logoView.frame) + 10, CGRectGetWidth(frame) - 2 * 23, size.height)];
        aboutInfoLabel.font = [UIFont systemFontOfSize:14];
        aboutInfoLabel.numberOfLines = 0;
        aboutInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        aboutInfoLabel.textColor = QM_COMMON_TEXT_COLOR;
        [self addSubview:aboutInfoLabel];
    }
    
    return self;
}

- (void)setAboutInfo:(NSString *)aboutInfo {
    CGSize size = [[self class] sizeForAboutInfo:aboutInfo];
    aboutInfoLabel.frame = CGRectMake(23, CGRectGetMaxY(logoView.frame) + 10, CGRectGetWidth(self.frame) - 2 * 23, size.height);
    
    aboutInfoLabel.text = aboutInfo;
}

+ (CGSize)sizeForAboutInfo:(NSString *)info {
    return [info boundingRectWithSize:CGSizeMake(320 - 2 * 23, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, nil] context:nil].size;
}

+ (CGSize)sizeForHeaderView:(NSString *)info {
    CGSize size = CGSizeMake(320 - 2 * 23, 30.0f + 60.0f + 10.0f);
    
    size.height += [self sizeForAboutInfo:info].height;
    size.height += 15;
    
    return size;
}

@end
