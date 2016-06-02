//
//  QMGoodsListViewController.h
//  MotherMoney
//

#import "QMViewController.h"
#import "QMPullRefreshViewController.h"

//我的钱豆
@interface QMGoodsListViewController : QMPullRefreshViewController
@property (nonatomic,strong)NSString* currentScoreValue;
@property (nonatomic,strong)UIButton* buyMoneybeanBtn;
@end
