//
//  ZBDownMenuView.m
//  ZBDownMenuView
//
//  Created by 周博 on 2018/2/9.
//  Copyright © 2018年 周博. All rights reserved.
//

//颜色
#define UIColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define  TitleColorNormal UIColorFromHex(0x333333)      //黑
#define  TitleColorSelected  UIColorFromHex(0x1e8cd4)   //蓝

//屏幕尺寸
#define kScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight    [[UIScreen mainScreen] bounds].size.height


#import "ZBDownMenuView.h"
#import "ZBButton.h"


@interface ZBDownMenuView ()

/* 半透明背景View */
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UITableView *tableView;//cell为筛选的条件

/**
 *  数据源--一维数组 (每一列的条件标题)
 */
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) UIButton *currentButton;

/* 分类内容 动画起始位置 */
@property (assign, nonatomic) CGFloat startY;

@end

@implementation ZBDownMenuView

- (void)layoutSubviews{
    self.startY = CGRectGetMaxY(self.frame);
}

#pragma mark - lazy
/* 蒙层view */
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.startY, kScreenWidth, kScreenHeight)];
        _bgView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _bgView.hidden = YES;
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenuView)];
        [_bgView addGestureRecognizer:tapGest];
        [self.superview addSubview:_bgView];
        
    }
    return _bgView;
}

/* 分类内容 */
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, self.startY, kScreenWidth, 0);
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
        [self.superview addSubview:_tableView];
        [self.superview sendSubviewToBack:_tableView];
    }
    return _tableView;
}

#pragma mark - setter
// 设置文字 默认
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;

    self.buttonArray = [[NSMutableArray alloc] init];
    
    CGFloat btnW = kScreenWidth/titleArray.count;
    CGFloat btnH = CGRectGetHeight(self.frame);
    
    //根据titleArray配置带箭头的button
    for (NSInteger i = 0; i < titleArray.count; i++) {
        ZBButton *titleBtn = [ZBButton buttonTitle:titleArray[i] image:@"灰箭头.png" target:self action:@selector(titleBtnClicked:)];
        [titleBtn setTitleColor:TitleColorNormal forState:UIControlStateNormal];
        titleBtn.frame = CGRectMake(i*btnW, 0, btnW, btnH);
        titleBtn.tag = i;
        
        [self addSubview:titleBtn];
        [self.buttonArray addObject:titleBtn];  // 分类 按钮数组
        
        // 中间分割竖线
        if (i < titleArray.count - 1) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(btnW*(i+1), (btnH-18)/2, 1, 18)];
            line.backgroundColor = UIColorFromHex(0xdddddd);
            [self addSubview:line];
        }
    }
}

#pragma mark - 按钮点击
- (void)titleBtnClicked:(UIButton *)btn {
    _currentButton = btn;
    self.dataSource = self.dataSourceArr[btn.tag];
    // 按钮动画
    for (UIButton *subBtn in self.buttonArray) {
        if (subBtn == btn) {
            subBtn.selected = !subBtn.selected;
            if (subBtn.isSelected) {
                [self showMenuView];
            }else{
                [self hideMenuView];
            }
            
            double rotation = subBtn.isSelected ? M_PI : 0;
            [UIView animateWithDuration:0.25 animations:^{
                subBtn.imageView.transform = CGAffineTransformMakeRotation(rotation);
            }];
        } else {
            subBtn.selected = NO;
            [UIView animateWithDuration:0.25 animations:^{
                subBtn.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
    }
}

#pragma mark - 显示/隐藏
- (void)showMenuView {
    self.bgView.hidden = NO;
    [self.superview bringSubviewToFront:self.tableView];
    
    [self.tableView reloadData];
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = CGRectMake(0, self.startY, kScreenWidth, 44 * self.dataSource.count);
    } completion:nil];
}

- (void)hideMenuView {
    Class class = NSClassFromString(@"UIButton");
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[class class]]) {
            UIButton *btn = (UIButton *)view;
            btn.selected = NO;
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = CGRectMake(0, self.startY, kScreenWidth, 0);
        _currentButton.imageView.transform = CGAffineTransformMakeRotation(0);
        self.bgView.hidden = YES;
    } completion:nil];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    // KVC
    NSArray *textArr = [self.buttonArray valueForKeyPath:@"titleLabel.text"];
    if ([textArr containsObject:cell.textLabel.text]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = TitleColorSelected;
        cell.tintColor = TitleColorSelected;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = TitleColorNormal;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 改变标题展示 及 颜色
    NSMutableArray *currentTitleArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.dataSourceArr.count; i++) {
        UIButton *btn = self.buttonArray[i];
        if (btn.selected) {
            [btn setTitle:self.dataSource[indexPath.row] forState:UIControlStateNormal];
            [btn setTitleColor:TitleColorSelected forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"天蓝箭头.png"] forState:UIControlStateNormal];
        }
        [currentTitleArr addObject:btn.titleLabel.text];
    }
    
    // 调用代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(downMenuView:currentButtonTitle:andCurrentTitleArray:)]) {
        [self.delegate downMenuView:self currentButtonTitle:self.dataSource[indexPath.row] andCurrentTitleArray:currentTitleArr];
    }
    
    // 走block
    !self.conditionBlock?:self.conditionBlock(self.dataSource[indexPath.row],currentTitleArr);
    [self hideMenuView];
}

@end
