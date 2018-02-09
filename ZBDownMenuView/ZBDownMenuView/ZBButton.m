//
//  ZBButton.m
//  ZBDownMenuView
//
//  Created by 周博 on 2018/2/9.
//  Copyright © 2018年 周博. All rights reserved.
//

#import "ZBButton.h"

@implementation ZBButton

+ (instancetype)buttonTitle:(NSString *)title image:(NSString *)imgName target:(id)target action:(SEL)action {
    ZBButton *btn = [self buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imageWidth = CGRectGetWidth(self.imageView.frame) + 1;
    CGFloat labelWidth = CGRectGetWidth(self.titleLabel.frame) + 1;
    
    // 文字 位置（左边）
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
    
    // 图片 位置（右）
    self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
}

@end
