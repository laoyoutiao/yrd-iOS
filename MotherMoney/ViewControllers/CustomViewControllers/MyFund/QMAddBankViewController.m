//
//  QMSelectBankViewController.m
//  MotherMoney
//

#import "QMAddBankViewController.h"
#import "QMBankInfo.h"

@interface QMAddBankViewController ()

@end

@implementation QMAddBankViewController {
    QMOrderModel *mOrderModel;
}

- (id)initViewControllerWithProduct:(QMOrderModel *)order {
    if (self = [super init]) {
        mOrderModel = order;
    }
    
    return self;
}

- (void)onBack {
    if (self.isModel) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
}

- (void)initDataSource {
    [[NetServiceManager sharedInstance] getAvailableBankListWithProductChannelId:mOrderModel.productChannelId
                                                                        delegate:self
                                                                         success:^(id responseObject) {
                                                                             [self handleProductListSuccess:responseObject];
                                                                         } failure:^(NSError *error) {
                                                                             [self handleProductListFailure:error];
                                                                         }];
}

- (void)handleProductListSuccess:(id)responseObject {
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *bankList = [responseObject objectForKey:kNetWorkList];
    if (![bankList isKindOfClass:[NSArray class]]) {
        return;
    }
    
    for (NSDictionary *dict in bankList) {
        QMBankInfo *info = [[QMBankInfo alloc] initWithDictionary:dict];
        [array addObject:info];
    }

    items = [NSArray arrayWithArray:array];
    [self reloadData];
}

- (void)handleProductListFailure:(NSError *)error {
    [self handleProductListSuccess:nil];
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

- (UIBarButtonItem *)leftBarButtonItem {
    return [QMNavigationBarItemFactory createNavigationBackItemWithTarget:self selector:@selector(onBack)];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_add_bank_card_nav_title", @"添加银行卡");
}

@end
