//
//  ViewController.m
//  ZBDownMenuView
//
//  Created by 周博 on 2018/2/9.
//  Copyright © 2018年 周博. All rights reserved.
//

#import "ViewController.h"
#import "ZBDownMenuView.h"

@interface ViewController ()<ZBDownMenuViewDelegate>
@property (strong, nonatomic) IBOutlet ZBDownMenuView *downMenuView;
@property (strong, nonatomic) NSMutableArray *dataListArray;
@property (strong, nonatomic) NSMutableArray *allDataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self conflictingDownMenuView];
}

/* 配置DownMenuView */
- (void)conflictingDownMenuView {
    _downMenuView.titleArray = [NSArray arrayWithObjects:@"综合排序",@"价格", @"时间", nil];
    _downMenuView.dataSourceArr = @[@[@"速度最快", @"评分最高", @"起送价格最低", @"配送费最低", @"人均高到低", @"人均低到高"],
                                        @[@"0-50元", @"50-100元", @"100-200元", @"200元以上"],
                                        @[@"1分钟以内", @"1-3分钟", @"3-5分钟", @"5分钟以上"]
                                        ].mutableCopy;

    /// 回调方式一: block
    __weak typeof(self) weakSelf = self;
    _downMenuView.conditionBlock = ^(NSString *currentTitle, NSArray *currentTitleArray){
        NSString *string = [NSString stringWithFormat:@"您当前选中的是\n(%@)\n 当前所有展示的是\n%@", currentTitle, currentTitleArray];
        NSLog(@"%@",string);
        
    };
}

/**
 *  回调方式二: delegate
 */
- (void)downMenuView:(ZBDownMenuView *)menuView currentButtonTitle:(NSString *)title andCurrentTitleArray:(NSArray *)currentTitleArray{
    [NSString stringWithFormat:@"您当前选中的是\n(%@)\n 当前所有展示的是\n%@", title, currentTitleArray];
}

@end
