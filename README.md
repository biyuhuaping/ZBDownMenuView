# ZBDownMenuView
非常轻量级的下拉筛选菜单

![下拉筛选菜单](http://upload-images.jianshu.io/upload_images/5132421-3169f1ebf9ec92ab.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 使用方法

1. 导入头文件
```#import "ZBDownMenuView.h"```

2. 声明ZBDownMenuView
```@property (strong, nonatomic) IBOutlet ZBDownMenuView *downMenuView;```

3. 配置DownMenuView
```
- (void)viewDidLoad {
    [super viewDidLoad];
    [self conflictingDownMenuView];
}

/* 配置DownMenuView */
- (void)conflictingDownMenuView {
    _downMenuView.titleArray = [NSArray arrayWithObjects:@"综合排序",@"价格", @"时间", nil];
    _downMenuView.dataSourceArr = @[@[@"速度最快", @"评分最高", @"起送价格最低", @"配送费最低", @"人均高到低", @"人均低到高"], @[@"0-50元", @"50-100元", @"100-200元", @"200元以上"], @[@"1分钟以内", @"1-3分钟", @"3-5分钟", @"5分钟以上"]].mutableCopy;

/**
*  回调方式一: block
*/
    __weak typeof(self) weakSelf = self;
    _downMenuView.conditionBlock = ^(NSString *currentTitle, NSArray *currentTitleArray){
    NSString *string = [NSString stringWithFormat:@"您当前选中的是\n(%@)\n 当前所有展示的是\n%@", currentTitle, currentTitleArray];
        NSLog(@"%@",string);
    };
}

/**
*  回调方式二: delegate，实现<ZBDownMenuViewDelegate>协议
*/
- (void)downMenuView:(ZBDownMenuView *)menuView currentButtonTitle:(NSString *)title andCurrentTitleArray:(NSArray *)currentTitleArray{
    [NSString stringWithFormat:@"您当前选中的是\n(%@)\n 当前所有展示的是\n%@", title, currentTitleArray];
}
```
