//
//  ZBCollectionMenuView.h
//  goodLook
//
//  Created by ZB on 2023/8/26.
//

#import <UIKit/UIKit.h>


#define ColorFromHex(hexValue)  [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
#define kScreenW ([[UIScreen mainScreen] bounds].size.width)
#define kScreenH [[UIScreen mainScreen] bounds].size.height

NS_ASSUME_NONNULL_BEGIN

@interface ZBCollectionMenuView : UIView

@property (nonatomic, strong) NSArray *titleArray;

/// 选中了第几个
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, copy) void (^block)(NSInteger selectedIndex);

/// 显示菜单
- (void)showMenuViewToView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
