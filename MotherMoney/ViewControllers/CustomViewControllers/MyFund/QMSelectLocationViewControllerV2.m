//
//  QMSelectLocationViewControllerV2.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/5.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMSelectLocationViewControllerV2.h"

@interface QMSelectLocationViewControllerV2 ()

@end

@implementation QMSelectLocationViewControllerV2

- (id)initViewControllerWithType:(QMSelectLocationTypeV2)type {
    if (self = [super init]) {
        items = [NSArray array];
        self.currentType = type;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initDataSource {
    [super initDataSource];
    
    if (self.currentType == QMSelectLocationTypeV2_Province) {
        // 获取省列表
        [[NetServiceManager sharedInstance] getProvinceListWithDelegate:self success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *array = [responseObject objectForKey:@"list"];
                NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *dict in array) {
                    QMSearchItem *item = [[QMSearchItem alloc] init];
                    item.itemTitle = [dict objectForKey:@"name"];
                    item.itemCode = [NSString stringWithFormat:@"%@", [dict objectForKey:@"code"]];
                    item.itemId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
                    [tmpArray addObject:item];
                }
                
                items = [NSArray arrayWithArray:tmpArray];
            }

            [self reloadData];
        } failure:^(NSError *error) {
            [CMMUtility showNoteWithError:error];
        }];
    }else if (self.currentType == QMSelectLocationTypeV2_City) {
        // 获取城市列表
        [[NetServiceManager sharedInstance] getCityListWithProvinceCode:self.provinceCode
                                                               delegate:self success:^(id responseObject) {
                                                                   if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                                       NSArray *array = [responseObject objectForKey:@"list"];
                                                                       NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
                                                                       for (NSDictionary *dict in array) {
                                                                           QMSearchItem *item = [[QMSearchItem alloc] init];
                                                                           item.itemTitle = [dict objectForKey:@"name"];
                                                                           item.itemCode = [NSString stringWithFormat:@"%@", [dict objectForKey:@"code"]];
                                                                           item.itemId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
                                                                           item.provinceId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"provinceId"]];
                                                                           [tmpArray addObject:item];
                                                                       }
                                                                       
                                                                       items = [NSArray arrayWithArray:tmpArray];
                                                                   }
                                                                   [self reloadData];
                                                               } failure:^(NSError *error) {
                                                                   [CMMUtility showNoteWithError:error];
                                                               }];
    }
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

- (void)onBack {
    if (self.isModel) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    NSString *navTitle = nil;
    if (self.currentType == QMSelectLocationTypeV2_City) {
        navTitle = QMLocalizedString(@"qm_select_city_nav_title", @"选择城市");
    }else if (self.currentType == QMSelectLocationTypeV2_Province) {
        navTitle = QMLocalizedString(@"qm_select_state_nav_title", @"选择省份");
    }
    
    return navTitle;
}

@end

