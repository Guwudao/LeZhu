//
//  GYMineViewController.m
//  LeZhu
//
//  Created by apple on 17/2/3.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYMineViewController.h"
#import "GYMineTableViewCell.h"
#import "LXAlertView.h"
#import "GYRegisterViewController.h"
#import "GYLoginViewController.h"
#import "GYNavigationController.h"
#import "LoginModel.h"
#import "UserInfoModel.h"
#import "GYSettingViewController.h"
//#import "GYVisitorsTableViewController.h"
#import "GYDevModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import "GYIdentifyCodeLoginViewController.h"
#import "JWDoorTool.h"

static NSString *const mineID = @"mineCell";

@interface GYMineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *userIconImg;

@property (weak, nonatomic) IBOutlet UITableView *tableView;// 表格

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewH;// 头部详情栏背景

@property (strong, nonatomic) NSArray *cellTitleArr1;// cell的文字

@property (strong, nonatomic) NSArray *cellImageArr1;// cell的图片

@property(nonatomic, strong) NSArray *controllersArr; //点击cell跳转的控制器数组

@property (weak, nonatomic) IBOutlet UIButton *pleaseLoginBtn; //登录按钮

@property (weak, nonatomic) IBOutlet UILabel *warningLoginLabel; // 登录提示标签

@property (weak, nonatomic) IBOutlet UILabel *niChengLabel; // 昵称label


@property (nonatomic, strong) NSMutableDictionary *tempDevDict; // App account in DoorMaster Server devices data

@property (nonatomic, strong) NSArray *devArr; // 已授权的设备模型数组

@end

@implementation GYMineViewController

#pragma mark - 懒加载
- (NSArray *)cellImageArr1{
    if (!_cellImageArr1) {
        _cellImageArr1 = @[@"wodexiaoqu", @"bangzhuyufankui", @"guanyuwomen", @"lianxiwomen"];
    }
    return _cellImageArr1;
}



- (NSArray *)cellTitleArr1{
    if (!_cellTitleArr1) {
        _cellTitleArr1 = @[@"我的小区", @"帮助与反馈", @"关于我们", @"联系我们"];
    }
    return _cellTitleArr1;
}

- (NSArray *)controllersArr{
    if (!_controllersArr) {
        _controllersArr = @[@"GYDoorTableViewController", @"GYContactUsViewController", @"GYAboutUsViewController"];
    }
    return _controllersArr;
}

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化设置
    [self initSetting];
    
    // 初始化头部登录界面
    [self initHeaderView];
    
    // 屏幕适配
    [self adaptScreen];

    
    // 设置允许摇一摇功能
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"shakeOpenSwitch"] isEqualToString:@"1"]) {
        // 并让自己成为第一响应者
        [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
        
        [self becomeFirstResponder];
        
    }else{
        [self resignFirstResponder];
    }
}

- (void)adaptScreen{
    if (iPhone6P) {
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.niChengLabel.font = [UIFont systemFontOfSize:16];
    }else if (iPhone6){
        self.nameLabel.font = [UIFont systemFontOfSize:14.3];
        self.niChengLabel.font = [UIFont systemFontOfSize:14.3];
    }
}

// view即将显示登录时候
- (void)viewWillAppear:(BOOL)animated{
    [self initHeaderView];
}

- (void)initSetting{
    self.navigationItem.title = @"我的";
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.contentInset = UIEdgeInsetsMake(150, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"GYMineTableViewCell" bundle:nil] forCellReuseIdentifier:mineID];
    
    
    //  把头像设置成圆形
    self.userIconImg.layer.cornerRadius=self.userIconImg.frame.size.width/2;
    self.userIconImg.layer.masksToBounds=YES;
    
    self.pleaseLoginBtn.layer.cornerRadius = 4;
    
}

// 未登录状态和登录状态显示的内容
- (void)initHeaderView{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *name = [def objectForKey:@"name"];
    NSString *phone = [def objectForKey:@"phone"];
    NSData *imgData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIconData"];
    
    if (phone == nil || phone.length == 0) { // 未登录
        self.phoneLabel.hidden = YES;
        self.nameLabel.hidden = YES;
        self.niChengLabel.hidden = YES;
        self.pleaseLoginBtn.hidden = !self.phoneLabel.hidden;
        self.warningLoginLabel.hidden = !self.phoneLabel.hidden;
        self.userIconImg.image = [UIImage imageNamed:@"username"];
        
        
    }else{ // 已登录
        self.phoneLabel.hidden = NO;
        self.nameLabel.hidden = NO;
        self.niChengLabel.hidden = NO;
        self.pleaseLoginBtn.hidden = YES;
        self.warningLoginLabel.hidden = YES;
        self.phoneLabel.text = [def objectForKey:@"phone"];
        
        if (name) {
            self.nameLabel.text = [def objectForKey:@"name"];
            
        }else{
            self.nameLabel.text = @"未设置";
            
        }
        
        // 取头像
        UIImage *img = [UIImage imageWithData:imgData];

        if (!img) {
            self.userIconImg.image = [UIImage imageNamed:@"username"];
            
        }else{
            self.userIconImg.image = img;
        }
    }
}




