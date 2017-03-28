//
//  HQLSearchTagComponentCell.h
//  HQLSearchController
//
//  Created by weplus on 2017/3/28.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQLSearchTagComponentModel;

@interface HQLSearchTagComponentCell : UITableViewCell

@property (strong, nonatomic) HQLSearchTagComponentModel *model;

@property (assign, nonatomic) CGFloat viewHeight;

/**
 根据当前cell 的内容计算高度, 结果保存在viewHeight中
 */
- (void)calculateFrame;

@end
