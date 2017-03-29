//
//  HQLSearchController.m
//  HQLSearchController
//
//  Created by weplus on 2017/3/29.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "HQLSearchController.h"
#import "HQLSearchBar.h"
#import "HQLSearchTagView.h"

#import "UIView+General.h"

#define kResultTableViewCellID @"kRestultTableViewCellID"

#define kTableViewCellHeight 44
#define kSearchBarHeight 44

@interface HQLSearchController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, HQLSearchTagViewDelegate>

@property (strong, nonatomic) HQLSearchBar *searchBar;
@property (strong, nonatomic) UITableView *resultView;
//@property (strong, nonatomic) UIVisualEffectView *backgroundView;
@property (strong, nonatomic) HQLSearchTagView *tagView;

@property (strong, nonatomic) NSMutableArray <NSString *>*resultArray;

@end

@implementation HQLSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - event

#pragma mark - search bar delegate

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kResultTableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kResultTableViewCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.resultArray[indexPath.row];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(searchController:resultView:didSelectedResultViewCell:)]) {
        [self.delegate searchController:self resultView:tableView didSelectedResultViewCell:indexPath];
    }
}

#pragma mark - getter

- (HQLSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[HQLSearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kSearchBarHeight)];
        [_searchBar setShowsCancelButton:YES animated:YES];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)resultView {
    if (!_resultView) {
        _resultView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _resultView.delegate = self;
        _resultView.dataSource = self;
        [_resultView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:_resultView];
    }
    return _resultView;
}

- (HQLSearchTagView *)tagView {
    if (!_tagView) {
        _tagView = [[HQLSearchTagView alloc] initWithFrame:self.view.bounds];
        _tagView.delegate = self;
        [self.view insertSubview:_tagView atIndex:0];
    }
    return _tagView;
}

#pragma mark - setter

- (void)setTagViewDataSource:(NSArray<HQLSearchTagComponentModel *> *)tagViewDataSource {
    _tagViewDataSource = tagViewDataSource;
    [self.tagView setComponentsDataSource:tagViewDataSource];
}

- (void)setSearchBarIcon:(UIImage *)searchBarIcon {
    _searchBarIcon = searchBarIcon;
    [self.searchBar setImage:searchBarIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
}

- (void)setSearchBarPlaceholder:(NSString *)searchBarPlaceholder {
    _searchBarPlaceholder = searchBarPlaceholder;
    [self.searchBar setPlaceholder:searchBarPlaceholder];
}

- (void)setSearchBarReturnKeyType:(UIReturnKeyType)searchBarReturnKeyType {
    _searchBarReturnKeyType = searchBarReturnKeyType;
    [self.searchBar setReturnKeyType:searchBarReturnKeyType];
}

- (void)setSearchBarRightCustomView:(UIView *)searchBarRightCustomView {
    _searchBarRightCustomView = searchBarRightCustomView;
    [self.searchBar setRightCustomView:searchBarRightCustomView];
}

- (void)setSearchCancelButtonTitle:(NSString *)searchCancelButtonTitle {
    _searchCancelButtonTitle = searchCancelButtonTitle;
    [self.searchBar setCancelButtonTitle:searchCancelButtonTitle];
}

@end
