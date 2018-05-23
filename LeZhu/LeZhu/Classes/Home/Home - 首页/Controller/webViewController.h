//
//  OnlineServiceViewController.h
//  Service
//
//  Created by yue on 2017/9/27.
//  Copyright © 2017年 潴潴侠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface webViewController : UIViewController

@property (nonatomic,strong) NSString *webViewURL;

+(instancetype)initWithURL:(NSString *)urlString;

@end
