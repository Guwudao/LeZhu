//
//  GYTabBarViewController.m
//  LeZhu
//
//  Created by apple on 17/2/3.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYTabBarViewController.h"
#import "GYNavigationController.h"
#import "GYHomeViewController.h"
#import "GYMineViewController.h"
#import "GYDevModel.h"
#import "JWDoorTool.h"
#import "LXAlertView.h"
#import "GYLoginViewController.h"
#import "GYRegisterViewController.h"
#import "GYShowOrderViewController.h"
#import "GYHomeViewController.h"




@interface GYTabBarViewController ()<GYTabBarProtocol>


@property (nonatomic, strong) NSMutableDictionary *tempDevDict; // App account in DoorMaster Server devices data

@property (nonatomic, strong) NSArray *devArr; // 已授权的设备模型数组

@end

@implementation GYTabBarViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建所有子控制器
    [self creatAllChildVC];
    
    // 替换掉系统的tabBar
    [self replaceTabBar];
    
    // 获取当前类的tabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:[self class], nil];
    
    // 设置所有item的选中时颜色
    // 设置选中文字颜色
    // 创建字典去描述文本
//    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    // 文本颜色 -> 描述富文本属性的key -> NSAttributedString.h
//    attr[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
//    [item setTitleTextAttributes:attr forState:UIControlStateSelected];
    
    // 通过normal状态设置字体大小
    // 字体大小 跟 normal
    NSMutableDictionary *attrnor = [NSMutableDictionary dictionary];
    
    // 设置字体
    if (iPhone5) {
        attrnor[NSFontAttributeName] = [UIFont systemFontOfSize:10.5];

    }else if(iPhone6){
        attrnor[NSFontAttributeName] = [UIFont systemFontOfSize:11.5];

    }else{
        attrnor[NSFontAttributeName] = [UIFont systemFontOfSize:12.5];

    }
    
    [item setTitleTextAttributes:attrnor forState:UIControlStateNormal];
    

    [item setTitlePositionAdjustment:UIOffsetMake(0, -3.8)];
//    [item setImageInsets:UIEdgeInsetsMake(0, 0, -10, 0)];
//    item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    self.selectedIndex = 1;
    self.myTabBar.middleBtn.selected = YES;
}

// 替换系统tabBar
- (void)replaceTabBar{
    
    GYTabBar *myTabBar = [[GYTabBar alloc] init];
    myTabBar.TBdelegate = self;
    [self setValue:myTabBar forKey:@"tabBar"];
    self.myTabBar = myTabBar;
    self.tabBar.tintColor = [UIColor blackColor];
    
    self.tabBar.tintColor = COLOR(245, 106, 77, 1);
    
    // 干掉tabBar边框色
    UIImage *img = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(screenW, 49)];
    UIImage *img2 = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(screenW, 49)];
    [self.tabBar setBackgroundImage:img2];
    [self.tabBar setShadowImage:img];
    
    for (UIBarItem *item in self.tabBar.items) {
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Helvetica" size:17], NSFontAttributeName, nil]
                            forState:UIControlStateNormal];
        
    }
}


// ****************************************************************************************************
//*****************************************    一键开门   ***********************************************
// ****************************************************************************************************
// 实现点击中间按钮的代理方法
- (void)middleBtnClick:(GYTabBar *)tabBar{
    
    if (self.myTabBar.middleBtn.selected == NO) {
        // 点击了"首页"
        self.myTabBar.middleBtn.selected = YES;
        self.selectedIndex = self.childViewControllers.count/2;
    }else{
        // 点击了"一键开门"
       
        GYLog(@"点击了一键开锁");
        
        [self getKey];
    }
   }

