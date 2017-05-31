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

#import "UIImage+Color.h"

#define kResultTableViewCellID @"kRestultTableViewCellID"

#define kTableViewCellHeight 44
#define kSearchBarHeight 44

#define kNavigationBarAnimationTime 0.25

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HQLSearchController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, HQLSearchTagViewDelegate>

@property (strong, nonatomic) HQLSearchBar *searchBar;
@property (strong, nonatomic) UITableView *resultView;
@property (strong, nonatomic) HQLSearchTagView *tagView;

@property (strong, nonatomic) UIVisualEffectView *effectView;

@property (strong, nonatomic) UIViewController *targetController;

@property (assign, nonatomic) BOOL isHasNavigationController;
@property (assign, nonatomic) CGPoint originPoint;

@end

@implementation HQLSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self prepareConfig];
}

- (void)dealloc {
    NSLog(@"dealloc ---> %@", NSStringFromClass([self class]));
}

#pragma mark - event

- (void)prepareConfig {
    // readOnly ---> 在这里赋值(getter中不知道为什么不能赋值)
    _searchResultArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor clearColor];
    [self effectView];
    
    if (self.navigationController) {
        self.navigationItem.titleView = self.searchBar;
        self.isHasNavigationController = YES;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:self.searchBar.backgroundColor] forBarMetrics:UIBarMetricsDefault];
    } else {
        [self.view addSubview:self.searchBar];
        self.isHasNavigationController = NO;
    }
}

// search
- (void)searchWithKeyWord:(NSString *)keyWord {
    
    [self.searchResultArray removeAllObjects];
    
    if (keyWord && ![keyWord isEqualToString:@""]) { // 有值且不为空
        [self.tagView setHidden:YES];
        [self.resultView setHidden:NO];
        // 搜索
        if ([self.delegate respondsToSelector:@selector(searchControllerDidSearchWithKeyWord:)]) {
            [self.searchResultArray addObjectsFromArray:[self.delegate searchControllerDidSearchWithKeyWord:keyWord]];
        }
        [self.resultView reloadData];
    } else { // 没值
        [self.tagView setHidden:NO];
        [self.resultView setHidden:YES];
    }
}

// 设置resultArray
- (void)setSearchResultWithResultArray:(NSMutableArray *)resultArray {
    [self.searchResultArray removeAllObjects];
    [self.searchResultArray addObjectsFromArray:resultArray];
    [self.resultView reloadData];
}

- (void)showInViewController:(UIViewController *)controller searchBarOriginPoint:(CGPoint)originPoint duringAnimation:(void(^)())duringAnimationBlock {
    // 因为在这个方法的时候 controller还没有调用didLoad方法，所以一些配置就在这个方法里面调用
    [self prepareConfig];
    self.targetController = controller;
    
    // 改变转场方式
    UIViewController *targetController = controller.navigationController ? controller.navigationController : controller;
    UIViewController *selfController = self.navigationController ? self.navigationController : self;
    [targetController.view addSubview:selfController.view];
//    [targetController addChildViewController:selfController];
    
    /*如果targetController为navigationController 而selfController不是navigationController，那么
     addChildViewController这个操作就会让将selfController添加到当前childController中，self也有了
     navigationController，与事实不符*/
    
    // 改变frame ---> 一般是44
//    CGFloat y = self.originPoint.y;
    if (self.isHasNavigationController) {
        originPoint.y -= 20;
    }
    selfController.view.frame = CGRectMake(selfController.view.x, originPoint.y, selfController.view.width, selfController.view.height);
    if ([targetController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)targetController;
        [nav setNavigationBarHidden:YES animated:YES];
    }
    [UIView animateWithDuration:kNavigationBarAnimationTime animations:^{
        selfController.view.y = 0;
        [self.tagView setAlpha:1];
        if (duringAnimationBlock) {
            duringAnimationBlock();
        }
    } completion:^(BOOL finished) {
        [self.searchBar becomeFirstResponder];
    }];
    
    self.originPoint = originPoint;
}

- (void)hideControllerWithDuringAnimationBlock:(void (^)())duringAnimationBlock completeBlock:(void (^)())completeBlock {
    UIViewController *targetController = self.targetController.navigationController ? self.targetController.navigationController : self.targetController;
    UIViewController *selfController = self.isHasNavigationController ? self.navigationController : self;
    if ([targetController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)targetController;
        [nav setNavigationBarHidden:NO animated:YES];
    }
    [self.searchBar resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        selfController.view.y = self.originPoint.y;
        self.tagView.alpha = 0;
//        self.searchBar.alpha = 0;
        duringAnimationBlock ? duringAnimationBlock() : nil;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.searchBar setAlpha:0];
        } completion:^(BOOL finished) {
            [selfController.view removeFromSuperview];
            [selfController removeFromParentViewController];
            completeBlock ? completeBlock() : nil;
        }];
    }];
}

#pragma mark - search bar delegate

// 点击取消
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if ([self.delegate respondsToSelector:@selector(searchController:searchBarCancelButtonDidClick:)]) {
        [self.delegate searchController:self searchBarCancelButtonDidClick:(HQLSearchBar *)searchBar];
    }
//    [self hideControllerWithDuringAnimationBlock:nil completeBlock:nil];
}

// 点击搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([self.delegate respondsToSelector:@selector(searchController:searchBarDidClickSearchButton:)]) {
        [self.delegate searchController:self searchBarDidClickSearchButton:(HQLSearchBar *)searchBar];
    }
}

/*
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (searchBar == self.searchBar) {
        NSString *targetString = searchBar.text;
        [targetString stringByReplacingCharactersInRange:range withString:text];
        [self searchWithKeyWord:targetString];
    }
    return YES;
}
*/

// searchBar的text改变
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchWithKeyWord:searchText];
}

#pragma mark - search tag view delegate

- (void)searchTagView:(HQLSearchTagView *)searchTagView didClickButton:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(searchController:searchTagView:didClickTagButton:)]) {
        [self.delegate searchController:self searchTagView:searchTagView didClickTagButton:indexPath];
    }
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kResultTableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kResultTableViewCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.searchResultArray[indexPath.row];
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
        _searchBar = [[HQLSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSearchBarHeight)];
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
        [self.view insertSubview:_tagView atIndex:1];
        [_tagView setAlpha:0];
    }
    return _tagView;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc] initWithFrame:self.view.bounds];
        [_effectView setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        [self.view insertSubview:_effectView atIndex:0];
    }
    return _effectView;
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

- (void)setSearchBarBackgroundColor:(UIColor *)searchBarBackgroundColor {
    _searchBarBackgroundColor = searchBarBackgroundColor;
    self.searchBar.backgroundColor = searchBarBackgroundColor;
    if (self.isHasNavigationController) {
//        [self.navigationController.navigationBar setBackgroundColor:searchBarBackgroundColor];
//        [[UINavigationBar appearance] setBackgroundColor:searchBarBackgroundColor];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:searchBarBackgroundColor] forBarMetrics:UIBarMetricsDefault];
    }
}

@end
