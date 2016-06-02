//
//  QMPayPwdView.m
//  MotherMoney


#import "QMPayPwdView.h"

@implementation QMPayPwdView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        [self.layer setBorderWidth:0.5];
        [self.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        self.labelArray = [NSMutableArray arrayWithCapacity:6];
        for (int i=0; i<6; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            CGFloat width = (CGRectGetWidth([UIScreen mainScreen].bounds) - 60) / 6.0f;
            label.center = CGPointMake(width / 2.0f + width * i, 20);
            label.layer.cornerRadius = label.bounds.size.width/2.0;
            label.backgroundColor = [UIColor blackColor];
            label.layer.masksToBounds = YES;
            [self addSubview:label];
            label.hidden = YES;
            [self.labelArray addObject:label];
        }
        
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1);
    
    //设置颜色
    CGContextSetRGBStrokeColor(context, 220/255.0, 220/255.0, 220/255.0, 1);
    //开始一个起始路径
    
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    for (int i=1; i<6; i++) {
        CGContextMoveToPoint(context, self.bounds.size.width/6.0*i, 0);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, self.bounds.size.width/6.0*i, self.bounds.size.height);
    }
    
    CGContextStrokePath(context);
}

-(void)setLabelShow:(NSInteger)count {
    //设置显示的label
    for (NSInteger i =0; i<count; i++) {
        UILabel *label = [self.labelArray objectAtIndex:i];
        label.hidden = NO;
    }
    
    
    for (NSInteger j =count; j<6; j++) {
        UILabel *label = [self.labelArray objectAtIndex:j];
        label.hidden = YES;
    }
}


@end
