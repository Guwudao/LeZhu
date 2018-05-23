//
//  JWDoorTool.m
//  LeZhu
//
//  Created by apple on 17/3/10.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "JWDoorTool.h"
#import "JWAlert.h"
#import "GYDevModel.h"
#import "GYTabBarViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <PulsingHaloLayer.h>
#import "GYHomeViewController.h"

@interface JWDoorTool()

@property(nonatomic, strong)PulsingHaloLayer *puLayer;

@end


@implementation JWDoorTool

+ (void)openDoorWithTarget:(UIViewController *)vc andValidDeviceArr:(NSArray *)devArr andHaloLayer:(PulsingHaloLayer *) halo homeVC:(GYHomeViewController *)homeVC{
    // 1. 获取扫描周围的设备结果
    // 1. Gets the device results around the scan
    int ret = [LibDevModel scanDevice:100 andScanOpen:YES];
    
    
    
    if (ret == 0) // 成功
    {
        //        MBProgressHUD *hud = [MBProgressHUD showMessage:@"扫描中..."];
        //        [SVProgressHUD showWithStatus:@"扫描中..."];
        
        
        
        
        
        // Receive the result - the callback function
        [LibDevModel onScanOver:^(NSMutableDictionary *scanDevDict) {
            NSLog(@"%@", scanDevDict);
            // 2. 找出信号值最强的设备，信号值为负数
            // 2. Locate the device with the highest signal value, and the signal value is negative
            //            [hud hide:YES afterDelay:0];
            //            [SVProgressHUD dismiss];
            if ([scanDevDict count] == 0)
            {
                [halo removeAllAnimations];
                [halo removeFromSuperlayer];
                [JWAlert showMsg:@"附近没有设备" WithOwner:vc];
                return;
            }
            
            
            //*************** 开门  ************************
            // Get the open device sn
            
            NSArray *rssiArray = [scanDevDict allValues];
            // Signal values are sorted in ascending order. Example: [-85, -73, -65]
            NSArray *rssiSortedArray= [rssiArray sortedArrayUsingSelector:@selector(compare:)]; // 信号值升序排序，示例:[-85, -73, -65]
            //    NSLog(@"%@",[rssiSortedArray.firstObject class]);
            //    NSLog(@"%@",[keyArr.firstObject class]);
            
            //取出信号最强的已授权的设备序列号
            //    NSString *devSn = [self getOpenDevSn:rssiSortedArray andScanDict:scanDevDict];
            //    GYLog(@"判断开门时devArr的值为%@", _devArr);
            GYDevModel *myDevModel = [JWDoorTool getOpenModelWithScanDic:scanDevDict andSortedValueArray:rssiSortedArray andMyDevArray:devArr];
            
            
            if (myDevModel != nil)
            {
                // Use SDK Open door
                //                MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在尝试开门...."];
                LibDevModel *devModel = [[LibDevModel alloc] init];
                NSString *myDevSn = [NSString stringWithFormat:@"%@", myDevModel.devsn];
                
                devModel.devSn = myDevSn;
                devModel.devMac = myDevModel.devmac;
                
                devModel.eKey = myDevModel.ekey;
                
                devModel.devType = (short)myDevModel.devtype;
                
                int ret = [LibDevModel controlDevice:devModel andOperation:0x00];  // E.g 1：Use controlDevice interface
                //    int ret = [LibDevModel openDoor:self.tempDevDict[devSn]]; // E.g 2：Use openDoor interface
                
                if (ret != 0)
                {
                    //                    [hud hide:YES afterDelay:0];
                    NSLog(@"%d", ret);
                    [halo removeAllAnimations];
                    [halo removeFromSuperlayer];
                    
                    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
                    anim.values = @[@0, @-8, @0, @8, @0];
                    anim.duration = 0.1;
                    anim.repeatCount = 3;
                    [homeVC.middleBtn.layer addAnimation:anim forKey:nil];
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    
                    [JWAlert showMsg:@"开门失败" WithOwner:vc];
                    return;
                }
                // 接收开门结果--回调函数
                // Receive the open result - the callback function
                [LibDevModel onControlOver:^(int ret, NSMutableDictionary *msgDict) {
                    //                    [hud hide:YES afterDelay:0];
                    //            [self showMsg:[NSString stringWithFormat:@"Device：%@ Open Success", devSn]];
                    //                    [self onCommOver:ret andMsgDict:msgDict andTarget:vc];
                    [SVProgressHUD dismiss];
                    
                    if (ret == 0)
                    {
                        if ([vc class] == [GYTabBarViewController class]) {
                            [halo removeAllAnimations];
                            [halo removeFromSuperlayer];
                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                            [JWAlert showMsg:@"开门成功" WithOwner:vc];
                            // 添加开门记录信息
                            [self addOpenDoorRecordWithStatus:@"1"];
                        }else{
                            [halo removeAllAnimations];
                            [halo removeFromSuperlayer];
                            
                            [JWAlert showMsg:@"开门成功" WithOwner:vc];
                            
                            // 添加开门记录信息
                            [self addOpenDoorRecordWithStatus:@"1"];
                        }
                    }
                    else
                    {
                        [halo removeAllAnimations];
                        [halo removeFromSuperlayer];
                        
                        
                        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
                        anim.values = @[@0, @-8, @0, @8, @0];
                        anim.duration = 0.1;
                        anim.repeatCount = 3;
                        [homeVC.middleBtn.layer addAnimation:anim forKey:nil];
                        
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        
                        [JWAlert showMsg:@"开门失败,请重试" WithOwner:vc];
                        // 添加开门记录信息
                        [self addOpenDoorRecordWithStatus:@"0"];
                    }
                }];
            }
            else
            {
                [halo removeAllAnimations];
                [halo removeFromSuperlayer];
                
                CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
                anim.values = @[@0, @-8, @0, @8, @0];
                anim.duration = 0.1;
                anim.repeatCount = 3;
                [homeVC.middleBtn.layer addAnimation:anim forKey:nil];
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
                [JWAlert showMsg:@"附近没有已授权的设备" WithOwner:vc];
                return;
            }
            //  *************************************
            
            
            
        }];
    }
    else
    {
        [halo removeAllAnimations];
        [halo removeFromSuperlayer];
        
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.values = @[@0, @-8, @0, @8, @0];
        anim.duration = 0.15;
        anim.repeatCount = 3;
        [homeVC.middleBtn.layer addAnimation:anim forKey:nil];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        [JWAlert showMsg:@"扫描失败, 请确认是否已打开蓝牙" WithOwner:vc];
    }
}


