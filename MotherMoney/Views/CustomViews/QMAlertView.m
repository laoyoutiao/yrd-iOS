//
//  QMAlertView.m
//  MotherMoney

#import "QMAlertView.h"

@implementation QMAlertView {
    CGFloat deviceWidth;
}
@synthesize delegate;
@synthesize isVisible;
@synthesize alertView;
@synthesize confirmButton;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        deviceWidth = [UIScreen mainScreen].bounds.size.width;
        
        // Initialization code
        isVisible = NO;
        // Initialization code
        self.bgView = [[UIView alloc] initWithFrame:[[[[UIApplication sharedApplication] windows] objectAtIndex:0] bounds]];
        self.bgView.userInteractionEnabled = YES;
        self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.bgView addGestureRecognizer:tapRec];
        
        self.alertView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, deviceWidth-20, 180)];
        self.alertView.layer.cornerRadius = 5;
        self.alertView.layer.masksToBounds = YES;
        self.alertView.center = CGPointMake(_bgView.center.x, _bgView.center.y-50);
        self.alertView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [self.bgView addSubview:self.alertView];
        
        //请输入支付密码
        UILabel *inputPwd = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, deviceWidth-20, 20)];
        inputPwd.backgroundColor = [UIColor clearColor];
        inputPwd.text = @"支付密码";
        inputPwd.font = [UIFont boldSystemFontOfSize:15];
        inputPwd.textColor = [UIColor whiteColor];
        [self.alertView addSubview:inputPwd];
        
        //分割线
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectZero];
        line1.backgroundColor = [UIColor blackColor];
        [alertView addSubview:line1];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor colorWithRed:77.0f / 255.0f green:77.0f / 255.0f blue:77.0f / 255.0f alpha:1.0f];
        [self.alertView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.alertView.mas_left);
            make.right.equalTo(self.alertView.mas_right);
            make.top.equalTo(self.alertView.mas_top).offset(33);
            make.height.equalTo(1.0f);
        }];

        self.forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.forgetButton setTitle:@"忘记支付密码?" forState:UIControlStateNormal];
        [self.forgetButton setTitleColor:[UIColor colorWithRed:232.0f / 255.0f green:233.0f / 255.0f blue:232.0f / 255.0f alpha:1.0f] forState:UIControlStateNormal];
        self.forgetButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        self.forgetButton.backgroundColor = [UIColor clearColor];
        [alertView addSubview:self.forgetButton];
        [self.forgetButton addTarget:self action:@selector(forgetPwd) forControlEvents:UIControlEventTouchUpInside];
        [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(alertView.mas_right).offset(-10.0f);
            make.height.equalTo(30.0f);
            make.top.equalTo(alertView.mas_top).offset(35);
            make.width.equalTo(110.0f);
        }];
        
        //支付密码输入
        self.payTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 70, 280, 40)];
        self.payTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.payTextField.layer.cornerRadius = 5;
        self.payTextField.layer.masksToBounds = YES;
        self.payTextField.backgroundColor = [UIColor clearColor];
        self.payTextField.delegate = self;
        [self.alertView addSubview:self.payTextField];
        
        //支付密码view
        
        self.payPwdView = [[QMPayPwdView alloc] initWithFrame:CGRectZero];
        [alertView addSubview:_payPwdView];
        [_payPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(alertView.mas_left).offset(10.0f);
            make.top.equalTo(alertView.mas_top).offset(70.0f);
            make.right.equalTo(alertView.mas_right).offset(-30.0f);
            make.height.equalTo(40.0f);
        }];
        self.payPwdView.backgroundColor = [UIColor whiteColor];
        self.payPwdView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapPayViewRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPayView)];
        [self.payPwdView addGestureRecognizer:tapPayViewRec];
        
        
        //提示label
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, 280, 20)];
        self.tipLabel.backgroundColor = [UIColor clearColor];
        self.tipLabel.text = @"";
        self.tipLabel.textColor = [UIColor colorWithRed:220.0f / 255.0f green:50.0f / 255.0f blue:80.0f / 255.0f alpha:1.0f];
        self.tipLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.alertView addSubview:self.tipLabel];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, CGRectGetHeight(self.alertView.frame)-40, CGRectGetWidth(self.alertView.frame)/2.0, 40);
        cancelBtn.backgroundColor = [UIColor colorWithRed:236.0/255 green:130.0/255 blue:56.0/255 alpha:1.0];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        cancelBtn.titleLabel.textColor = [UIColor whiteColor];
        [cancelBtn setTitleColor:[UIColor colorWithRed:21.0f / 255.0f green:164.0f / 255.0f blue:228.0f / 255.0f alpha:1.0f] forState:UIControlStateHighlighted];
        cancelBtn.layer.cornerRadius = 3;
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.backgroundColor = [UIColor clearColor];
        [cancelBtn setTitle:QMLocalizedString(@"qm_alertview_cancel_title", @"取消") forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[[UIImage imageNamed:@"payBt_selected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 1, 1)] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
        
        //分割线
        UILabel *line20 = [[UILabel alloc] initWithFrame:CGRectZero];
        line20.backgroundColor = [UIColor blackColor];
        [self.alertView addSubview:line20];
        UILabel *line21 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(alertView.frame)-41, 300, 1)];
        line21.backgroundColor = [UIColor colorWithRed:77.0f / 255.0f green:77.0f / 255.0f blue:77.0f / 255.0f alpha:1.0f];
        [self.alertView addSubview:line21];
        [line21 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.alertView.mas_left);
            make.right.equalTo(self.alertView.mas_right);
            make.bottom.equalTo(self.alertView.mas_bottom).offset(-42.0f);
            make.height.equalTo(1.0f);
        }];
        
        [self.alertView addSubview:cancelBtn];
        
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmButton.frame = CGRectMake(150, CGRectGetHeight(alertView.frame)-40, CGRectGetWidth(alertView.frame)/2.0, 40);
        self.confirmButton.backgroundColor = [UIColor clearColor];
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.confirmButton.titleLabel.textColor = [UIColor whiteColor];
        [self.confirmButton setTitle:@"确定支付" forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:[UIColor colorWithRed:21.0f / 255.0f green:164.0f / 255.0f blue:228.0f / 255.0f alpha:1] forState:UIControlStateHighlighted];
        [self.confirmButton setBackgroundImage:[[UIImage imageNamed:@"payBt_selected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 1, 1)] forState:UIControlStateNormal];
        [self.confirmButton addTarget:self action:@selector(confirmSubmit) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:self.confirmButton];
        
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.alertView.mas_left);
            make.bottom.equalTo(self.alertView.mas_bottom);
            make.right.equalTo(self.confirmButton.mas_left);
            make.height.equalTo(40.0f);
        }];
        
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cancelBtn.mas_right);
            make.bottom.equalTo(cancelBtn.mas_bottom);
            make.right.equalTo(self.alertView.mas_right);
            make.height.equalTo(40.0f);
            make.width.equalTo(cancelBtn.mas_width);
        }];
        
        
        //分割线
        UILabel *line30 = [[UILabel alloc] initWithFrame:CGRectMake(149, CGRectGetHeight(alertView.frame)-40, 1, 40)];
        line30.backgroundColor = [UIColor blackColor];
        [alertView addSubview:line30];
        [line30 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cancelBtn.mas_right);
            make.top.equalTo(cancelBtn.mas_top);
            make.width.equalTo(1);
            make.height.equalTo(40);
        }];
        
        UILabel *line31 = [[UILabel alloc] initWithFrame:CGRectMake(150, CGRectGetHeight(alertView.frame)-40, 1, 40)];
        line31.backgroundColor = [UIColor colorWithRed:77.0f / 255.0f green:77.0f / 255.0f blue:77.0f / 255.0f alpha:1.0f];
        [alertView addSubview:line31];
        [line31 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line30.mas_right);
            make.top.equalTo(cancelBtn.mas_top);
            make.width.equalTo(1);
            make.height.equalTo(40);
        }];
    }
    
    return self;
}

