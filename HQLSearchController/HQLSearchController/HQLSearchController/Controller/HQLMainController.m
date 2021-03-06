//
//  HQLMainController.m
//  HQLSearchController
//
//  Created by 何启亮 on 2017/5/17.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "HQLMainController.h"
#import "HQLSearchController.h"
#import "HQLSearchBar.h"

#import "HQLSearchTagView.h"

#define HQLSearchHistorySaveKey @"HQLSearchHistorySaveKey"
#define HQLSearchHistoryTagViewTitle @"搜索记录"

@interface HQLMainController ()<UISearchBarDelegate, HQLSearchControllerDelegate>

@property (strong, nonatomic) HQLSearchBar *searchBar;
@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UINavigationController *searchNavigationController;
@property (strong, nonatomic) HQLSearchController *searchController;

@property (strong, nonatomic) NSMutableArray <NSString *>*searchResultArray; // 搜索结果

@property (strong, nonatomic) NSMutableArray <NSString *>*searchHistory; // 搜索历史

@property (strong, nonatomic) NSMutableArray <HQLSearchTagComponentModel *>*tagViewDataSource;

@property (strong, nonatomic) UIButton *removeSearchHistoryButton; // 删除搜索历史的button

@end

@implementation HQLMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self controllerConfing];
}

#pragma mark - event

- (void)controllerConfing {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self searchBar];
    [self imageView];
    [self tagViewDataSourceConfig];
}

- (void)saveSearchHistory {
    [[NSUserDefaults standardUserDefaults] setObject:self.searchHistory forKey:HQLSearchHistorySaveKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)tagViewDataSourceConfig {
    if (self.searchHistory.count != 0) { // 表示有历史记录
        HQLSearchTagComponentModel *model = [[HQLSearchTagComponentModel alloc] init];
        model.dataSource = self.searchHistory;
        model.title = HQLSearchHistoryTagViewTitle;
        model.titleRightCustomView = self.removeSearchHistoryButton;
        [self.tagViewDataSource addObject:model];
    }
    
    HQLSearchTagComponentModel *model = [[HQLSearchTagComponentModel alloc] init];
    model.dataSource = @[@"这是第二个tagView", @"第一个button", @"第二个button"];
    model.title = @"这是一个测试";
    [self.tagViewDataSource addObject:model];
}

- (void)removeSearchHistoryButtonDidClick:(UIButton *)button {
    NSLog(@"清除历史");
    [self removeSearchHistory];
    [self.tagViewDataSource removeObjectAtIndex:0];
    self.searchController.tagViewDataSource = self.tagViewDataSource;
}

- (void)removeSearchHistory {
    [self.searchHistory removeAllObjects];
    [self saveSearchHistory];
}

#pragma mark - searchBar delegate

// searchBar 开始编辑
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    HQLSearchController *controller = [HQLSearchController new];
    controller.delegate = self;
    controller.tagViewDataSource = self.tagViewDataSource;
    self.searchController = controller;
    self.searchNavigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    __weak typeof(self) weakSelf = self;
    [controller showInViewController:self searchBarOriginPoint:self.searchBar.frame.origin duringAnimation:^{
        weakSelf.searchBar.frame = CGRectMake(0, 0, weakSelf.view.frame.size.width, 44);
    }];
    return NO;
}

#pragma mark - search controller delegate

- (void)searchController:(HQLSearchController *)searchController didSearchWithKeyWord:(NSString *)keyWord {
    [self.searchResultArray removeAllObjects];
    NSInteger randomNum = arc4random_uniform(10);
    for (int i = 0; i < randomNum; i++) {
        [self.searchResultArray addObject:[NSString stringWithFormat:@"search result %d", i]];
    }
    // 两秒之后
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [searchController setSearchResultWithResultArray:weakSelf.searchResultArray];
    });
}

