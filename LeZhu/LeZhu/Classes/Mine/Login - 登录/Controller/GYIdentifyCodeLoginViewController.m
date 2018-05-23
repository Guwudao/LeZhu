//
//  GYPasswordLoginViewController.m
//  LeZhu
//
//  Created by apple on 17/2/28.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYIdentifyCodeLoginViewController.h"
#import "GYLoginViewController.h"
#import "GYRegisterViewController.h"
#import "GYForgretPwdViewController.h"
#import "LoginModel.h"
#import "UserInfoModel.h"
#import "LXAlertView.h"
#import "XiaoQuModel.h"

@interface GYIdentifyCodeLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sentCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *identifyCodeText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) LoginModel *loginModel;

@end

@implementation GYIdentifyCodeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBtnsBackground];
    
    self.phoneText.delegate = self;
    self.identifyCodeText.delegate = self;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

// 返回
- (IBAction)calcelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

// 注册************
- (IBAction)registerBtnClick:(id)sender {
    [self presentRegisterVC];
}

// 密码登录************
- (IBAction)passwordLoginBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

// 忘记密码************
- (IBAction)forgetPasswordBtnClick:(id)sender {
    UIStoryboard *stb = [UIStoryboard storyboardWithName:@"GYForgretPwdViewController" bundle:nil];
    GYForgretPwdViewController *vc = [stb instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

// 发送验证码************
- (IBAction)identifyCodeBtnClick:(id)sender {
    if (self.phoneText.text == nil || self.phoneText.text.length < 11) {
        [JWAlert showMsg:@"请输入正确手机号" WithOwner:self];
    }else{
        [self openCountdown];
        //发送验证码请求
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"mobile"] = self.phoneText.text;
        parameters[@"actname"] = @"login ";
        
        JWNetWorking *mgr = [JWNetWorking sharedManager];
        [mgr postRequestWithUrl:GYSentCodeLoginURL parameter:parameters successBlock:^(id responseBody) {
            
            NSLog(@"%@", responseBody[@"code"]);
            
            // 弹框提示
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码已发送到你手机" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertController dismissViewControllerAnimated:YES completion:nil];
            });
            
        } failureBlock:^(NSString *error) {
            GYLog(@"%@", error);
        }];
    }
    

    
    
    
}



// 进入注册界面************
- (void)presentRegisterVC{
    UIStoryboard *regisStb = [UIStoryboard storyboardWithName:@"GYRegisterViewController" bundle:nil];
    GYRegisterViewController *registerVC = [regisStb instantiateInitialViewController];
    [self presentViewController:registerVC animated:YES completion:nil];
}

// 登录
- (IBAction)loginBtnClick:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.phoneText.text.length != 11) {
        
        LXAlertView *v = [[LXAlertView alloc] initWithTitle:@"提示" message:@"请输入11位手机号码" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            if (clickIndex == 1) {
                [v dismissAlertView];
            }
        }];
        v.smallCancelBtn.hidden = YES;
        [v showLXAlertView];
    }else if (self.identifyCodeText.text.length != 0) {
        [SVProgressHUD showWithStatus:@"登录中"];

        //判断验证码是否有效
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"mobile"] = self.phoneText.text;
        parameters[@"code"] = self.identifyCodeText.text;
        
        JWNetWorking *mgr = [JWNetWorking sharedManager];
        [mgr postRequestWithUrl:GYCheckCodeURL parameter:parameters successBlock:^(id responseBody) {
            
            NSNumber *code = responseBody[@"code"];
            if ([code  isEqual: @1]) { // 验证码有效
                [self codeLogining];
                
                
            }else{
                [self showMsg:@"该验证码无效"];
            }
            
            
            [SVProgressHUD dismiss];
            
        } failureBlock:^(NSString *error) {
            NSLog(@"%@", error);
            [SVProgressHUD dismiss];
        }];
    }else{
        [self showMsg:@"请填验证码"];
        [SVProgressHUD dismiss];
    }
    
    
    
   
}

// 验证码登录网络请求
- (void)codeLogining{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mobile"] = self.phoneText.text;
    
    JWNetWorking *mgr = [JWNetWorking sharedManager];
    [mgr postRequestWithUrl:GYCodeLoginURL parameter:parameters successBlock:^(id responseBody) {
        
        NSNumber *code = responseBody[@"code"];
        if ([code  isEqual: @1]) { // 登录成功
            
            _loginModel = [LoginModel mj_objectWithKeyValues:responseBody];
            UserInfoModel *infoModel = _loginModel.info;
            XiaoQuModel *xqModel = _loginModel.xiaoqu;
            
            NSDictionary *infoDic = responseBody[@"info"];
            GYLog(@"info%@", infoDic);
            GYLog(@"response -- %@", responseBody);
            GYLog(@"%@", responseBody[@"msg"]);
            
            [self dismissViewControllerAnimated:YES completion:nil];
            // 保存偏好设置
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            
            [def setObject:self.phoneText.text forKey:@"phone"];
            
            
            NSString *uid = [NSString stringWithFormat:@"%ld", infoModel.ID];
            [def setObject:uid forKey:@"uid"];
            
            [def setObject:infoModel.nickname forKey:@"name"];
            
            NSString *wuyeid = [NSString stringWithFormat:@"%ld", xqModel.wuyeid];
            GYLog(@"物业id是%@", wuyeid);
            [def setObject:wuyeid forKey:@"wuyeid"];
            
            //拿头像,保存偏好设置
            NSString *encodedStr = infoModel.avatar; // base 64
            
            NSLog(@"encodedStr %@", encodedStr);
            
            if (encodedStr.length != 0) {
                NSData *imgData = [[NSData alloc] initWithBase64EncodedString:encodedStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                [def setObject:imgData forKey:@"userIconData"];
            }
            
            [SVProgressHUD dismiss];
            
        }else{
            [SVProgressHUD dismiss];
            [self showMsg:@"该账号未注册, 请先注册"];
        }
        
        
        
    } failureBlock:^(NSString *error) {

        [SVProgressHUD dismiss];
    }];

}

// 初始化设置************
- (void)setBtnsBackground{
    self.loginBtn.layer.cornerRadius = self.loginBtn.gy_height/2;
    self.sentCodeBtn.layer.cornerRadius = 5;
    
}

- (void)showMsg:(NSString *)msg{
    // 弹框提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });

}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [self.view endEditing:YES];
    return YES;
}


// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 15; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.sentCodeBtn.layer.cornerRadius = 5;
                
                //设置按钮的样式
                [self.sentCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                //                [self.getIDCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]] forState:UIControlStateNormal];
                self.sentCodeBtn.backgroundColor = COLOR(244, 85, 62, 1);
                self.sentCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                self.sentCodeBtn.layer.cornerRadius = 5;
                [self.sentCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                //                [self.getIDCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
                self.sentCodeBtn.backgroundColor = [UIColor grayColor];
                
                self.sentCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}


@end