-(void)cancle
{
    [self dismiss];
    //添加提示框
    [CMMUtility showAlertWith:@"确认取消本次支付？" target:self tag:123];
}

-(void)tap:(UITapGestureRecognizer *)tap {
    LNLogInfo(@"tap");
    CGPoint point = [tap locationInView:self.bgView];
    BOOL isIn = CGRectContainsPoint(self.alertView.frame, point);
    if (isIn) {
        LNLogInfo(@"在响应区域 %d",isIn);
    }
    
    
    
    if (!isIn) {
        [self dismiss];
        //添加提示框
        [CMMUtility showAlertWith:@"确认取消本次支付？" target:self tag:123];
    }
    
}

-(void)tapPayView {
    LNLogInfo(@"tap");
    [self.payTextField becomeFirstResponder];
}

#pragma mark -----忘记密码
-(void)forgetPwd {
    LNLogInfo(@"忘记密码");
    if ([self.delegate respondsToSelector:@selector(alertForgetPwd)]) {
        [self.delegate alertForgetPwd];
    }else{
        LNLogInfo(@"代理不响应忘记密码");
    }
}

-(void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    [self performSelector:@selector(tapPayView) withObject:nil afterDelay:0.1];
    isVisible = YES;
}

-(void)dismiss {
    [self.bgView removeFromSuperview];
    isVisible = NO;
}

#pragma mark -----textfield
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.alertView.center = CGPointMake(_bgView.center.x, _bgView.center.y-80);
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    LNLogInfo(@"处理之前%@ 替换区域 %@",textField.text,[NSValue valueWithRange:range]);
    
    NSString *currentStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    LNLogInfo(@"会变成%@",currentStr);
    NSInteger changeLength = currentStr.length;
    if (changeLength <= 6) {
        [self.payPwdView setLabelShow:changeLength];
        return YES;
    }else{
        return NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.alertView.center = CGPointMake(_bgView.center.x, _bgView.center.y-50);
}

-(void)showErrorMSG:(NSString *)msg {
    _tipLabel.text = msg;
    [CMMUtility shakeView:_tipLabel];
}

-(void)clearErrorMSG {
    _tipLabel.text = nil;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //
        if ([self.delegate respondsToSelector:@selector(userCancelTransAction)]) {
            //
            [self.delegate userCancelTransAction];
        }else{
            LNLogInfo(@"代理不响应取消方法");
        }
    }else{
        //重新显示
        [self show];
    }
}


-(void)confirmSubmit {
    if ([self.delegate respondsToSelector:@selector(alertConfirmCheckWithPwd:)]) {
        NSString *pwdTextStr = _payTextField.text;
        [self.delegate alertConfirmCheckWithPwd:pwdTextStr];
    }else {
        LNLogInfo(@"代理不响应提交方法");
    }
}


-(void)clearTextField {
    self.payTextField.text = @"";
    [self.payPwdView setLabelShow:0];
}



@end

