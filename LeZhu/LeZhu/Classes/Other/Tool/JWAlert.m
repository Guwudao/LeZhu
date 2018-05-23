//
//  JWAlert.m
//  LeZhu
//
//  Created by apple on 17/3/9.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "JWAlert.h"

@implementation JWAlert

+ (void)showMsg:(NSString *)msg WithOwner:(UIViewController *)vc{
    // 弹框提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [vc presentViewController:alertController animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
    
}


@end
