//
//  QMBankBranchInfoViewController.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/14.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMBankBranchInfoViewController.h"
#import "QMBankBranchInfoCell.h"

@interface QMBankBranchInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation QMBankBranchInfoViewController {
    NSString *searchKey;
    NSString *mCityCode;
    NSString *mCardNumber;
    UITableView *searchResultTable;
    NSArray *searchResultArray;
}

- (id)initViewControllerWithKeyWord:(NSString *)keyword cardNumber:(NSString *)cardNumber cityCode:(NSString *)cityCode {
    if (self = [super init]) {
        searchKey = keyword;
        mCityCode = cityCode;
        mCardNumber = cardNumber;
        
        items = [NSArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDataSource];
}

- (UIBarButtonItem *)leftBarButtonItem {
    return [QMNavigationBarItemFactory createNavigationBackItemWithTarget:self selector:@selector(goBack)];
}

- (void)goBack {
    if (self.isModel) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setUpSubViews {
    searchResultTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    searchResultTable.dataSource = self;
    searchResultTable.delegate = self;
    [self.view addSubview:searchResultTable];
    [searchResultTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
}

- (void)initDataSource {
    [super initDataSource];
    [[NetServiceManager sharedInstance] getBankBranchInfoWithCardNumber:mCardNumber branchName:searchKey cityCode:mCityCode delegate:self success:^(id responseObject) {
        if (!QM_IS_DICT_NIL(responseObject)) {
            NSArray *list = [responseObject objectForKey:@"list"];
            if (!QM_IS_ARRAY_NIL(list)) {
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *dict in list) {
                    QMBankBranchInfo *info = [[QMBankBranchInfo alloc] initWithDictionary:dict];
                    info.itemTitle = info.branchName;
                    [array addObject:info];
                }
                
                items = [NSArray arrayWithArray:array];
            }
        }
        
        // 刷新界面
        [self reloadData];
    } failure:^(NSError *error) {
        [CMMUtility showNoteWithError:error];
    }];
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


- (NSString *)title {
    return QMLocalizedString(@"qm_bank_branch_info_nav_title", @"支行信息");
}

@end
