//
//  ZBDownMenuView.h
//  ZBDownMenuView
//
//  Created by 周博 on 2018/2/9.
//  Copyright © 2018年 周博. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBDownMenuView;
@protocol ZBDownMenuViewDelegate <NSObject>
@optional
- (void)downMenuView:(ZBDownMenuView *)menuView currentButtonTitle:(NSString *)title andCurrentTitleArray:(NSArray *)currentTitleArray;
@end



typedef void (^ConditionBlock)(NSString *title, NSArray *array);

@interface ZBDownMenuView : UIView

@property (weak, nonatomic) id<ZBDownMenuViewDelegate> delegate;
@property (copy, nonatomic) ConditionBlock conditionBlock;

/// 数据源--二维数组
/// 每一个大分类里, 都可以有很多个小分类(条件)
@property (strong, nonatomic) NSMutableArray *dataSourceArr;

/// 默认显示的
@property (strong, nonatomic) NSArray *titleArray;

/// 显示菜单
- (void)showMenuView;

@end
