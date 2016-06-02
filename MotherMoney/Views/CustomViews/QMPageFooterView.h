//
//  QMPageFooterView.h
//  MotherMoney
//
//

#import <UIKit/UIKit.h>
#import "QMRefreshButton.h"

typedef enum {
    QMPageFootViewNoneState = 0,
    QMPageFootViewNormalState,
    QMPageFootViewLoadingState,
    QMPageFootViewNullDataState,
}QMPageFootViewState;

@interface QMPageFooterView : UICollectionReusableView {
    UILabel *showTitleLabel;
    QMRefreshButton *actInd;
}

- (void)setQMPageFootViewState:(QMPageFootViewState)_state;
-(void)setXMPageFootViewDisplayText:(NSString*)text;
-(void)setActIndState:(BOOL)isStartAnimating;

@end
