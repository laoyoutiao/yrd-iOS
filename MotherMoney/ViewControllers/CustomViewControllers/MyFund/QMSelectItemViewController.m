//
//  QMSelectItemViewController.m
//  MotherMoney
#import "QMSelectItemViewController.h"

#define kSearchResultsTableViewTag 30001
#define kAroundLocationsTableViewTag 30002

@interface QMSelectItemViewController ()<UISearchDisplayDelegate, UISearchBarDelegate>

@end

@implementation QMSelectItemViewController {
    UISearchDisplayController *searchDisplayController;
    UITableView *itemsTable;
    UISearchBar *mSearchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDataSource];
    [self initSearchViews];
    [self setUpTableView];
}

- (void)initDataSource {
    
}

- (void)setUpTableView {
    itemsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mSearchBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(mSearchBar.frame)) style:UITableViewStylePlain];
    itemsTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    itemsTable.tag = kAroundLocationsTableViewTag;
    itemsTable.delegate = self;
    itemsTable.dataSource = self;
    [self.view addSubview:itemsTable];
}

- (void)reloadData {
    if (searchDisplayController.isActive) {
        [searchDisplayController.searchResultsTableView reloadData];
    }else {
        [itemsTable reloadData];
    }
}

- (void)initSearchViews {
    mSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    mSearchBar.placeholder = QMLocalizedString(@"qm_search_item_placeholder", @"搜索");
    mSearchBar.delegate = self;
    mSearchBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:mSearchBar];
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mSearchBar contentsController:self];
    searchDisplayController.searchResultsTableView.tag = kSearchResultsTableViewTag;
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
}

#pragma mark -
#pragma mark UISearchDisplayDelegate
// called when the table is created destroyed, shown or hidden. configure as necessary.
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    searchDisplayController.searchResultsTableView.tag = kSearchResultsTableViewTag;
}

- (void)searchItemsWithKeyWord:(NSString *)keyWord {
//    searchResults = [NSArray arrayWithArray:arrPlaceMarks];
    [searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark -
#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchItemsWithKeyWord:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchItemsWithKeyWord:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [searchDisplayController setActive:NO animated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == kSearchResultsTableViewTag) {
        //返回搜索的列表
        return [searchResults count];
    }else if (tableView.tag == kAroundLocationsTableViewTag) {
        //返回location银行列表
        return items.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    if (tableView.tag == kAroundLocationsTableViewTag) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        
        if (indexPath.row < [items count]) {
            QMSearchItem *item = [items objectAtIndex:indexPath.row];
            cell.textLabel.text = item.itemTitle;
            cell.detailTextLabel.text = item.itemSubTitle;
        }
        
        return cell;
    }else if (tableView.tag == kSearchResultsTableViewTag) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        
        if (indexPath.row < [searchResults count]) {
            QMSearchItem *item = [searchResults objectAtIndex:indexPath.row];
            cell.textLabel.text = item.itemTitle;
            cell.detailTextLabel.text = item.itemSubTitle;
        }
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QMSearchItem *item = nil;
    if (tableView.tag == kSearchResultsTableViewTag) {
        if (indexPath.row < [searchResults count]) {
            item = [searchResults objectAtIndex:indexPath.row];
        }
    }else if (tableView.tag == kAroundLocationsTableViewTag) {
        if (indexPath.row < [items count]) {
            item = [items objectAtIndex:indexPath.row];
        }
    }
    
    if (QM_IS_DELEGATE_RSP_SEL(self.delegate, viewController:didSelectItem: )) {
        [self.delegate viewController:self didSelectItem:item];
    }
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

@end
