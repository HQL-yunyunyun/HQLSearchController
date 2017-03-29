//
//  HQLSearchTagComponentCell.m
//  HQLSearchController
//
//  Created by weplus on 2017/3/28.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "HQLSearchTagComponentCell.h"
#import "HQLSearchTagView.h"
#import "HQLSearchTagButton.h"

#import "UIView+General.h"

#define kTitleViewHeight 45

#define kHorizontalMargin 16 // button 与 View 的水平间距
#define kHorizontalPadding 5 // button 间的 水平间距
#define kVerticalMargin 16 // button 与 View 的垂直间距
#define kVerticalpadding 5 // button间的 垂直间距

#define kButtonConstTag 4500

@interface HQLSearchTagComponentCell ()

@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIView *titleCustomView;

@property (strong, nonatomic) UIView *buttonView;
@property (strong, nonatomic) NSMutableArray *buttonArray;

@end

@implementation HQLSearchTagComponentCell

#pragma mark - life cycle

- (void)setFrame:(CGRect)frame {
    CGFloat originWidth = self.width;
    [super setFrame:frame];
    if (originWidth != self.width) {
        [self calculateFrame];
    }
}

#pragma mark - event

- (void)calculateFrame {
    // 计算self.titleRightCustomView
    if (self.titleCustomView) {
        self.titleCustomView.x = self.titleView.width - self.titleCustomView.width - kHorizontalMargin;
        self.titleCustomView.centerY = self.titleView.height * 0.5;
    }
    
    // 计算button
    UIButton *lastButton = nil;
    for (UIButton *button in self.buttonArray) {
        CGFloat margin = lastButton ? kHorizontalPadding : kHorizontalMargin;
        CGFloat x = CGRectGetMaxX(lastButton.frame) + margin;
        // 判断是否超出一行
        CGFloat currentMaxX = x + button.width + kHorizontalMargin;
        if (currentMaxX > self.buttonView.width && lastButton) {
            // 超出范围 换行
            button.x = kHorizontalMargin;
            button.y = lastButton.maxY + kVerticalpadding;
        } else {
            button.x = x;
            button.y = lastButton ? lastButton.y : kVerticalMargin;
        }
        lastButton = button;
    }
    
    self.buttonView.height = lastButton.maxY + kVerticalMargin;
    self.height = self.titleView.height + self.buttonView.height;
    self.viewHeight = self.titleView.height + self.buttonView.height;
}

- (CGFloat)calculateStringWidth:(NSString *)string maxWidth:(CGFloat)maxWidth font:(UIFont *)font horizontalMargin:(CGFloat)horizontalMargin {
    CGSize size = [string sizeWithAttributes:@{
                                               NSFontAttributeName : font
                                               }];
    CGFloat width = size.width + 2 * horizontalMargin;
    return (width >= maxWidth ? maxWidth : width);
}

- (void)buttonDidClick:(UIButton *)button {
    // 根据tag来区别button
    NSInteger index = button.tag - kButtonConstTag;
    if ([self.delegate respondsToSelector:@selector(searchTagComponentCell:didClickButton:)]) {
        [self.delegate searchTagComponentCell:self didClickButton:index];
    }
}

- (HQLSearchTagButton *)buttonOfIndex:(NSInteger)index {
    if (index >= self.buttonArray.count) {
        return nil;
    }
    return [self.buttonArray objectAtIndex:index];
}

#pragma mark - setter

- (void)setModel:(HQLSearchTagComponentModel *)model {
    
    [self titleView];
    [self buttonView];
    
    [self.titleCustomView removeFromSuperview];
    self.titleCustomView = nil;
    
    [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttonArray removeAllObjects];
    
    // 设置好titleView
    [self.titleLabel setFont:model.titleFont];
    [self.titleLabel setText:model.title];
    [self.titleLabel setTextColor:model.titleColor];
    self.titleCustomView = model.titleRightCustomView;
    [self.titleView addSubview:self.titleCustomView];
    
    // 设置button
    NSInteger index = 0;
    for (NSString *string in model.dataSource) {
        // 创建button
        HQLSearchTagButton *button = [HQLSearchTagButton buttonWithType:UIButtonTypeCustom];
        button.borderStyle = model.borderStyle;
        button.buttonBorderColor = model.buttonBorderColor;
        button.backgroundColor = model.buttonBackgroundColor;
        [button setTitleColor:model.buttonTitleColor forState:UIControlStateNormal];
        [button.titleLabel setFont:model.buttonFont];
        button.height = model.buttonHeight;
        [button setTitle:string forState:UIControlStateNormal];
        
        // 根据string来确定button的width
        button.width = [self calculateStringWidth:string maxWidth:model.buttonMaxWidth font:model.buttonFont horizontalMargin:kTagButtonMargin];
        
        button.tag = kButtonConstTag + index;
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        index++;
        
        [self.buttonView addSubview:button];
        [self.buttonArray addObject:button];
    }
    
    [self calculateFrame];
}

#pragma mark - getter

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kTitleViewHeight)];
        
        // 添加titleLabel
        [_titleView addSubview:self.titleLabel];
        [self addSubview:_titleView];
    }
    return _titleView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHorizontalMargin, 0, self.titleView.width - 2 * kHorizontalMargin, kTitleViewHeight)];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

-(UIView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), self.width, self.height - self.titleView.height)];
        
        [self addSubview:_buttonView];
    }
    return _buttonView;
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

@end
