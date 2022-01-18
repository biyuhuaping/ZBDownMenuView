//
//  ZBButton.h
//  ZBDownMenuView
//
//  Created by 周博 on 2018/2/9.
//  Copyright © 2018年 周博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBButton : UIButton

+ (instancetype)buttonTitle:(NSString *)title norImgName:(NSString *)norImgName selImgName:(NSString *)selImgName target:(id)target action:(SEL)action;

@end
