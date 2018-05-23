//
//  GYLoginViewController.m
//  LeZhu
//
//  Created by apple on 17/2/28.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYLoginViewController.h"
#import "GYRegisterViewController.h"
#import "GYIdentifyCodeLoginViewController.h"
#import "GYForgretPwdViewController.h"
#import "LoginModel.h"
#import "UserInfoModel.h"
#import "LXAlertView.h"
#import "XiaoQuModel.h"
@interface GYLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) LoginModel *loginModel;

@end

@implementation GYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBtnsBackground];
    
    self.phoneText.delegate = self;
    self.passwordText.delegate = self;
    
}

// 初始化设置
- (void)setBtnsBackground{
    self.loginBtn.layer.cornerRadius = self.loginBtn.gy_height/2;
    
}

// 点击取消按钮
- (IBAction)cancelBtnClick:(id)sender {
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];

}

// 点击登录按钮
- (IBAction)loginBtnClick:(id)sender {
    
    AFNetworkReachabilityManager *reachMgr = [AFNetworkReachabilityManager sharedManager];
    [reachMgr startMonitoring];
    [reachMgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            GYLog(@"没有网络");
            [SVProgressHUD showErrorWithStatus:@"没有网络"];
        }else if (self.phoneText.text.length == 0 || self.passwordText.text.length == 0){
            
            LXAlertView *v = [[LXAlertView alloc] initWithTitle:@"提示" message:@"请完整填写账号和密码" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                if (clickIndex == 1) {
                    [v dismissAlertView];
                }
            }];
            v.smallCancelBtn.hidden = YES;
            [v showLXAlertView];
        }else{
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"mobile"] = self.phoneText.text;
            parameters[@"password"] = self.passwordText.text;
            
            [SVProgressHUD showWithStatus:@"正在登录..."];
            
            JWNetWorking *mgr = [JWNetWorking sharedManager];
            [mgr postRequestWithUrl:GYPwdLoginURL parameter:parameters successBlock:^(id responseBody) {
                
                _loginModel = [LoginModel mj_objectWithKeyValues:responseBody];
                UserInfoModel *infoModel = _loginModel.info;
                XiaoQuModel *xqModel = _loginModel.xiaoqu;
                
             
                if (_loginModel.code == 1) {
                    // 登录成功
                    [SVProgressHUD dismiss];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    // 保存偏好设置
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    
                    [def setObject:self.phoneText.text forKey:@"phone"];
                    
                    [def setObject:self.passwordText.text forKey:@"password"];
                    
                    [def setObject:infoModel.nickname forKey:@"name"];
                    
                    NSString *uid = [NSString stringWithFormat:@"%ld", infoModel.ID];
                    [def setObject:uid forKey:@"uid"];
                    
                    NSString *wuyeid = [NSString stringWithFormat:@"%ld", xqModel.wuyeid];
                    
                    GYLog(@"登录成功");
                    GYLog(@"物业id是%@", wuyeid);
                    [def setObject:wuyeid forKey:@"wuyeid"];
                    
                    //拿头像,保存偏好设置
                    NSString *encodedStr = infoModel.avatar; // base 64
                    if (encodedStr) {
                        NSData *imgData = [[NSData alloc] initWithBase64EncodedString:encodedStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                        [def setObject:imgData forKey:@"userIconData"];
                        [def synchronize];
                    }
                    
                }else{
                    
                    // 登录失败
                    [SVProgressHUD dismiss];
                    
                    LXAlertView *v = [[LXAlertView alloc] initWithTitle:@"提示" message:@"密码或者手机错误!" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                        if (clickIndex == 1) {
                            [v dismissAlertView];
                        }
                    }];
                    v.smallCancelBtn.hidden = YES;
                    [v showLXAlertView];

                }
                
                
            } failureBlock:^(NSString *error) {
                [SVProgressHUD dismissWithDelay:1];
                GYLog(@"%@", error);
                [self showMsg:@"登录失败,请重试"];

            }];

        }
    }];
    
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
    
}

// 点击注册按钮
- (IBAction)registerBtnClick:(id)sender {
    //进入注册页面
    UIStoryboard *regisStb = [UIStoryboard storyboardWithName:@"GYRegisterViewController" bundle:nil];
    GYRegisterViewController *registerVC = [regisStb instantiateInitialViewController];
    [self.navigationController pushViewController:registerVC animated:YES];
}

// 点击验证码登录按钮
- (IBAction)identifyCodeLoginBtnClick:(id)sender {
    UIStoryboard *idCodeStb = [UIStoryboard storyboardWithName:@"GYIdentifyCodeLoginViewController" bundle:nil];
    GYIdentifyCodeLoginViewController *idCodeVC = [idCodeStb instantiateInitialViewController];
    [self.navigationController pushViewController:idCodeVC animated:YES];
}

// 点击忘记密码按钮
- (IBAction)foggetPasswordBtnClick:(id)sender {
    UIStoryboard *stb = [UIStoryboard storyboardWithName:@"GYForgretPwdViewController" bundle:nil];
    GYForgretPwdViewController *vc = [stb instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showMsg:(NSString *)msg{
    // 弹框提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
}


#pragma mark - text feild delegate
//开始编辑时 视图上移 如果输入框不被键盘遮挡则不上移。

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    CGFloat rects = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 +50);
    
    NSLog(@"aa%f",rects);
    
    if (rects <= 0) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = self.view.frame;
            
            frame.origin.y = rects -20;
            
            self.view.frame = frame;
            
        }];
        
    }
    
    
    
    return YES;
    
}

//结束编辑时键盘下去 视图下移动画

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.view.frame;
        
        frame.origin.y = 0.0;
        
        self.view.frame = frame;
        
    }];
    
    
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [self.view endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
