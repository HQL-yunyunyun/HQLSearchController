//
//  HQLSearchController.h
//  HQLSearchController
//
//  Created by weplus on 2017/3/29.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQLSearchController, HQLSearchTagComponentModel, HQLSearchTagView, HQLSearchBar;

@protocol HQLSearchControllerDelegate <NSObject>

/**
 根据keyWord搜索

 @param keyWord keyWord
 @return result
 */
- (NSArray <NSString *>*)searchControllerDidSearchWithKeyWord:(NSString *)keyWord;

/**
 按下取消键
 */
- (void)searchController:(HQLSearchController *)searchController searchBarCancelButtonDidClick:(HQLSearchBar *)searchBar;

// 点击的button
- (void)searchController:(HQLSearchController *)searchController searchTagView:(HQLSearchTagView *)searchTagView didClickTagButton:(NSIndexPath *)indexPath;

// 点击了结果
- (void)searchController:(HQLSearchController *)searchController resultView:(UITableView *)resultView didSelectedResultViewCell:(NSIndexPath *)indexPath;

// 点击了搜索
- (void)searchController:(HQLSearchController *)searchController searchBarDidClickSearchButton:(HQLSearchBar *)searchBar ;

@end

@interface HQLSearchController : UIViewController

@property (copy, nonatomic) NSString *searchCancelButtonTitle;
@property (copy, nonatomic) NSString *searchBarPlaceholder;
@property (strong, nonatomic) UIImage *searchBarIcon;
@property (strong, nonatomic) UIView *searchBarRightCustomView;
@property (assign, nonatomic) UIReturnKeyType searchBarReturnKeyType;

// 搜索结果的显示
@property (strong, nonatomic, readonly) NSMutableArray *searchResultArray;

@property (strong, nonatomic) NSArray <HQLSearchTagComponentModel *>*tagViewDataSource;

@property (assign, nonatomic) id <HQLSearchControllerDelegate>delegate;

// 设置搜索array
- (void)setSearchResultWithResultArray:(NSMutableArray *)resultArray;

// 显示Controller
- (void)showInViewController:(UIViewController *)controller duringAnimation:(void(^)())duringAnimationBlock;
- (void)hideControllerWithDuringAnimationBlock:(void(^)())duringAnimationBlock completeBlock:(void(^)())completeBlock;

@end
