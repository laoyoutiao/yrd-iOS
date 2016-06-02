//
//  QMBuyProductFooterView.h
//  MotherMoney

#import <UIKit/UIKit.h>

@protocol QMBuyProductFooterViewDelegate;
@interface QMBuyProductFooterView : UICollectionReusableView
@property (nonatomic, weak) id<QMBuyProductFooterViewDelegate> delegate;
@property (nonatomic, strong) UIButton *checkBox;

- (void)setProductName:(NSString *)name;

@end

@protocol QMBuyProductFooterViewDelegate <NSObject>

- (void)didSelectConfirmBtn:(UIButton *)btn;

- (void)didSelectPrincipleBtn:(UIButton *)btn;

@end
