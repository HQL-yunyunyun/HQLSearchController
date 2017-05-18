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

@interface HQLMainController ()<UISearchBarDelegate, HQLSearchControllerDelegate>

@property (strong, nonatomic) HQLSearchBar *searchBar;
@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UINavigationController *searchController;

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
}

#pragma mark - searchBar delegate

// searchBar 开始编辑
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    HQLSearchController *controller = [HQLSearchController new];
//    controller.delegate = self;
//    self.searchController = [[UINavigationController alloc] initWithRootViewController:controller];
//    __weak typeof(self) weakSelf = self;
//    [controller showInViewController:self searchBarOriginPoint:self.searchBar.frame.origin duringAnimation:^{
//        weakSelf.searchBar.frame = CGRectMake(0, 0, weakSelf.view.frame.size.width, 44);
//    }];
    return YES;
}

#pragma mark - search controller delegate

- (NSArray<NSString *> *)searchControllerDidSearchWithKeyWord:(NSString *)keyWord {
    return @[@"ye"];
}

- (void)searchController:(HQLSearchController *)searchController searchBarCancelButtonDidClick:(HQLSearchBar *)searchBar {
    __weak typeof(self) weakSelf = self;
    [searchController hideControllerWithDuringAnimationBlock:^{
        weakSelf.searchBar.frame = CGRectMake(0, 64, weakSelf.view.frame.size.width, 44);
        [weakSelf.searchBar becomeFirstResponder];
//        [weakSelf.view layoutIfNeeded];
    } completeBlock:^{
        [weakSelf.searchBar resignFirstResponder];
        weakSelf.searchController = nil;
    }];
}

- (void)searchController:(HQLSearchController *)searchController searchTagView:(HQLSearchTagView *)searchTagView didClickTagButton:(NSIndexPath *)indexPath {

}

// 点击了结果
- (void)searchController:(HQLSearchController *)searchController resultView:(UITableView *)resultView didSelectedResultViewCell:(NSIndexPath *)indexPath{

}

// 点击了搜索
- (void)searchController:(HQLSearchController *)searchController searchBarDidClickSearchButton:(HQLSearchBar *)searchBar {

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
        [_searchBar setShowsCancelButton:YES animated:YES];
        
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

@end
