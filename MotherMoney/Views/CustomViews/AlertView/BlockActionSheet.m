//
//  BlockActionSheet.m
//
//

#import "BlockActionSheet.h"
#import "BlockBackground.h"
#import "BlockUI.h"
#import "QMBottomTitleBtn.h"

@interface BlockActionSheet () <UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL hasTitle;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation BlockActionSheet

@synthesize view = _view;
@synthesize vignetteBackground = _vignetteBackground;

static UIImage *background = nil;
static UIFont *titleFont = nil;
static UIFont *buttonFont = nil;

#pragma mark - init
+ (void)initialize {
    if (self == [BlockActionSheet class]) {
        background = [[QMImageFactory commonBackgroundImageTopPart] retain];
        titleFont = [kActionSheetTitleFont retain];
        buttonFont = [kActionSheetButtonFont retain];
    }
}

+ (id)sheetWithTitle:(NSString *)title {
    return [[[BlockActionSheet alloc] initWithTitle:title] autorelease];
}

- (id)initWithTitle:(NSString *)title {
    if ((self = [super init])) {
        UIWindow *parentView = [BlockBackground sharedInstance];
        CGRect frame = parentView.bounds;
        
        _view = [[UIView alloc] initWithFrame:frame];
        _view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        _blocks = [[NSMutableArray alloc] init];
        _height = kActionSheetTopMargin;
        self.backgroundTriggersCancel = YES;

        if (title) {
            CGSize size = [title sizeWithFont:titleFont
                            constrainedToSize:CGSizeMake(frame.size.width-kActionSheetBorderHorizontal*2, 1000)
                                lineBreakMode:NSLineBreakByWordWrapping];
            
            UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(kActionSheetBorderHorizontal, _height + kActionSheetTitleVerticalMargin, frame.size.width-kActionSheetBorderHorizontal*2, size.height)];
            labelView.font = titleFont;
            labelView.numberOfLines = 0;
            labelView.lineBreakMode = NSLineBreakByWordWrapping;
            labelView.textColor = kActionSheetTitleTextColor;
            labelView.backgroundColor = [UIColor clearColor];
            labelView.textAlignment = NSTextAlignmentCenter;
            labelView.shadowColor = kActionSheetTitleShadowColor;
            labelView.shadowOffset = kActionSheetTitleShadowOffset;
            labelView.text = title;
            
            labelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

            [_view addSubview:labelView];
            [labelView release];
            
            _height += size.height + kActionSheetTitleVerticalMargin * 2;
            _hasTitle = YES;
        } else {
            _hasTitle = NO;
        }
        _vignetteBackground = NO;
        
        // 添加手势
        if (!self.tapGestureRecognizer) {
            _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundClicked:)];
            _tapGestureRecognizer.delegate = self;
        }
        
        [parentView addGestureRecognizer:_tapGestureRecognizer];
    }
    
    return self;
}

- (void) dealloc  {
    [_view release];
    [_blocks release];
    
    // remove self.tapgesture from overlay window.
    UIWindow *parentView = [BlockBackground sharedInstance];
    [parentView removeGestureRecognizer:_tapGestureRecognizer];
    [_tapGestureRecognizer release];

    [super dealloc];
}

- (NSUInteger)buttonCount {
    return _blocks.count;
}

- (void)addButtonWithTitle:(NSString *)title
                     color:(UIColor *)color
                 imageName:(NSString *)imageName
                     block:(void (^)())block atIndex:(NSInteger)index {
    if (index >= 0) {
        [_blocks insertObject:[NSArray arrayWithObjects:
                               block ? [[block copy] autorelease] : [NSNull null],
                               title,
                               color,
                               imageName ? [[imageName copy] autorelease] : [NSNull null],
                               nil]
                      atIndex:index];
    }else {
        [_blocks addObject:[NSArray arrayWithObjects:
                            block ? [[block copy] autorelease] : [NSNull null],
                            title,
                            color,
                            imageName ? [[imageName copy] autorelease] : [NSNull null],
                            nil]];
    }
}

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block {
    [self addButtonWithTitle:title color:kActionSheetDestructiveButtonTextColor imageName:nil block:block atIndex:-1];
}

- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block {
    [self addButtonWithTitle:title color:kActionSheetCancelButtonTextColor imageName:nil block:block atIndex:-1];
}

- (void)addButtonWithTitle:(NSString *)title
                 imageName:(NSString *)imageName
                     block:(void (^)())block {
    [self addButtonWithTitle:title
                       color:kActionSheetButtonTextColor
                   imageName:imageName
                       block:block atIndex:-1];
}

- (void)setDestructiveButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)())block {
    [self addButtonWithTitle:title color:kActionSheetDestructiveButtonTextColor
                   imageName:nil block:block atIndex:index];
}

