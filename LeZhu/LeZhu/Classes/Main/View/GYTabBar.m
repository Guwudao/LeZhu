//
//  GYTabBar.m
//  LeZhu
//
//  Created by apple on 17/2/15.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYTabBar.h"

#define margin 10

@interface GYTabBar()



@end

@implementation GYTabBar

#pragma mark - 生命周期方法 **********************

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        // 创建tabBar边框线
        [self addBorderView];
        
        // 创建中间大按钮
        [self addMiddleBtn];

    }
    
    return self;
}


// 设置子控件的frame
-(void)layoutSubviews{
    [super layoutSubviews];
    // 按钮frame
    [self initBtnFrame];

    // 边框线frame
    if (iPhone5) {
        self.tabBarBorder.frame = CGRectMake(0, 10, self.gy_width, 10);

    }else if(iPhone6P){
        self.tabBarBorder.frame = CGRectMake(0, 18, self.gy_width, 10);

    }else{
        self.tabBarBorder.frame = CGRectMake(0, 14, self.gy_width, 10);

    }
}

// 创建边框线
- (void)addBorderView{
    UIImageView *borderV = [[UIImageView alloc]init];
    borderV.image = [UIImage imageNamed:@"border"];
    self.tabBarBorder = borderV;
    borderV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:borderV];
}




#pragma mark - 创建并初始化中间大按钮 **********************

// 创建中间大按钮
- (void)addMiddleBtn{
    // 按钮
    [self creatMiddleBtn];
   
    
}


// 创建中间按钮
- (void)creatMiddleBtn{
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"index"] forState:UIControlStateNormal];
    self.middleBtn = btn;
    
    [self addSubview:self.middleBtn];
    [self.middleBtn addTarget:self action:@selector(middleBtnClick) forControlEvents:UIControlEventTouchUpInside];
}



// 初始化按钮的frame
- (void)initBtnFrame{
    [self.middleBtn sizeToFit];
    self.middleBtn.gySize = CGSizeMake(50, 50);
    self.middleBtn.gy_centerX = self.gy_width/2;
    self.middleBtn.gy_centerY = self.gy_height/2 - margin + 5;
}





#pragma mark - 响应事件  **********************

// 重写hitTest方法,让中间按钮超过tabBar部分也响应点击
//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    
//    //如果tabBar的不是隐藏的, 则由我们自己判断谁来做最合适的view
//    if (self.isHidden == NO) {
//        // 把触摸点转换成坐标系
//        CGPoint newP = [self convertPoint:point toView:self.middleBtn];
//        
//        //如果触摸点在中间按钮上, 则由这个按钮来响应事件
//        if ([self.middleBtn pointInside:newP withEvent:event] || CGRectContainsPoint(CGRectMake(self.middleBtn.gy_width / 2 - 8, -8, 20, 20), newP)) {
//            return self.middleBtn;
//        }else{  // 如果不在, 就由系统处理
//            return [super hitTest:point withEvent:event];
//        }
//        
//    }else{
//        return [super hitTest:point withEvent:event];
//    }
//  
//}

// 中间按钮点击
- (void)middleBtnClick{
    if ([self.TBdelegate respondsToSelector:@selector(middleBtnClick:)]) {
        [self.TBdelegate middleBtnClick:self];
    }
}


@end
