//
//  QMNumberFormatPromptView.m
//  MotherMoney

#import "QMNumberFormatPromptView.h"

@implementation QMNumberFormatPromptView {
    UIImageView *promptLabelBackground;
    UILabel *bankCardpromptLabel;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // prompt label
        promptLabelBackground = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"common_input_number.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:23]];
        promptLabelBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        promptLabelBackground.frame = self.bounds;
        bankCardpromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(promptLabelBackground.frame), CGRectGetMinY(promptLabelBackground.frame), CGRectGetWidth(promptLabelBackground.frame), CGRectGetHeight(promptLabelBackground.frame))];
        bankCardpromptLabel.textAlignment = NSTextAlignmentCenter;
        bankCardpromptLabel.font = [UIFont systemFontOfSize:18];
        bankCardpromptLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        bankCardpromptLabel.textColor = [UIColor colorWithRed:149.0f / 255.0f green:13.0f / 255.0f blue:12.0f / 255.0f alpha:1.0f];
        
        [self addSubview:promptLabelBackground];
        [self addSubview:bankCardpromptLabel];
    }
    
    return self;
}

- (void)updateWithText:(NSString *)text {
    bankCardpromptLabel.text = text;
}

@end