- (void)setCancelButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)())block {
    [self addButtonWithTitle:title color:kActionSheetCancelButtonTextColor imageName:nil block:block atIndex:index];
}

- (void)addButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)())block  {
    [self addButtonWithTitle:title color:kActionSheetButtonTextColor imageName:nil block:block atIndex:index];
}

- (void)showInView:(UIView *)view {
    NSUInteger i = 1;   // Why?
    for (NSArray *block in _blocks) {
        // Separator
        if (_height > kActionSheetTopMargin) {
            UIImage *separatorImage = [[UIImage imageNamed:@"alert-action-separator-horizontal"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
            UIImageView *separatorImageView = [[UIImageView alloc] initWithImage:separatorImage];
            separatorImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            separatorImageView.frame = CGRectMake(kActionSheetBorderHorizontal, _height, _view.bounds.size.width - kActionSheetBorderHorizontal * 2, 1);
            [_view addSubview:separatorImageView];
        }
        
        NSString *title = [block objectAtIndex:1];
        NSString *imageName = [block objectAtIndex:3];
        UIButton *button = nil;
        if (i == [self buttonCount]) { // 这里就是取消按钮
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            _height += 75;
            
            CGFloat originY = _height;
            button.frame = CGRectMake(15, originY, CGRectGetWidth(_view.frame) - 2 * 15, 45.0f);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [button setBackgroundImage:[QMImageFactory commonBtnNmBackgroundImage] forState:UIControlStateNormal];
            [button setBackgroundImage:[QMImageFactory commonBtnHlBackgroundImage] forState:UIControlStateHighlighted];
            [button setTitle:title forState:UIControlStateNormal];
        }else {
            button = [QMBottomTitleBtn buttonWithType:UIButtonTypeCustom];
            NSInteger index = i;
            if (i > 4) {
                index = i - 4;
            }
            CGFloat originX = 15 + 70 * (index - 1) + ((CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * 15 - 70 * 4) / 3.0f) * (index - 1);
            button.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            [button setTitleColor:QM_COMMON_TEXT_COLOR forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.frame = CGRectMake(originX, _height, 70, 60);
            if ([imageName isKindOfClass:[NSString class]]) {
                [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            }
            [button setTitle:title forState:UIControlStateNormal];
            
            if (i == 4) {
                _height += 70;
            }
        }
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = i++;
        
        [_view addSubview:button];
    }
    
    _height += 75;
    
    UIImageView *modalBackground = [[UIImageView alloc] initWithFrame:_view.bounds];
    modalBackground.image = background;
    modalBackground.contentMode = UIViewContentModeScaleToFill;
    modalBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_view insertSubview:modalBackground atIndex:0];
    [modalBackground release];
    
    [BlockBackground sharedInstance].vignetteBackground = _vignetteBackground;
    [[BlockBackground sharedInstance] addToMainWindow:_view];
    CGRect frame = _view.frame;
    frame.origin.y = [BlockBackground sharedInstance].bounds.size.height;
    frame.size.height = _height;
    _view.frame = frame;
    
    __block CGPoint center = _view.center;
    center.y -= _height + kActionSheetBounce;
    
    [BlockBackground sharedInstance].alpha = 1.0f;
    [UIView animateWithDuration:kActionSheetAnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         center.y += kActionSheetBounce;
                         _view.center = center;
                     } completion:^(BOOL finished) {
                        
                     }];
    
    [self retain];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated  {
    if (buttonIndex >= 0 && buttonIndex < [_blocks count]) {
        id obj = [[_blocks objectAtIndex: buttonIndex] objectAtIndex:0];
        if (![obj isEqual:[NSNull null]]) {
            ((void (^)())obj)();
        }
    }
    
    if (animated) {
        CGPoint center = _view.center;
        center.y += _view.bounds.size.height;
        
        [[BlockBackground sharedInstance] reduceAlphaIfEmpty];
        [BlockBackground sharedInstance].alpha = 1.0f;
        [UIView animateWithDuration:kActionSheetAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _view.center = center;
                         } completion:^(BOOL finished) {
                             [[BlockBackground sharedInstance] removeView:_view];
                             [_view release]; _view = nil;
                             [self autorelease];
                         }];
    }else {
        [[BlockBackground sharedInstance] removeView:_view];
        [_view release]; _view = nil;
        [self autorelease];
    }
}


#pragma mark - Action
- (void)buttonClicked:(id)sender  {
    /* Run the button's block */
    NSInteger buttonIndex = [(UIButton *)sender tag] - 1;
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)backgroundClicked:(id)sender {
    [self dismissWithClickedButtonIndex:-1 animated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
        if (self.view && CGRectContainsPoint(self.view.frame, location)) {
            return NO;
        }
        return YES;
    }
    return NO;
}

@end
