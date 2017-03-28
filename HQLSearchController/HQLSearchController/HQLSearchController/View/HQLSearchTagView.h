//
//  HQLSearchTagView.h
//  HQLSearchController
//
//  Created by weplus on 2017/3/28.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HQLSearchTagButton.h"

@interface HQLSearchTagView : UIView

/**
 每一个显示部分的数据源(tag button)
 */
@property (strong, nonatomic) NSArray <NSArray <NSString *>*>*componentsDataSource;

/**
 每一个部件显示的title
 */
@property (strong, nonatomic) NSArray <NSString *>*componentsTitle;

@end

@interface HQLSearchTagComponentModel : NSObject

/**
 部件的数据源(tag button 的title)
 */
@property (strong, nonatomic) NSArray <NSString *>*dataSource; // * 有关于cell的高

/**
 default : HQLSearchTagButtonRoundedStyle
 */
@property (assign, nonatomic) HQLSearchTagButtonBorderStyle borderStyle;

/**
 default : nil
 */
@property (strong, nonatomic) UIColor *buttonBorderColor;
@property (strong, nonatomic) UIColor *buttonBackgroundColor;

/**
 defalut : black color
 */
@property (strong, nonatomic) UIColor *buttonTitleColor;

/**
 default : 14
 */
@property (strong, nonatomic) UIFont *buttonFont;

/**
 button的title只能显示一行 default: 100
 */
@property (assign, nonatomic) CGFloat buttonMaxWidth; // * 有关于cell的高

/**
 defalut: 25
 */
@property (assign, nonatomic) CGFloat buttonHeight; // * 有关于cell的高

/**
 部件的title
 */
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIFont *titleFont;

@property (strong, nonatomic) UIView *titleLeftCustomView;

@property (assign, nonatomic, readonly) CGFloat viewHeight;

@end