+ (void)openDoorWithTarget:(UIViewController *)vc andValidDeviceArr:(NSArray *)devArr andHaloLayer:(PulsingHaloLayer *) halo tabBarVC:(GYTabBarViewController *)tabBarVC{
    // 1. 获取扫描周围的设备结果
    // 1. Gets the device results around the scan
    int ret = [LibDevModel scanDevice:100 andScanOpen:YES];

    
    
    if (ret == 0) // 成功
    {
//        MBProgressHUD *hud = [MBProgressHUD showMessage:@"扫描中..."];
//        [SVProgressHUD showWithStatus:@"扫描中..."];
        
        

        
        
        // Receive the result - the callback function
        [LibDevModel onScanOver:^(NSMutableDictionary *scanDevDict) {
            NSLog(@"%@", scanDevDict);
            // 2. 找出信号值最强的设备，信号值为负数
            // 2. Locate the device with the highest signal value, and the signal value is negative
//            [hud hide:YES afterDelay:0];
//            [SVProgressHUD dismiss];
            if ([scanDevDict count] == 0)
            {
                [halo removeAllAnimations];
                [halo removeFromSuperlayer];
                [JWAlert showMsg:@"附近没有设备" WithOwner:vc];
                return;
            }
            
            
            //*************** 开门  ************************
            // Get the open device sn
            
            NSArray *rssiArray = [scanDevDict allValues];
            // Signal values are sorted in ascending order. Example: [-85, -73, -65]
            NSArray *rssiSortedArray= [rssiArray sortedArrayUsingSelector:@selector(compare:)]; // 信号值升序排序，示例:[-85, -73, -65]
            //    NSLog(@"%@",[rssiSortedArray.firstObject class]);
            //    NSLog(@"%@",[keyArr.firstObject class]);
            
            //取出信号最强的已授权的设备序列号
            //    NSString *devSn = [self getOpenDevSn:rssiSortedArray andScanDict:scanDevDict];
            //    GYLog(@"判断开门时devArr的值为%@", _devArr);
            GYDevModel *myDevModel = [JWDoorTool getOpenModelWithScanDic:scanDevDict andSortedValueArray:rssiSortedArray andMyDevArray:devArr];
            
            
            if (myDevModel != nil)
            {
                // Use SDK Open door
//                MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在尝试开门...."];
                LibDevModel *devModel = [[LibDevModel alloc] init];
                NSString *myDevSn = [NSString stringWithFormat:@"%@", myDevModel.devsn];
                
                devModel.devSn = myDevSn;
                devModel.devMac = myDevModel.devmac;
                
                devModel.eKey = myDevModel.ekey;
                
                devModel.devType = (short)myDevModel.devtype;
                
                int ret = [LibDevModel controlDevice:devModel andOperation:0x00];  // E.g 1：Use controlDevice interface
                //    int ret = [LibDevModel openDoor:self.tempDevDict[devSn]]; // E.g 2：Use openDoor interface
                
                if (ret != 0)
                {
//                    [hud hide:YES afterDelay:0];
                    NSLog(@"%d", ret);
                    [halo removeAllAnimations];
                    [halo removeFromSuperlayer];
                    
                    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
                    anim.values = @[@0, @-8, @0, @8, @0];
                    anim.duration = 0.1;
                    anim.repeatCount = 3;
                    [tabBarVC.myTabBar.middleBtn.layer addAnimation:anim forKey:nil];
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

                    [JWAlert showMsg:@"开门失败" WithOwner:vc];
                    return;
                }
                // 接收开门结果--回调函数
                // Receive the open result - the callback function
                [LibDevModel onControlOver:^(int ret, NSMutableDictionary *msgDict) {
//                    [hud hide:YES afterDelay:0];
                    //            [self showMsg:[NSString stringWithFormat:@"Device：%@ Open Success", devSn]];
//                    [self onCommOver:ret andMsgDict:msgDict andTarget:vc];
                    [SVProgressHUD dismiss];
                    
                    if (ret == 0)
                    {
                        if ([vc class] == [GYTabBarViewController class]) {
                            [halo removeAllAnimations];
                            [halo removeFromSuperlayer];
                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                            [JWAlert showMsg:@"开门成功" WithOwner:vc];
                            // 添加开门记录信息
                            [self addOpenDoorRecordWithStatus:@"1"];
                        }else{
                            [halo removeAllAnimations];
                            [halo removeFromSuperlayer];
                            
                            [JWAlert showMsg:@"开门成功" WithOwner:vc];
                            
                            // 添加开门记录信息
                            [self addOpenDoorRecordWithStatus:@"1"];
                        }
                    }
                    else
                    {
                        [halo removeAllAnimations];
                        [halo removeFromSuperlayer];
                        
                        
                        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
                        anim.values = @[@0, @-8, @0, @8, @0];
                        anim.duration = 0.1;
                        anim.repeatCount = 3;
                        [tabBarVC.myTabBar.middleBtn.layer addAnimation:anim forKey:nil];
                        
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

                        [JWAlert showMsg:@"开门失败,请重试" WithOwner:vc];
                        // 添加开门记录信息
                        [self addOpenDoorRecordWithStatus:@"0"];
                    }
                }];
            }
            else
            {
                [halo removeAllAnimations];
                [halo removeFromSuperlayer];
                
                CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
                anim.values = @[@0, @-8, @0, @8, @0];
                anim.duration = 0.1;
                anim.repeatCount = 3;
                [tabBarVC.myTabBar.middleBtn.layer addAnimation:anim forKey:nil];
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

                [JWAlert showMsg:@"附近没有已授权的设备" WithOwner:vc];
                return;
            }
           //  *************************************
            
            
            
        }];
    }
    else
    {
        [halo removeAllAnimations];
        [halo removeFromSuperlayer];
        
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.values = @[@0, @-8, @0, @8, @0];
        anim.duration = 0.15;
        anim.repeatCount = 3;
        [tabBarVC.myTabBar.middleBtn.layer addAnimation:anim forKey:nil];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

        [JWAlert showMsg:@"扫描失败, 请确认是否已打开蓝牙" WithOwner:vc];
    }
}


