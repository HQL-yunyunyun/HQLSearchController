//
//  HQLSearchTagButton.m
//  HQLSearchController
//
//  Created by weplus on 2017/3/28.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "HQLSearchTagButton.h"
#import "UIView+General.h"

@implementation HQLSearchTagButton

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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.width = self.width - 2 * kTagButtonMargin;
    self.titleLabel.x = kTagButtonMargin;
    self.titleLabel.centerY = self.height * 0.5;
}

- (void)setFrame:(CGRect)frame {
    CGFloat originHeight = self.height;
    [super setFrame:frame];
    if (originHeight != self.height) {
        [self setBorderStyle:self.borderStyle];
    }
}

#pragma mark - prepare config

- (void)prepareConfig {
    [self setButtonBorderColor:nil];
    [self setBorderStyle:HQLSearchTagButtonRoundedStyle];
}

#pragma mark - setter

- (void)setBorderStyle:(HQLSearchTagButtonBorderStyle)borderStyle {
    _borderStyle = borderStyle;
    CGFloat cornerRadius = 0;
    switch (borderStyle) {
        case HQLSearchTagButtonRectStyle: {
            cornerRadius = 0;
            break;
        }
        case HQLSearchTagButtonRoundedStyle: {
            cornerRadius = self.height * 0.5;
            break;
        }
    }
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setButtonBorderColor:(UIColor *)buttonBorderColor {
    _buttonBorderColor = buttonBorderColor;
    CGFloat borderWidth = 0;
    if (!buttonBorderColor) {
        borderWidth = 0;
    } else {
        borderWidth = 1;
        self.layer.borderColor = buttonBorderColor.CGColor;
    }
    self.layer.borderWidth = borderWidth;
}

@end
