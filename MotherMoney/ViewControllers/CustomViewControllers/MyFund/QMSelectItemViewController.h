//
//  QMSelectItemViewController.h
//  MotherMoney

#import "QMViewController.h"
#import "QMSearchItem.h"

@protocol QMSelectItemViewControllerDelegate;
@interface QMSelectItemViewController : QMViewController<UITableViewDataSource, UITableViewDelegate> {
    NSArray *searchResults;
    NSArray *items;
}
@property (nonatomic, assign) BOOL isModel;
@property (nonatomic, weak) id <QMSelectItemViewControllerDelegate> delegate;

- (void)initDataSource;

- (void)reloadData;

- (void)searchItemsWithKeyWord:(NSString *)keyWord;

@end

@protocol QMSelectItemViewControllerDelegate <NSObject>

- (void)viewController:(QMSelectItemViewController *)controller didSelectItem:(QMSearchItem *)item;

@end
