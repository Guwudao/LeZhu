//
//  UIImage+Image.h
//  LeZhu
//
//  Created by apple on 17/2/15.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)


/**
 根据颜色生成图片

 @param color 颜色
 @param size 图片大小
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
