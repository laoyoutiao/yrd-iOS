//
//  QMPayPwdView.h
//  MotherMoney

#import <UIKit/UIKit.h>

@interface QMPayPwdView : UIView
@property (retain, nonatomic) UILabel *label1,*label2,*label3,*label4,*label5,*label6;
@property (retain, nonatomic) NSMutableArray *labelArray;

-(void)setLabelShow:(NSInteger)count;

@end
