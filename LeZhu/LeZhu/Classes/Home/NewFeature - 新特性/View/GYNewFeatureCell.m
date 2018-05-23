//
//  GYNewFeatureCell.m
//  LeZhu
//
//  Created by apple on 17/3/8.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYNewFeatureCell.h"
#import "GYTabBarViewController.h"

@interface GYNewFeatureCell()
@property (nonatomic, weak)UIImageView *imageV;
/** 立即体验按钮 */
@property (nonatomic, weak) UIButton *startBtn;

@end

@implementation GYNewFeatureCell
#pragma mark - lazy
- (UIImageView *)imageV{
    
    if (_imageV == nil) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        
        _imageV = imageV;
        
        self.backgroundView = imageV;
    }
    return _imageV;
}
- (UIButton *)startBtn{
    if (_startBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 120, 40);
//        [btn setBackgroundColor:[UIColor clearColor]];
        btn.layer.cornerRadius = btn.frame.size.height / 2;
        btn.clipsToBounds = YES;
        btn.layer.borderColor = [[UIColor whiteColor] CGColor];
        btn.layer.borderWidth = 2;
//        [btn setImage:[UIImage imageNamed:@"enjoyBtn"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:COLOR(252, 136, 122, 1) size:CGSizeMake(120, 40)] forState:UIControlStateNormal];
        [btn setTitle:@"立即体验" forState:UIControlStateNormal];
        [btn setTintColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        _startBtn = btn;
        [self.contentView addSubview:btn];
    }
    return _startBtn;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.startBtn.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.9);
}
#pragma mark - setter
- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageV.image = image;
}
- (void)setIndexPath:(NSIndexPath *)indexPath cellCount:(int)cellCount {
    if (indexPath.item == cellCount - 1) {
        self.startBtn.hidden = NO;
    } else {
        self.startBtn.hidden = YES;
    }
}
#pragma mark - Event response
- (void)start {

    //创建tabBar控制器
    GYTabBarViewController *tabVC = [[GYTabBarViewController alloc] init];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = tabVC;
    
    CATransition *anim = [CATransition animation];
    anim.type = @"moveIn";
    anim.duration = 0.5;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:anim forKey:nil];
}

@end