// 扫描回来的设备, 取出权限内信号最强的设备模型
+ (GYDevModel *)getOpenModelWithScanDic:(NSDictionary *)scanDict andSortedValueArray:(NSArray *)rssiSortedArray andMyDevArray:(NSArray *)devArr{
    
    GYLog(@"扫描的字典%@", scanDict);
    
    // 1.遍历排好序的信号数组, 从大到小取出每个信号
    long maxIndex = rssiSortedArray.count - 1;
    for (long i = maxIndex; i >= 0; i--) {
        // 从大到小拿到每个信号
//        NSLog(@"%ld", maxIndex);
//        NSLog(@"sortarray 元素类型 %@",[rssiSortedArray[i] class]);
//        NSLog(@"sortarray %@", rssiSortedArray);
        NSNumber *signal =rssiSortedArray[i];
//        NSLog(@"%@", signal);
        // 2.根据信号值取字典中的key(devSn)
        NSArray *arr=[scanDict allKeys];
        GYLog(@"all keys arr数组的元素类型 %@", [arr.firstObject class]);
        for (NSString *key in arr)
        {
            NSString *signalStr = [NSString stringWithFormat:@"%@", signal];
            NSNumber *value = [scanDict objectForKey:key];
            NSString *valueStr = [NSString stringWithFormat:@"%@", value];
//            NSLog(@"value为%@", valueStr);
//            NSLog(@"signalStr为%@", signalStr);
            if (valueStr == signalStr)
            {
                // 3.拿到了对应的key
//                NSLog(@"找到了 %@ 对应的key 值是 :%@",signal,key);
                // 4.遍历模型数组, 拿devSn进行对比
                for (GYDevModel *devModel in devArr) {  // *************************
//                    NSString *devSn = [NSString stringWithFormat:@"%ld", (long)devModel.devsn];
                    NSString *devSn = devModel.devsn;
                    GYLog(@"授权的devsn %@", devSn);
                    if ([devSn isEqualToString:key]) {
//                        NSLog(@"最后对比时devsn是%@, key是%@", devSn, key);
                        return devModel;
                    }
                }
            }
            
        }
    }
    return nil;
}

