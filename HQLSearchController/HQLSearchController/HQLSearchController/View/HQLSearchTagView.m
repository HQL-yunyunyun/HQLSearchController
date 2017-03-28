//
//  HQLSearchTagView.m
//  HQLSearchController
//
//  Created by weplus on 2017/3/28.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "HQLSearchTagView.h"
#import "HQLSearchTagComponentCell.h"

@interface HQLSearchTagView ()

@end

@implementation HQLSearchTagView


@end

@implementation HQLSearchTagComponentModel

- (instancetype)init {
    if (self = [super init]) {
        self.borderStyle = HQLSearchTagButtonRoundedStyle;
        self.buttonBorderColor = nil;
        self.buttonBackgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1];
        self.buttonTitleColor = [UIColor blackColor];
        self.buttonFont = [UIFont systemFontOfSize:14];
        self.buttonMaxWidth = 100;
        self.buttonHeight = 25;
        self.titleColor = [UIColor blackColor];
        self.titleFont = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setDataSource:(NSArray<NSString *> *)dataSource {
    _dataSource = dataSource;
    [self calculateFrame];
}

- (void)setButtonMaxWidth:(CGFloat)buttonMaxWidth {
    BOOL isNeedToRefreshViewHeight = NO;
    if (self.buttonMaxWidth != buttonMaxWidth && self.dataSource.count != 0 && self.dataSource && self.buttonHeight != 0) {
        isNeedToRefreshViewHeight = YES;
    }
    _buttonMaxWidth = buttonMaxWidth;
    
    if (isNeedToRefreshViewHeight) {
        [self calculateFrame];
    }
}

- (void)setButtonHeight:(CGFloat)buttonHeight {
    BOOL isNeedToRefreshViewHeight = NO;
    if (self.buttonHeight != buttonHeight && self.dataSource.count != 0 && self.dataSource && self.buttonMaxWidth != 0) {
        isNeedToRefreshViewHeight = YES;
    }
    
    _buttonHeight = buttonHeight;
    
    if (isNeedToRefreshViewHeight) {
        [self calculateFrame];
    }
}

- (void)calculateFrame {
    HQLSearchTagComponentCell *cell = [[HQLSearchTagComponentCell alloc] init];
    cell.model = self;
    [cell calculateFrame];
    _viewHeight = cell.viewHeight;
}

@end
