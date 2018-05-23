//
//  GYTabBar.h
//  LeZhu
//
//  Created by apple on 17/2/15.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义协议, 让外界处理中间按钮点击事件
@class GYTabBar;
@protocol GYTabBarProtocol <NSObject>

@optional
- (void)middleBtnClick:(GYTabBar *)tabBar;

@end



@interface GYTabBar : UITabBar

/** GYTabBar的代理  */
@property(nonatomic, weak)id<GYTabBarProtocol> TBdelegate;

/** 中间一键开门按钮  */
@property(nonatomic, weak)UIButton *middleBtn;

/** tabbar边缘线  */
@property(nonatomic, weak)UIImageView *tabBarBorder;

@end
