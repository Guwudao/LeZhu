//
//  Macros.h
//  LeZhu
//
//  Created by apple on 17/2/23.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

/**********   宏   **********/
// 屏幕宽高
#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

// 版本判断
#define SystemVersion [[UIDevice currentDevice].systemVersion floatValue]

// 屏幕大小判断
#define iPhone6P (screenH == 736)
#define iPhone6 (screenH == 667)
#define iPhone5 (screenH == 568)
#define iPhone4 (screenH == 480)

// 屏幕转化比例
#define scale6p (414 / 375)

#define scale5s (320 / 375)


/** 字典写成plist文件到电脑桌面 */
#define LJWWriteToPlist(filename) [resultDict writeToFile:[NSString stringWithFormat:@"/Users/apple/Desktop/%@.plist", @#filename] atomically:YES];

/** 微信支付信息 */
// 开放平台登录https://open.weixin.qq.com的开发者中心获取APPID
#define WX_APPID @"wxe090ae3e8da88c75"
// 开放平台登录https://open.weixin.qq.com的开发者中心获取AppSecret。
#define WX_APPSecret @"9112cc8a97e92ff5a43c3ffc36d34e21"
// 微信支付商户号
#define MCH_ID  @"13536**702"
// 安全校验码（MD5）密钥，商户平台登录账户和密码登录http://pay.weixin.qq.com 平台设置的“API密钥”，为了安全，请设置为以数字和字母组成的32字符串。
#define WX_PartnerKey @"b5f9c901480*****0f4c6e659be0"

/** 字体 */
#define FONTSIZESBOLD(x)  [UIFont boldSystemFontOfSize:(x*1.1)]
#define CLEAR [UIColor clearColor]
#define BLACK [UIColor blackColor]
#define WHITE [UIColor whiteColor]
#define RED   [UIColor redColor]
#define ORANGE [UIColor colorWithRed:255/256.0 green:102/256.0 blue:0/256.1 alpha:1]
#define BLUE  [UIColor colorWithRed:19/256.0 green:125/256.0 blue:204/256.0 alpha:1]
#define LIGHTGRAY     [UIColor colorWithRed:242/256.0 green:242/256.0 blue:248/256.0 alpha:1]
#define LINEGRAY     [UIColor colorWithRed:230/256.0 green:230/256.0 blue:230/256.0 alpha:1]
#define LIGHTDARK     [UIColor colorWithRed:71/256.0 green:69/256.0 blue:70/256.0 alpha:1]
#define DARKBLUE [UIColor colorWithRed:71/256.0 green:168/256.0 blue:239/256.0 alpha:1]
#define DRAKGREY [UIColor colorWithRed:217/256.0 green:217/256.0 blue:217/256.0 alpha:1]
#define GREENLIGHT [UIColor colorWithRed:85/256.0 green:175/256.0 blue:73/256.0 alpha:1]
#define COLOR(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/** 获取用户ID */
//#define userID [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];

#ifdef DEBUG // 调试

#define GYLog(...) NSLog(__VA_ARGS__)

#else // 发布

#define GYLog(...)

#endif


#endif /* Macros_h */
