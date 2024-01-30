//
//  ZBCollectionMenuView.m
//  goodLook
//
//  Created by ZB on 2023/8/26.
//

#import "ZBCollectionMenuView.h"

#define  TitleColorNormal ColorFromHex(0x666666) //灰
#define  TitleColorSelected  UIColor.blackColor //黑

#define  btnBgColorNormal ColorFromHex(0xEFEFEF) //浅灰
#define  btnBgColorSelected ColorFromHex(0xC9E3FB) //蓝

@interface ZBCollectionMenuView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation ZBCollectionMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.contentView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 60, 44)];
    lab.text = @"壁纸分类";
    lab.textColor = ColorFromHex(0x666666);
    lab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:lab];

    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenuView)];
    [self addGestureRecognizer:tapGest];
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;

    CGFloat buttonHeight = 30.0;
    CGFloat buttonSpacing = 12.0;//间距
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat xOffset = buttonSpacing;
    CGFloat yOffset = buttonSpacing + 42;

    for (NSInteger i = 0; i < self.titleArray.count; i++) {
        NSString *title = self.titleArray[i];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}];
        CGFloat buttonWidth = titleSize.width + 20.0;

        if (xOffset + buttonWidth > viewWidth) {
            xOffset = buttonSpacing;
            yOffset += buttonHeight + buttonSpacing;
        }

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xOffset, yOffset, buttonWidth, buttonHeight);
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:TitleColorNormal forState:UIControlStateNormal];
        [button setTitleColor:TitleColorSelected forState:UIControlStateSelected];
        button.backgroundColor = btnBgColorNormal;
        button.layer.cornerRadius = 6;
        button.tag = i;
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];

        xOffset += buttonWidth + buttonSpacing;
    }

    CGFloat contentHeight = yOffset + buttonHeight + buttonSpacing;
    self.contentView.frame = CGRectMake(0, 0, viewWidth, contentHeight);
}

- (void)buttonTapped:(UIButton *)sender {
    [self hideMenuView];
    if (self.block){
        self.block(sender.tag);
    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(homeMenuView:didSelectButtonAtIndex:)]) {
//        [self.delegate homeMenuView:self didSelectButtonAtIndex:sender.tag];
//    }
}

- (void)setSelectedIndex:(NSInteger)index {
    for (UIButton *button in self.contentView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if (button.tag == index){
                button.selected = YES;
                button.backgroundColor = btnBgColorSelected;
            }else {
                button.selected = NO;
                button.backgroundColor = btnBgColorNormal;
            }
        }
    }
}

- (void)showMenuViewToView:(UIView *)view {
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [view addSubview:self.bgView];
    [view addSubview:self];
    
    // 动画起始位置
    CGFloat startY = CGRectGetMinY(self.frame);
    self.bgView.frame = CGRectMake(0, startY, kScreenW, kScreenH - startY);

    CGFloat h = CGRectGetHeight(self.contentView.frame);
    self.contentView.frame = CGRectMake(0, 0, kScreenW, 0);
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 1;
        self.contentView.frame = CGRectMake(0, 0, kScreenW, h);
    }];
}

- (void)hideMenuView {
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0;
        self.contentView.frame = CGRectMake(0, 0, kScreenW, 0);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - lazy
/// 蒙层view
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _bgView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        _bgView.alpha = 0;
//        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenuView)];
//        [_bgView addGestureRecognizer:tapGest];
    }
    return _bgView;
}

- (UIView *)contentView{
    if (!_contentView){
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
        _contentView.backgroundColor = UIColor.whiteColor;
        _contentView.clipsToBounds = YES;
    }
    return _contentView;
}

- (void)dealloc{
    
}
@end
