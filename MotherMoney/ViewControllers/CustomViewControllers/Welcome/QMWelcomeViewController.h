//
//  QMWelcomeViewController.h
//  MotherMoney

#import "QMViewController.h"

//欢迎页
@interface QMWelcomeViewController : QMViewController {
    UIScrollView *scrollView;
    UIPageControl *control;
    BOOL showStart;
}
@property (nonatomic,retain)    UIScrollView *scrollView;
@property (nonatomic,retain)    UIPageControl *control;

-(id)initWithStart:(BOOL) show;

@end

