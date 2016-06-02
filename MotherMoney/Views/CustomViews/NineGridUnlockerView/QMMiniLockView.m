
#import "QMMiniLockView.h"

@implementation QMMiniLockView
@synthesize dotArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dotArray = [NSMutableArray arrayWithCapacity:9];
        CGFloat padding = 4;
        for (int i = 0; i < 9; i ++) {
            NSInteger xTMP = i%3;
            NSInteger yTMP = i/3;
            UIImage *image = [UIImage imageNamed:@"gesture_cipher_thumbnail.png"];
            UIImageView *dotView = [[UIImageView alloc] initWithImage:image];
            CGSize size = image.size;
            dotView.center = CGPointMake(size.width / 2.0f + xTMP * (padding + size.width), size.width / 2.0f + yTMP * (padding + size.width));
            dotView.tag = i;
            [self addSubview:dotView];
            [self.dotArray addObject:dotView];
        }
    }
    return self;
}

-(void)refreshWithInfo:(NSArray *)info
{
    for (UIImageView *image in dotArray) {
        NSInteger tagValue = image.tag;
        NSNumber *tagNumber = [NSNumber numberWithInt:(int)tagValue];
        if ([info containsObject:tagNumber]) {
            image.image = [UIImage imageNamed:@"gesture_cipher_thumbnail_2.png"];
        }else {
            image.image = [UIImage imageNamed:@"gesture_cipher_thumbnail.png"];
        }
    }
}

@end
