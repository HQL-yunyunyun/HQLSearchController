//
//  HQLSearchTagButton.h
//  HQLSearchController
//
//  Created by weplus on 2017/3/28.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTagButtonMargin 8

typedef enum {
    HQLSearchTagButtonRoundedStyle , // 圆润的边
    HQLSearchTagButtonRectStyle , // 正方形
//    HQLSearchTagButtonNoneMode , // 没有
} HQLSearchTagButtonBorderStyle;

@interface HQLSearchTagButton : UIButton

@property (assign, nonatomic) HQLSearchTagButtonBorderStyle borderStyle;

/**
 default : nil
 */
@property (strong, nonatomic) UIColor *buttonBorderColor;

@end
