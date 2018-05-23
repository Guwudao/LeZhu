//
//  JWDoorTool.h
//  LeZhu
//
//  Created by apple on 17/3/10.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYTabBarViewController.h"
@class PulsingHaloLayer,GYHomeViewController;

@interface JWDoorTool : NSObject


/**
 *  打开最近的门禁
 *
 *  @param vc     对象控制器
 *  @param devArr 已授权的门禁设备数组
 */
+ (void)openDoorWithTarget:(UIViewController *)vc andValidDeviceArr:(NSArray *)devArr andHaloLayer:(PulsingHaloLayer *) halo tabBarVC:(GYTabBarViewController *)tabBarVC;


/**
 *  打开最近的门禁
 *
 *  @param vc     对象控制器
 *  @param devArr 已授权的门禁设备数组
 */
+ (void)openDoorWithTarget:(UIViewController *)vc andValidDeviceArr:(NSArray *)devArr andHaloLayer:(PulsingHaloLayer *) halo homeVC:(GYHomeViewController *)homeVC;
@end