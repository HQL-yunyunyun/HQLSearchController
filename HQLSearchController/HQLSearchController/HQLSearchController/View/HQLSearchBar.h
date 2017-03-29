//
//  HQLSearchBar.h
//  HQLSearchController
//
//  Created by weplus on 2017/3/28.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>

#define iOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define iOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define iOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define TEXTFIELD_BACKGROUNDCOLOR [UIColor colorWithRed:187/255.0 green:186/255.0 blue:193/255.0 alpha:1]

#define APP_TINT_COLOR [UIColor colorWithRed:0/255.0 green:104/255.0 blue:248/255.0 alpha:1]

@interface HQLSearchBar : UISearchBar

@property (copy, nonatomic) NSString *cancelButtonTitle;

@property (strong, nonatomic) UIView *rightCustomView;

@end
