//
//  HQLSearchBar.m
//  HQLSearchController
//
//  Created by weplus on 2017/3/28.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "HQLSearchBar.h"

@implementation HQLSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareConfig];
    }
    return self;
}

// 从xib中创建
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self prepareConfig];
    }
    return self;
}

- (void)prepareConfig {
    self.backgroundColor = TEXTFIELD_BACKGROUNDCOLOR;
    self.placeholder = @"搜索";
    self.keyboardType = UIKeyboardTypeDefault;
    self.showsCancelButton = NO; // 取消在一开始显示取消button
    // 删除UISearchBar中的默认背景
    [self setBackgroundImage:[[UIImage alloc] init]];
    self.tintColor = APP_TINT_COLOR;
    [self setCancelButtonTitle:@"取消"];
}

- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle {
    if (!cancelButtonTitle) {
        return;
    }
    _cancelButtonTitle = cancelButtonTitle;
    if (iOS10_OR_LATER) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:cancelButtonTitle];
    } else {
        // iOS10 以下
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:cancelButtonTitle];
    }
}

@end
