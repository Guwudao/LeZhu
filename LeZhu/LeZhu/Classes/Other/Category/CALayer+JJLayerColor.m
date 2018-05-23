//
//  CALayer+JJLayerColor.m
//  LeZhu
//
//  Created by JJ on 17/4/22.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "CALayer+JJLayerColor.h"
#import <UIKit/UIKit.h>

@implementation CALayer (JJLayerColor)

- (void)setBorderColorWithUIColor:(UIColor *)color
{
    
    self.borderColor = color.CGColor;
}

@end
