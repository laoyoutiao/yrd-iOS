//
//  QMControlFactory.m
//  MotherMoney
//
//

#import "QMControlFactory.h"

@implementation QMControlFactory

+ (UIButton *)commonButtonWithSize:(CGSize)size
                             title:(NSString *)title
                            target:(id)target
                          selector:(SEL)selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.frame = CGRectMake(0, 0, size.width, size.height);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[QMImageFactory commonBtnNmBackgroundImage] forState:UIControlStateNormal];
    [btn setBackgroundImage:[QMImageFactory commonBtnHlBackgroundImage] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[QMImageFactory commonBtnDisableBackgroundImage] forState:UIControlStateDisabled];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];

    return btn;
}

+ (UIButton *)commonBorderedButtonWithSize:(CGSize)size
                                     title:(NSString *)title
                                    target:(id)target
                                  selector:(SEL)selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.frame = CGRectMake(0, 0, size.width, size.height);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[QMImageFactory commonBorderedBtnNmBackgroundImage] forState:UIControlStateNormal];
    [btn setBackgroundImage:[QMImageFactory commonBorderedBtnHlBackgroundImage] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[QMImageFactory commonBorderedBtnHlBackgroundImage] forState:UIControlStateDisabled];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

+ (UIButton *)commonTextButtonWithTitle:(NSString *)title
                                 target:(id)target
                               selector:(SEL)selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleLabel.font = [UIFont systemFontOfSize:11];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:1 green:247.0f / 255.0f blue:153.0f / 255.0f alpha:0.7f] forState:UIControlStateNormal];
    
    return btn;
}

+ (UIButton *)commonCheckBoxButtonWithTitle:(NSString *)title
                                     target:(id)target
                                   selector:(SEL)selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [btn setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.7f] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:11];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"check_box_2.png"] forState:UIControlStateSelected];

    return btn;
}

+ (UITextField *)commonTextFieldWithPlaceholder:(NSString *)placeholder delegate:(id)delegate {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, [UIColor colorWithRed:191.0f / 255.0f green:191.0f / 255.0f blue:191.0f / 255.0f alpha:1.0f], NSForegroundColorAttributeName, nil]];
    textField.delegate = delegate;
    textField.attributedPlaceholder = attrString;
    textField.font = [UIFont systemFontOfSize:14];
    textField.textColor = [UIColor blackColor];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    
    textField.leftView = leftView;
    textField.rightView = rightView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    return textField;
}

// 忘记密码按钮
+ (UIButton *)forgetPwdBtnWithTarget:(id)target selector:(SEL)selector {
    UIButton *forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    forgetPwdBtn.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10.0f], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, [NSNumber numberWithInt:1], NSUnderlineStyleAttributeName, nil];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:QMLocalizedString(@"qm_register_forget_password_btn_title", @"忘记密码") attributes:dict];
    [forgetPwdBtn setAttributedTitle:attr forState:UIControlStateNormal];
    [forgetPwdBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return forgetPwdBtn;
}

@end
