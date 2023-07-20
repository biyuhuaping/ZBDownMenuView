//
//  ViewController.m
//  ZBDownMenuView
//
//  Created by 周博 on 2018/2/9.
//  Copyright © 2018年 周博. All rights reserved.
//

#import "ViewController.h"
#import "ZBDownMenuView.h"
#import "YCMenuView.h"

@interface ViewController ()<ZBDownMenuViewDelegate>
@property (strong, nonatomic) IBOutlet ZBDownMenuView *downMenuView;
@property (strong, nonatomic) NSMutableArray *dataListArray;
@property (strong, nonatomic) NSMutableArray *allDataArray;
@property (nonatomic, strong) UIButton *YCMenuBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self conflictingDownMenuView];
    
    self.YCMenuBtn.frame = CGRectMake(15, 450, 120, 40);
    [self.view addSubview:self.YCMenuBtn];
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

#pragma mark - YCMenuBtn
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self showYCMenuView:nil event:event];
}

- (void)YCMenuBtnAction:(UIButton *)sender{
    [self showYCMenuView:sender event:nil];
}

- (void)showYCMenuView:(UIButton *)sender event:(id)event{
    CGPoint touchPosition = CGPointZero;
    CGFloat width = 120;
    if (sender){//有按钮时，根据按钮位置、宽度展示
        touchPosition = sender.center;
        width = MAX(120, CGRectGetWidth(sender.frame));
    }else if (event){
        //获取触摸点的集合，可以判断多点触摸事件
        NSSet *touches = [event allTouches];
        //两句话是保存触摸起点位置
        UITouch *touch = [touches anyObject];
        touchPosition = [touch locationInView:self.view];
    }
    
    NSArray *imageArr = @[@"swap", @"selected", @"code"];
    NSArray *titleArr = @[@"扫一扫", @"拍    照", @"付款码"];
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < titleArr.count; i++) {
        UIImage *img = [UIImage imageNamed:imageArr[i]];
        YCMenuAction *mAction = [YCMenuAction actionWithTitle:titleArr[i] image:img handler:^(YCMenuAction *action) {
            NSLog(@"点击了%@",action.title);
        }];
        [mArray addObject:mAction];
    }
    
    // 创建
    YCMenuView *view = [YCMenuView menuWithActions:mArray width:width atPoint:touchPosition];
    [self.view addSubview:view];
    
    // 自定义设置
    view.menuColor = [UIColor whiteColor];
    view.isShowShadow = YES;
    view.separatorColor = UIColor.lightGrayColor;
//    view.offset = self.isHiddenNav ? kNavBarH + 45 + 15 : 20;
    view.textColor = UIColor.lightTextColor;
    view.textFont = [UIFont systemFontOfSize:16];
    view.menuCellHeight = 44;
    view.backgroundColor = UIColor.grayColor;
    [view show];
}

- (UIButton *)YCMenuBtn{
    if (!_YCMenuBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        [btn setImage:[UIImage imageNamed:@"shop_more"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitle:@"YCMenuView" forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(YCMenuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 2.0;
        btn.layer.borderWidth = 1.0;
        btn.layer.borderColor = UIColor.blueColor.CGColor;
        _YCMenuBtn = btn;
    }
    return _YCMenuBtn;
}

@end