// 点击登录 ***************************
- (IBAction)LoginBtn:(id)sender {
    // 进入登录界面
    [self presentLoginVC];
}

// 点击设置 ***************************
- (IBAction)settingBtnClick:(id)sender {
    // 如果没有登录
    if (self.phoneLabel.text.length == 0 || self.phoneLabel.hidden == YES) {
        LXAlertView *alertV = [[LXAlertView alloc] initWithTitle:@"登录确认" message:@"你尚未登录\n如没有账号, 请先注册" cancelBtnTitle:@"登录" otherBtnTitle:@"注册" clickIndexBlock:^(NSInteger clickIndex) {
            NSLog(@"%ld", clickIndex);
            if (clickIndex == 0) {
                //进入登录界面
                [self presentLoginVC];
                
            }else{
                
                //进入注册页面
                [self presentRegisterVC];
            }
        }];
        alertV.animationStyle = LXASAnimationTopShake;
        [alertV showLXAlertView];
    }else{
    // 如果登录了 , 进入设置页面
        UIStoryboard *stb = [UIStoryboard storyboardWithName:@"GYSettingViewController" bundle:nil];
        GYSettingViewController *settingVC = [stb instantiateInitialViewController];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
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


#pragma mark - scroll view delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //计算偏移量
    CGFloat offset = scrollView.contentOffset.y - (-150);
    CGFloat h = 150 - offset;
    if (h <= 0) {
        h = 0;
    }
    self.imageViewH.constant = h;
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GYMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineID forIndexPath:indexPath];
    cell.cellImage.image = [UIImage imageNamed:@"home"];
    
        cell.cellLabel.text = self.cellTitleArr1[indexPath.row];
        cell.cellImage.image = [UIImage imageNamed:self.cellImageArr1[indexPath.row]];
   
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return  0.001 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

// cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    
    if (indexPath.row == 3) {
        // 拨打客服电话
        NSString *phoneNo = @"18125907588";
        NSString *url = [NSString stringWithFormat:@"telprompt://%@", phoneNo];
        // iOS 10 用以下接口
        if ([self respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
        }else{
            // 非iOS 10用以下接口
            dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
            dispatch_async(queue, ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                
            });
        }

    }else if(phone.length == 0 && indexPath.row == 0){
        [JWAlert showMsg:@"请先登录" WithOwner:self];
        
    }else{
        UIStoryboard *stb = [UIStoryboard storyboardWithName:self.controllersArr[indexPath.row] bundle:nil];
        UIViewController *vc = [stb instantiateInitialViewController];
        self.hidesBottomBarWhenPushed = YES;
        
        
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}
//-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{


#pragma mark - 摇一摇开门功能
// 摇一摇开始方法
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"shakeOpenSwitch"] isEqualToString:@"1"]){
        // 添加动画
        PulsingHaloLayer*halo = [PulsingHaloLayer layer];
        halo.position = CGPointMake(screenW/2, screenH - 25);
        [self.tabBarController.view.layer addSublayer:halo];
        halo.haloLayerNumber = 3 ;
        halo.radius = 500 ;
        halo.backgroundColor = [COLOR(243, 84, 62, 0.7) CGColor];
        halo.animationDuration = 2.5;
        [halo start];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
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
                
                // 开门 *******************************************************************************
                [JWDoorTool openDoorWithTarget:self andValidDeviceArr:_devArr andHaloLayer:halo tabBarVC:nil];
                                
            } failureBlock:^(NSString *error) {
                [halo removeFromSuperlayer];
                [JWAlert showMsg:@"网络堵塞, 请重试" WithOwner:self];
            }];
        }else{
            [halo removeFromSuperlayer];
            [JWAlert showMsg:@"请先登录" WithOwner:self];
        }
        
    }
    
    return;
}




@end
