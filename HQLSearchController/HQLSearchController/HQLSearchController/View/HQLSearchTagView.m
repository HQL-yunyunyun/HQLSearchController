//
//  HQLSearchTagView.m
//  HQLSearchController
//
//  Created by weplus on 2017/3/28.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "HQLSearchTagView.h"
#import "HQLSearchTagComponentCell.h"
#import "UIView+General.h"

#define kSearchTagComponentCellID @"kSearchTagComponentCellID"

@interface HQLSearchTagView () <UITableViewDelegate, UITableViewDataSource, HQLSearchTagComponentCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

// 毛玻璃
//@property (strong, nonatomic) UIVisualEffectView *effectView;

@end

@implementation HQLSearchTagView

#pragma mark - life cycle 

- (instancetype)init {
    if (self = [super init]) {
        [self prepareConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self prepareConfig];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    CGFloat originWidth = self.width;
    [super setFrame:frame];
    if (originWidth != self.width) {
        [self calculateFrame];
    }
}

- (void)prepareConfig {
    [self tableView];
//    [self effectView];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
}

- (void)dealloc {
    NSLog(@"dealloc ---> %@", NSStringFromClass([self class]));
}

#pragma mark - search tag component cell delegate

- (void)searchTagComponentCell:(HQLSearchTagComponentCell *)cell didClickButton:(NSInteger)index {
    NSInteger section = [self.tableView indexPathForCell:cell].row;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
    if ([self.hql_delegate respondsToSelector:@selector(searchTagView:didClickButton:)]) {
        [self.hql_delegate searchTagView:self didClickButton:indexPath];
    }
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HQLSearchTagComponentModel *model = self.componentsDataSource[indexPath.row];
    return model.viewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001;
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.componentsDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HQLSearchTagComponentCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchTagComponentCellID];
    if (!cell) {
        cell = [[HQLSearchTagComponentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSearchTagComponentCellID];
    }
    cell.model = self.componentsDataSource[indexPath.row];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

#pragma mark - event

- (HQLSearchTagButton *)buttonOfIndex:(NSIndexPath *)indexPath {
    HQLSearchTagComponentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    return [cell buttonOfIndex:indexPath.row];
}

- (void)calculateFrame {
//    self.effectView.frame = self.bounds;
    
    self.tableView.width = self.width;
    
    CGFloat tableViewHeight = 0;
    for (HQLSearchTagComponentModel *model in self.componentsDataSource) {
        [model calculateFrameWithCellWidth:self.width];
        tableViewHeight += model.viewHeight;
    }
    self.tableView.height = tableViewHeight;
    // 判断tableViewHeight是否大于self.height
    CGFloat contentHeight = tableViewHeight > self.height ? tableViewHeight : (self.height +  1);
    self.contentSize = CGSizeMake(self.contentSize.width, contentHeight);
}

#pragma mark - setter

- (void)setComponentsDataSource:(NSArray<HQLSearchTagComponentModel *> *)componentsDataSource {
    _componentsDataSource = componentsDataSource;
    [self.tableView reloadData];
    [self calculateFrame];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HQLSearchTagComponentCell class] forCellReuseIdentifier:kSearchTagComponentCellID];
        [self addSubview:_tableView];
    }
    return _tableView;
}

//- (UIVisualEffectView *)effectView {
//    if (!_effectView) {
//        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
//        [self insertSubview:_effectView atIndex:0];
//    }
//    return _effectView;
//}

@end

#define kDefaultCellWidth [UIScreen mainScreen].bounds.size.width

@implementation HQLSearchTagComponentModel

- (instancetype)init {
    if (self = [super init]) {
        self.borderStyle = HQLSearchTagButtonRoundedStyle;
        self.buttonBorderColor = nil;
        self.buttonBackgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1];
        self.buttonTitleColor = [UIColor blackColor];
        self.buttonFont = [UIFont systemFontOfSize:14];
        self.buttonMaxWidth = 200;
        self.buttonHeight = 25;
        self.titleColor = [UIColor blackColor];
        self.titleFont = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setDataSource:(NSArray<NSString *> *)dataSource {
    _dataSource = dataSource;
    [self calculateFrameWithCellWidth:kDefaultCellWidth];
}

- (void)setButtonMaxWidth:(CGFloat)buttonMaxWidth {
    BOOL isNeedToRefreshViewHeight = NO;
    if (self.buttonMaxWidth != buttonMaxWidth && self.dataSource.count != 0 && self.dataSource && self.buttonHeight != 0) {
        isNeedToRefreshViewHeight = YES;
    }
    _buttonMaxWidth = buttonMaxWidth;
    
    if (isNeedToRefreshViewHeight) {
        [self calculateFrameWithCellWidth:kDefaultCellWidth];
    }
}

- (void)setButtonHeight:(CGFloat)buttonHeight {
    BOOL isNeedToRefreshViewHeight = NO;
    
    if (self.buttonHeight != buttonHeight && self.dataSource.count != 0 && self.dataSource && self.buttonMaxWidth != 0) {
        isNeedToRefreshViewHeight = YES;
    }
    
    _buttonHeight = buttonHeight;
    
    if (isNeedToRefreshViewHeight) {
        [self calculateFrameWithCellWidth:kDefaultCellWidth];
    }
}

- (void)calculateFrameWithCellWidth:(CGFloat)width {
    HQLSearchTagComponentCell *cell = [[HQLSearchTagComponentCell alloc] initWithFrame:CGRectMake(0, 0, width, 100)];
    cell.model = self;
    [cell calculateFrame];
    _viewHeight = cell.viewHeight;
}

@end
