//
//  QMMessageCenterViewController.m
//  MotherMoney
//
//  Created by   on 14-8-9.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMMessageCenterViewController.h"
#import "QMMessageInfo.h"
#import "QMMessageCell.h"
#import "MoreViewController.h"

@interface QMMessageCenterViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation QMMessageCenterViewController {
    NSMutableArray *messageList;
    UITableView *messageListTable;
    QMPageFooterView *footer;
    
    BOOL isAllDataLoaded;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initDataSource];
}

- (void)initDataSource {
    messageList = [[NSMutableArray alloc] initWithCapacity:0];
    [self asyncFetchMessageListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
}

#pragma mark -
#pragma mark Override mthoeds
- (UIScrollView *)customScrollView {
    messageListTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    messageListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    messageListTable.delegate = self;
    messageListTable.dataSource = self;
    [self.view addSubview:messageListTable];
    
    footer = [[QMPageFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), 50.0f)];
    footerLoadingState = QMPageFootViewNormalState;
    [footer setQMPageFootViewState:footerLoadingState];
    footView = footer;
    
    messageListTable.tableFooterView = footer;
    
    return messageListTable;
}

- (void)updateTableFooterView {
    if (QM_IS_ARRAY_NIL(messageList)) {
        messageListTable.tableFooterView = nil;
    }else {
        messageListTable.tableFooterView = footView;
        [footView setQMPageFootViewState:footerLoadingState];
    }
}

- (void)asyncFetchMessageListWithOffset:(NSInteger)offset pageSize:(NSInteger)pageSize {
    [[NetServiceManager sharedInstance] messageCenterListWithPageSize:[NSNumber numberWithInteger:pageSize]
                                                           pageNumber:[NSNumber numberWithInteger:offset]
                                                             delegate:self
                                                              success:^(id responseObject) {
                                                                  // add objects
                                                                  if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                                      NSArray *msgs = [responseObject objectForKey:kNetWorkList];
                                                                      if (offset == 1) {
                                                                          isAllDataLoaded = NO;
                                                                          [messageList removeAllObjects];
                                                                          // 得到第一页，更新数据
                                                                          NSString *lastMessage = [QMPreferenceUtil getGlobalKey:MESSAGE_LAST_UPDATE_TIME];
                                                                          [QMPreferenceUtil setGlobalKey:MESSAGE_LAST_READ_TIME value:lastMessage syncWrite:YES];
                                                                      }
                                                                      
                                                                      if ([msgs isKindOfClass:[NSArray class]]) {
                                                                          if ([msgs count] < QM_FETCH_PAGE_SIZE) {
                                                                              isAllDataLoaded = YES;
                                                                          }
                                                                          
                                                                          for (NSDictionary *dict in msgs) {
                                                                              QMMessageInfo *info = [[QMMessageInfo alloc] initWithDictionary:dict];
                                                                              [messageList addObject:info];
                                                                          }
                                                                      }
                                                                  }
                                                                  
                                                                  [self doneLoadingTableViewData];
                                                              } failure:^(NSError *error) {
                                                                  [self doneLoadingTableViewData];
                                                              }];
}

- (void)reloadData {
    [messageList removeAllObjects];
    [self asyncFetchMessageListWithOffset:1 pageSize:QM_FETCH_PAGE_SIZE];
}

- (void)doneLoadingTableViewData {
    [super doneLoadingTableViewData];
    [(UICollectionView *)self.scrollView reloadData];
    [self updateTableFooterView];
    if (QM_IS_ARRAY_NIL(messageList)) {
        [self showEmptyView];
    }else {
        [self hideEmptyView];
    }
}

- (void)didTriggerLoadNextPageData {
    if ([self isAllDataLoaded]) {
        return;
    }
    NSInteger pageNumber = [messageList count] / QM_FETCH_PAGE_SIZE + 1;
    [self asyncFetchMessageListWithOffset:pageNumber pageSize:QM_FETCH_PAGE_SIZE];
}

- (BOOL)isAllDataLoaded {
    return isAllDataLoaded;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [messageList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *messageCellIdentifier = @"messageCellIdentifier";
    QMMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCellIdentifier];
    if (nil == cell) {
        cell = [[QMMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    QMMessageInfo *info = nil;
    if (indexPath.row < [messageList count]) {
        info = [messageList objectAtIndex:indexPath.row];
    }
    
    [cell configureCellWithMessage:info];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMMessageInfo *info = nil;
    if (indexPath.row < [messageList count]) {
        info = [messageList objectAtIndex:indexPath.row];
    }
    
    return [QMMessageCell getCellHeightForMessage:info];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_more_message_center_title", @"消息中心");
}

@end
