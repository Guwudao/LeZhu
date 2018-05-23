//
//  GYRegisterViewController.m
//  LeZhu
//
//  Created by apple on 17/2/28.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYRegisterViewController.h"
#import "LXAlertView.h"
#import "LoginModel.h"

@interface GYRegisterViewController ()<UITextFieldDelegate>
/** 请输入手机号 */
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
/** 请输入密码 */
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
/** 请再次输入密码 */
@property (weak, nonatomic) IBOutlet UITextField *passwordDoubleCheckText;
/** 输入验证码 */
@property (weak, nonatomic) IBOutlet UITextField *identifyCodeText;
/** 获取验证码按钮 */
@property (weak, nonatomic) IBOutlet UIButton *getIDCodeBtn;
/** 注册按钮 */
@property (weak, nonatomic) IBOutlet UIButton *RegisterBtn;
/** 乐主用户协议按钮 */
@property (weak, nonatomic) IBOutlet UIButton *userProtocolBtn;
/** 已读/未读用户协议按钮 */
@property (weak, nonatomic) IBOutlet UIButton *readProtocolBtn;

@property (strong, nonatomic) LoginModel *loginModel;

@end

@implementation GYRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBtnsBackground];
    
    self.identifyCodeText.delegate = self;
    self.phoneText.delegate = self;
    self.passwordDoubleCheckText.delegate = self;
    self.passwordText.delegate = self;
    
}

- (void)setBtnsBackground{
    self.RegisterBtn.layer.cornerRadius = self.RegisterBtn.gy_height/2;
    
    self.getIDCodeBtn.layer.cornerRadius = 3;
    
    //设置协议按钮的文字下划线
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"《乐主生活服务平台用户协议》"];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [self.userProtocolBtn setAttributedTitle:title
                      forState:UIControlStateNormal];
}

// 点击了取消按钮
- (IBAction)closeBtn:(id)sender {
    


    if (self.navigationController.childViewControllers.count == 0) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 获取验证码
- (IBAction)getIDCodeBtnClick:(id)sender {
    
    
    if (self.phoneText.text == nil || self.phoneText.text.length < 11) {
        [JWAlert showMsg:@"请输入正确手机号" WithOwner:self];
    }else{
        // 倒计时
        [self openCountdown];
        //发送验证码请求
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"mobile"] = self.phoneText.text;
        parameters[@"actname"] = @"register";
        
        JWNetWorking *mgr = [JWNetWorking sharedManager];
        [mgr postRequestWithUrl:GYSentCodeURL parameter:parameters successBlock:^(id responseBody) {
            if (responseBody[@"msg"]) {
                [JWAlert showMsg:responseBody[@"msg"] WithOwner:self];

            }else{
                [JWAlert showMsg:@"验证码已发送到你手机" WithOwner:self];

            }

        } failureBlock:^(NSString *error) {
            NSLog(@"%@", error);
        }];
       
    }
    

}

// 注册
- (IBAction)RegisterBtnClick:(id)sender {
    
    
    if ([self.phoneText.text isEqualToString:@""] || [self.passwordText.text isEqualToString:@""] || [self.passwordDoubleCheckText.text isEqualToString:@""] || [self.identifyCodeText.text isEqualToString:@""]) {
        LXAlertView *v = [[LXAlertView alloc] initWithTitle:@"提示" message:@"请完整填写信息" cancelBtnTitle:nil otherBtnTitle:nil clickIndexBlock:^(NSInteger clickIndex) {
        }];
        [v showLXAlertView];
    }else if (![self.passwordText.text isEqualToString:self.passwordDoubleCheckText.text]){
        LXAlertView *v = [[LXAlertView alloc] initWithTitle:@"提示" message:@"两次输入密码不一致" cancelBtnTitle:nil otherBtnTitle:nil clickIndexBlock:^(NSInteger clickIndex) {
        }];
        [v showLXAlertView];
    }else if(self.readProtocolBtn.selected == NO){
        
        LXAlertView *v = [[LXAlertView alloc] initWithTitle:@"提示" message:@"请阅读乐主用户条款" cancelBtnTitle:nil otherBtnTitle:nil clickIndexBlock:^(NSInteger clickIndex) {
            
        }];
        [v showLXAlertView];
    }else{
        // *************** 请求注册 ***************
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"mobile"] = self.phoneText.text;
        parameters[@"password"] = self.passwordText.text;
        parameters[@"code"] = self.identifyCodeText.text;

        JWNetWorking *mgr = [JWNetWorking sharedManager];
        [mgr postRequestWithUrl:GYRegisterURL parameter:parameters successBlock:^(id responseBody) {
            
            NSDictionary *dic = [responseBody mj_JSONObject];
            NSString *str = dic[@"code"];
            CGFloat code = [str integerValue];
            if (code == 0) {
                // 注册失败
                GYLog(@"注册失败");
                [JWAlert showMsg:@"注册失败" WithOwner:self];
               
            }else if (code == 1){
                // 注册成功
                GYLog(@"注册成功");
                
                [self autoLogin];
                

            }else if (code == 3){
                // 账号已注册
                GYLog(@"账号已注册");
                [JWAlert showMsg:@"该账号已注册" WithOwner:self];

            }else if (code == 4){
                // 验证码错误
                GYLog(@"验证码错误");
                [JWAlert showMsg:@"验证码错误" WithOwner:self];
                
            }
        } failureBlock:^(NSString *error) {
            GYLog(@"%@", error);
            [JWAlert showMsg:@"服务器故障" WithOwner:self];

        }];
        
    }

}

- (void)autoLogin{
    [SVProgressHUD showWithStatus:@"注册成功, 自动登录中.."];
    // 注册成功,自动登录, 返回主页 **********************************************
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:self.phoneText.text forKey:@"phone"];
    [def setObject:self.passwordText.text forKey:@"password"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mobile"] = self.phoneText.text;
    parameters[@"password"] = self.passwordText.text;
    
    
    JWNetWorking *mgr = [JWNetWorking sharedManager];
    [mgr postRequestWithUrl:GYPwdLoginURL parameter:parameters successBlock:^(id responseBody) {
        
        _loginModel = [LoginModel mj_objectWithKeyValues:responseBody];
        UserInfoModel *infoModel = _loginModel.info;
        XiaoQuModel *xqModel = _loginModel.xiaoqu;
        
        
        // 登录成功
        
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
        
        [self dismissViewControllerAnimated:YES completion:^{
            [SVProgressHUD dismiss];
        }];
        
        
        
    } failureBlock:^(NSString *error) {
        [SVProgressHUD dismissWithDelay:1];
        GYLog(@"%@", error);
        [JWAlert showMsg:@"网络阻塞,请重试" WithOwner:self];
        
    }];
}

// 点击用户协议按钮
- (IBAction)userProtocolBtnClick:(id)sender {
    // 进入协议详情页面
   
}

// 协议已读/未读按钮点击
- (IBAction)readProtocolBtnClick:(id)sender {
    self.readProtocolBtn.selected = !self.readProtocolBtn.selected;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

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
                self.getIDCodeBtn.layer.cornerRadius = 5;

                //设置按钮的样式
                [self.getIDCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
//                [self.getIDCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]] forState:UIControlStateNormal];
                self.getIDCodeBtn.backgroundColor = COLOR(244, 85, 62, 1);
                self.getIDCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                self.getIDCodeBtn.layer.cornerRadius = 5;
                [self.getIDCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
//                [self.getIDCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
                self.getIDCodeBtn.backgroundColor = [UIColor grayColor];

                self.getIDCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