- (void)searchController:(HQLSearchController *)searchController searchBarCancelButtonDidClick:(HQLSearchBar *)searchBar {
    __weak typeof(self) weakSelf = self;
    [searchController hideControllerWithDuringAnimationBlock:^{
        weakSelf.searchBar.frame = CGRectMake(0, 64, weakSelf.view.frame.size.width, 44);
    } completeBlock:^{
        weakSelf.searchNavigationController = nil;
        weakSelf.searchController = nil;
    }];
}

- (void)searchController:(HQLSearchController *)searchController searchTagView:(HQLSearchTagView *)searchTagView didClickTagButton:(NSIndexPath *)indexPath {
    HQLSearchTagComponentModel *model = self.tagViewDataSource[indexPath.section];
    // 如果第一个是搜索历史
    if ([model.title isEqualToString:HQLSearchHistoryTagViewTitle]) {
        [searchController searchWithSearchText:model.dataSource[indexPath.row]];
    } else { // 其他
        NSLog(@"click tag view button : %@", model.dataSource[indexPath.row]);
    }
}

// 点击了结果
- (void)searchController:(HQLSearchController *)searchController resultView:(UITableView *)resultView didSelectedResultViewCell:(NSIndexPath *)indexPath{
    NSLog(@"did click result : %@", self.searchResultArray[indexPath.row]);
}

// 点击了搜索
- (void)searchController:(HQLSearchController *)searchController searchBarDidClickSearchButton:(HQLSearchBar *)searchBar {
    // 保存searchBar.text
    NSString *deleString = nil;
    for (NSString *string in self.searchHistory) {
        if ([searchBar.text isEqualToString:string]) {
            deleString = string;
            break;
        }
    }
    if (deleString) {
        [self.searchHistory removeObject:deleString];
    }
    
    [self.searchHistory insertObject:searchBar.text atIndex:0];
    [self saveSearchHistory];
    
    if (self.searchHistory.count == 1) {
        HQLSearchTagComponentModel *model = [[HQLSearchTagComponentModel alloc] init];
        model.dataSource = self.searchHistory;
        model.title = HQLSearchHistoryTagViewTitle;
        model.titleRightCustomView = self.removeSearchHistoryButton;
        [self.tagViewDataSource insertObject:model atIndex:0];
    }
    
    searchController.tagViewDataSource = self.tagViewDataSource;
}

#pragma mark - getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [_imageView setImage:[UIImage imageNamed:@"yangzhuzhifu"]];
        
        [self.view insertSubview:_imageView atIndex:0];
    }
    return _imageView;
}

- (HQLSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[HQLSearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        [_searchBar setShowsCancelButton:NO animated:NO];
        
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

- (NSMutableArray<NSString *> *)searchHistory {
    if (!_searchHistory) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:HQLSearchHistorySaveKey];
        if ([array isKindOfClass:[NSArray class]] && array) { // 不为空
            _searchHistory = [NSMutableArray arrayWithArray:array];
        } else {
            _searchHistory = [NSMutableArray array];
        }
    }
    return _searchHistory;
}

-(NSMutableArray<HQLSearchTagComponentModel *> *)tagViewDataSource {
    if (!_tagViewDataSource) {
        _tagViewDataSource = [NSMutableArray array];
    }
    return _tagViewDataSource;
}

- (UIButton *)removeSearchHistoryButton {
    if (!_removeSearchHistoryButton) {
        _removeSearchHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removeSearchHistoryButton setTitle:@"清除搜索记录" forState:UIControlStateNormal];
        [_removeSearchHistoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_removeSearchHistoryButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_removeSearchHistoryButton sizeToFit];
        [_removeSearchHistoryButton addTarget:self action:@selector(removeSearchHistoryButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeSearchHistoryButton;
}

- (NSMutableArray<NSString *> *)searchResultArray {
    if (!_searchResultArray) {
        _searchResultArray = [NSMutableArray array];
    }
    return _searchResultArray;
}

@end
