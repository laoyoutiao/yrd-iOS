//
//  QMSelectLocationViewController.m
//  MotherMoney


#import "QMSelectLocationViewController.h"

@interface QMSelectLocationViewController ()

@end

@implementation QMSelectLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)onBack {
    if (self.isModel) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIBarButtonItem *)leftBarButtonItem {
    return [QMNavigationBarItemFactory createNavigationBackItemWithTarget:self selector:@selector(onBack)];
}

- (id)initViewControllerWithItems:(NSArray *)originItems
                             type:(QMSelectLocationType)type {
    if (self = [super init]) {
        items = [NSArray arrayWithArray:originItems];
        self.currentType = type;
    }
    
    return self;
}

- (void)searchItemsWithKeyWord:(NSString *)keyWord {
    if (QM_IS_STR_NIL(keyWord)) {
        return;
    }
    
    __block NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:0];
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (nil != obj) {
            QMSearchItem *item = (QMSearchItem *)obj;
            if ([item isKindOfClass:[QMSearchItem class]]) {
                if (!QM_IS_STR_NIL(item.itemTitle) && [item.itemTitle rangeOfString:keyWord].location != NSNotFound) {
                    [results addObject:item];
                }
            }
            
            searchResults = [NSArray arrayWithArray:results];
        }else {
            [self reloadData];
        }
    }];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    NSString *navTitle = nil;
    if (self.currentType == QMSelectLocationType_City) {
        navTitle = QMLocalizedString(@"qm_select_city_nav_title", @"选择城市");
    }else if (self.currentType == QMSelectLocationType_Province) {
        navTitle = QMLocalizedString(@"qm_select_state_nav_title", @"选择省份");
    }
    
    return navTitle;
}

@end
