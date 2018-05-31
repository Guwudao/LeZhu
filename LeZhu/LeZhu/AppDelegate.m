//
//  AppDelegate.m
//  LeZhu
//
//  Created by apple on 17/2/3.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "AppDelegate.h"
#import "GYTabBarViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "GYNewFeatureViewController.h"
#import "WXApi.h"
#import "JPUSHService.h"

@interface AppDelegate ()<WXApiDelegate, JPUSHRegisterDelegate>
//@property(nonatomic, copy) NSString *appkey
@end

static NSString *appKey = @"aa7182c25b684f681cbb1f79";
static NSString *channel = @"App Store";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 打开友盟打印日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    // 设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58b83b0976661340ce000e83"];
    
    //注册微信ID
    [WXApi registerApp:WX_APPID];
    
    // 设置微信的appkey和xxx
    [self configUSharePlatforms];
    
    // 初始化蓝牙
//    [LibDevModel initBluetooth];

    //创建窗口并显示
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self chooseRootController];
    [self.window makeKeyAndVisible];
    
    //集成极光推送
    [self JPushRegister];
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
    
    return YES;
    
}

-(void)JPushRegister{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
}



- (void)configUSharePlatforms{
    
    /* 设置微信的appKey和appSecret */
    
    // 我的账号
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx64b1a8451b0ecdb8" appSecret:@"9c4d97d252a1df33810fc39e8ce43634" redirectURL:@"http://mobile.umeng.com/social"];
    // 公司的账号
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxe090ae3e8da88c75" appSecret:@"9112cc8a97e92ff5a43c3ffc36d34e21" redirectURL:@"http://mobile.umeng.com/social"];
    
    
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@0, @3, @4,@5]];
    
}


//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功！";
                [self payResoultWith:@"0"];
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                [self payResoultWith:@"-1"];
                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                [self payResoultWith:@"-2"];
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
    }
}

//支付回调状态显示
-(void)payResoultWith: (NSString *)resultNum{
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    if ([resultNum isEqualToString:@"0"]) {
        
        [SVProgressHUD showWithStatus:@"支付成功！"];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }else if ([resultNum isEqualToString:@"-1"]){
        
        [SVProgressHUD showWithStatus:@"支付结果：失败！"];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });

        
    }else if ([resultNum isEqualToString:@"-2"]){
        
        [SVProgressHUD showWithStatus:@"用户已经退出支付！"];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });

        
    }
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url];
//    if (!result) {
//        
//        // 其他如支付等SDK的回调
//        //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
//        return  [WXApi handleOpenURL:url delegate:self];
//    }
//    return result;
    
    if([[url absoluteString] rangeOfString:@"wx"].location == 0) //你的微信开发者appid
        return [WXApi handleOpenURL:url delegate:self];
    else
        return result;
}

#pragma mark - private func
- (void)chooseRootController{
    
//    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
//    NSString *curVersion = dict[@"CFBundleShortVersionString"];
//    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"versionKey"];
    
//    if ([curVersion isEqualToString:lastVersion]) {
//        //创建tabBar控制器
//        GYTabBarViewController *tabVC = [[GYTabBarViewController alloc] init];
//        self.window.rootViewController = tabVC;
//
//    } else {
//        if (curVersion) {
//            [[NSUserDefaults standardUserDefaults] setObject:curVersion forKey:@"versionKey"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//        self.window.rootViewController = [[GYNewFeatureViewController alloc] init];
//        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//        [def setObject:@"1" forKey:@"shakeOpenSwitch"];
//
//    }
    
    //创建tabBar控制器
    GYTabBarViewController *tabVC = [[GYTabBarViewController alloc] init];
    self.window.rootViewController = tabVC;
}

#pragma mark- JPUSHRegisterDelegate

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}


- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    GYLog(@"收到推送");
    
    // Required
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler();  // 系统要求执行这个方法
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    GYLog(@"跳转至推送");
    
    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

@end
