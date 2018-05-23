//
//  GYHomeViewController.h
//  LeZhu
//
//  Created by apple on 17/2/3.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceAddressModel,GYHomeViewController;


@interface GYHomeViewController : UIViewController

@property(nonatomic,strong) UIWebView *webView;   // 主界面网页

-(void)rightButtonClick;

@property(nonatomic,strong) UIButton *middleBtn;


@end
