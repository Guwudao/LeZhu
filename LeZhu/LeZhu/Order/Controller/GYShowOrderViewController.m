//
//  GYShowOrderViewController.m
//  LeZhu
//
//  Created by apple on 17/2/6.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYShowOrderViewController.h"
#import "GYNotPayOrderVC.h"
#import "GYPendingOrderVC.h"
#import "GYReceivedOrderVC.h"
#import "YZDisplayViewHeader.h"
#import "GYCompletedOrderVC.h"

@interface GYShowOrderViewController ()

@end

@implementation GYShowOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.contentView.gy_y = -64;
    
    // 添加所有子控制器
    [self addAllChildVC];
    
    // 一些初始化设置
    [self initial];
    
    // 设置标题字体
    [self setUpTitle];
    
    // 设置下划线
    [self setUnderLine];
    
    // 设置颜色渐变
    [self setTitleColor];
    
    
}




// 初始化
- (void)initial{
    self.navigationItem.title = @"订单列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置内容view不要太靠下
    [self setUpContentViewFrame:^(UIView *contentView) {
        contentView.frame = CGRectMake(0, 0, screenW, screenH);
    }];
}

// 设置标题栏
- (void)setUpTitle{
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        // 标题字体大小
        *titleFont = [UIFont systemFontOfSize:14];
        // 标题颜色
        //*norColor = [UIColor darkGrayColor];
       // *selColor = COLOR(255, 66, 109, 1);
        // 标题栏高度
        *titleHeight = 25;
        
    }];
}

// 设置颜色渐变
- (void)setTitleColor{
    [self setUpTitleGradient:^(YZTitleColorGradientStyle *titleColorGradientStyle, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor) {
        *norColor = [UIColor darkGrayColor];
        *selColor = COLOR(255, 66, 109, 1);
    }];
}


// 设置下划线
- (void)setUnderLine{
    [self setUpUnderLineEffect:^(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor, BOOL *isUnderLineEqualTitleWidth) {
        *underLineH = 2;
        *isUnderLineDelayScroll = NO;
        *underLineColor = COLOR(255, 66, 109, 1);
    }];
}


// 添加所有子控制器
- (void)addAllChildVC{
    
    GYNotPayOrderVC *vc1 = [[GYNotPayOrderVC alloc] init];
    vc1.title = @"未支付";
    [self addChildViewController:vc1];
    
    GYPendingOrderVC *vc2 = [[GYPendingOrderVC alloc] init];
    vc2.title = @"待接单";
    [self addChildViewController:vc2];
    
    GYReceivedOrderVC *vc3 = [[GYReceivedOrderVC alloc] init];
    vc3.title = @"已接单";
    [self addChildViewController:vc3];
    
    GYCompletedOrderVC *vc4 = [[GYCompletedOrderVC alloc] init];
    vc4.title = @"已完成";
    [self addChildViewController:vc4];
    
}



@end
