//
//  QMControlFactory.h
//  MotherMoney
//
//

#import <Foundation/Foundation.h>

@interface QMControlFactory : NSObject

+ (UIButton *)commonButtonWithSize:(CGSize)size
                             title:(NSString *)title
                            target:(id)target
                          selector:(SEL)selector;

+ (UIButton *)commonBorderedButtonWithSize:(CGSize)size
                                     title:(NSString *)title
                                    target:(id)target
                                  selector:(SEL)selector;

// 协议按钮
+ (UIButton *)commonTextButtonWithTitle:(NSString *)title
                                 target:(id)target
                               selector:(SEL)selector;

// 复选框
+ (UIButton *)commonCheckBoxButtonWithTitle:(NSString *)title
                                     target:(id)target
                                   selector:(SEL)selector;

// 电话号码文本框
+ (UITextField *)commonTextFieldWithPlaceholder:(NSString *)placeholder delegate:(id)delegate;

// 忘记密码按钮
+ (UIButton *)forgetPwdBtnWithTarget:(id)target selector:(SEL)selector;

@end