// 请求用户授权的设备及钥匙
- (void)getKey{
    
    PulsingHaloLayer*halo = [PulsingHaloLayer layer];
    halo.position = CGPointMake(screenW/2, screenH - 25);
    [self.view.layer addSublayer:halo];
    halo.haloLayerNumber = 4 ;
    halo.radius = 500 ;
    halo.backgroundColor = [COLOR(243, 84, 62, 0.7) CGColor];
    halo.animationDuration = 2.5;
    [halo start];

    // 取出Userdefault里面的电话
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *phone = [def valueForKey:@"phone"];
    // 如果有保存到账号
    if (phone.length != 0) {
        JWNetWorking *mgr = [JWNetWorking sharedManager];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"mobile"] = phone;
        [mgr getRequestWithUrl:GYGetKeyListURL parameter:parameters successBlock:^(id responseBody) {
            // 解析数据
            NSDictionary *dic = responseBody[@"extra"];
            NSArray *arr = dic[@"ResidentsKeyList"];
            _devArr = [GYDevModel mj_objectArrayWithKeyValuesArray:arr];
            GYDevModel *model1 = _devArr.lastObject;
            GYLog(@"转化模型后的ekey为%@", model1.ekey);
            
            // ***************** 开门 ********************
            [JWDoorTool openDoorWithTarget:self andValidDeviceArr:_devArr andHaloLayer:halo tabBarVC:self];
            
            
            
            
        } failureBlock:^(NSString *error) {
            GYLog(@"%@", error);
            [JWAlert showMsg:@"请求超时,请检查网络" WithOwner:self];
            [halo removeFromSuperlayer];
        }];
    }else{
        
        [halo removeFromSuperlayer];
        
//        LXAlertView *alertV = [[LXAlertView alloc] initWithTitle:@"登录确认" message:@"你尚未登录\n如没有账号, 请先注册" cancelBtnTitle:@"登录" otherBtnTitle:@"注册" clickIndexBlock:^(NSInteger clickIndex) {
//            NSLog(@"%ld", clickIndex);
//            if (clickIndex == 0) {
//                //进入登录界面
//                [self presentLoginVC];
//                
//            }else{
//                
//                //进入注册页面
//                [self presentRegisterVC];
//            }
//        }];
//        alertV.animationStyle = LXASAnimationTopShake;
//        [alertV showLXAlertView];
        
        GYHomeViewController *homeVC = [[GYHomeViewController alloc] init];
        [homeVC rightButtonClick];
    }
    
    
}

// 进入登录界面************
- (void)presentLoginVC{
    
    UIStoryboard *loginStb = [UIStoryboard storyboardWithName:@"GYLoginViewController" bundle:nil];
    GYLoginViewController *loginVC = [loginStb instantiateInitialViewController];
    GYNavigationController *navVC = [[GYNavigationController alloc] initWithRootViewController:loginVC];
    navVC.navigationBar.hidden = YES;
    [self presentViewController:navVC animated:YES completion:nil];
    
    
}

// 进入注册界面************
- (void)presentRegisterVC{
    UIStoryboard *regisStb = [UIStoryboard storyboardWithName:@"GYRegisterViewController" bundle:nil];
    GYRegisterViewController *registerVC = [regisStb instantiateInitialViewController];
    [self presentViewController:registerVC animated:YES completion:nil];
}


// ****************************************************************************************************
// ****************************************************************************************************
// ****************************************************************************************************
// 创建所有子控制器
- (void)creatAllChildVC{
  
    
//    // 中间占位
//    UIViewController *vc2 = [[UIViewController alloc] init];
//    
//    [self addChildViewController:vc2];
//    vc2.tabBarItem.enabled = NO;

    GYShowOrderViewController *orderVC = [[GYShowOrderViewController alloc] init];
    [self addChildVcWithVc:orderVC andTitle:@"订单" andImage:@"order" andSelImage:@"order"];
    
    // 首页
    GYHomeViewController *homeVC = [[GYHomeViewController alloc] init];
    GYNavigationController *navVC1 = [[GYNavigationController alloc] initWithRootViewController:homeVC];
    [self addChildViewController:navVC1];
    navVC1.tabBarItem.enabled = NO;
    
    // 我的
    UIStoryboard *stortBoard = [UIStoryboard storyboardWithName:@"GYMineViewController" bundle:nil];
    GYMineViewController *mineVC = [stortBoard instantiateInitialViewController];
    [self addChildVcWithVc:mineVC andTitle:@"我的" andImage:@"mine" andSelImage:@"mine"];
}

// 添加一个子控制器
- (void)addChildVcWithVc:(UIViewController *)vc andTitle:(NSString *)title andImage:(NSString *)image andSelImage:(NSString *)selImage{
    GYNavigationController *navVC = [[GYNavigationController alloc] initWithRootViewController:vc];
    navVC.tabBarItem.title = title;
    navVC.tabBarItem.image = [UIImage imageNamed:image];
    navVC.tabBarItem.selectedImage = [UIImage imageNamed:selImage];
    [self addChildViewController:navVC];
}

#pragma mark - UITabBarControllerDelegate

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    // 点击了两边的按钮后, 中间的一键开门按钮变成首页按钮
    if ([item.title isEqual: @"我的"] || [item.title isEqual: @"订单"]) {
        self.myTabBar.middleBtn.selected = NO;
    }
}


@end