/** 添加开门记录 */
+ (void)addOpenDoorRecordWithStatus:(NSString *)status{
    JWNetWorking *mgr = [JWNetWorking sharedManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"od.reid"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    parameters[@"od.account"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    parameters[@"od.type"] = @"1";
    parameters[@"od.status"] = @"1";
    [mgr getRequestWithUrl:GYAddOpenDoorRecordURL parameter:parameters successBlock:^(id responseBody) {
        GYLog(@"添加开门记录结果%@", responseBody);
        
    } failureBlock:^(NSString *error) {
        GYLog(@"添加开门记录失败, 网络堵塞");
    }];
}

//// controlDevice interface callback function
//+(void) onCommOver:(int)ret andMsgDict:(NSMutableDictionary *)msgDict andTarget:(UIViewController *)vc
//{
//    [SVProgressHUD dismiss];
//
//    if (ret == 0)
//    {
//        if ([vc class] == [GYTabBarViewController class]) {
//            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//            [JWAlert showMsg:@"开门成功" WithOwner:vc];
//        }else{
//            [JWAlert showMsg:@"开门成功" WithOwner:vc];
//        }
//        
//        // 添加开门记录信息
//        [self addOpenDoorRecordWithStatus:@"1"];
//
//
//    }
//    else
//    {
//        [self addOpenDoorRecordWithStatus:@"0"];
//
//        [JWAlert showMsg:@"开门失败,请重试" WithOwner:vc];
//    }
//}



@end
