//
//  HQLSearchTagComponentCell.h
//  HQLSearchController
//
//  Created by weplus on 2017/3/28.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQLSearchTagComponentModel, HQLSearchTagComponentCell, HQLSearchTagButton;

@protocol HQLSearchTagComponentCellDelegate <NSObject>

- (void)searchTagComponentCell:(HQLSearchTagComponentCell *)cell didClickButton:(NSInteger)index;

@end

@interface HQLSearchTagComponentCell : UITableViewCell

@property (strong, nonatomic) HQLSearchTagComponentModel *model;

@property (assign, nonatomic) CGFloat viewHeight;

@property (assign, nonatomic) id <HQLSearchTagComponentCellDelegate>delegate;

/**
 获取选中的button

 @param index button的index
 @return button
 */
- (HQLSearchTagButton *)buttonOfIndex:(NSInteger)index;

/**
 根据当前cell 的内容计算高度, 结果保存在viewHeight中
 */
- (void)calculateFrame;

@end
