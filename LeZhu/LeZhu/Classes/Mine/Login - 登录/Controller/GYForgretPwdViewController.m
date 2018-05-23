//
//  GYForgretPwdViewController.m
//  LeZhu
//
//  Created by apple on 17/2/28.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYForgretPwdViewController.h"
#import "LXAlertView.h"

@interface GYForgretPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UITextField *pwdDoubleText;
@property (weak, nonatomic) IBOutlet UITextField *identifyCodeText;
@property (weak, nonatomic) IBOutlet UIButton *getIdentifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *readProtocolBtn;
@property (weak, nonatomic) IBOutlet UIButton *userProtocolBtn;

@end

@implementation GYForgretPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBtnsBackground];
    
    self.phoneText.delegate = self;
    self.pwdText.delegate = self;
    self.pwdDoubleText.delegate = self;
    self.identifyCodeText.delegate = self;
}

// 初始化设置************
- (void)setBtnsBackground{
    self.confirmBtn.layer.cornerRadius = self.confirmBtn.gy_height/2;
    self.getIdentifyCodeBtn.layer.cornerRadius = 5;
}
// 获取验证码 *********************************************************
- (IBAction)getIdentifyCodeBtnClick:(id)sender {
    if (self.phoneText.text == nil || self.phoneText.text.length < 11) {
        [JWAlert showMsg:@"请输入正确手机号" WithOwner:self];
    }else{
        // 倒计时
        [self openCountdown];
        //发送验证码请求
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"mobile"] = self.phoneText.text;
        parameters[@"actname"] = @"forgetpwd";
        
        JWNetWorking *mgr = [JWNetWorking sharedManager];
        [mgr postRequestWithUrl:GYSentCodeURL parameter:parameters successBlock:^(id responseBody) {
            
        } failureBlock:^(NSString *error) {
            GYLog(@"%@", error);
        }];
        
        // 弹框提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码已发送到你手机" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:nil];
        });
 
    }
}

// 确认修改 *********************************************************
- (IBAction)confirmBtnClick:(id)sender {
    
    if ([self.phoneText.text isEqualToString:@""] || [self.pwdText.text isEqualToString:@""] || [self.pwdDoubleText.text isEqualToString:@""] || [self.identifyCodeText.text isEqualToString:@""]) {
        LXAlertView *v = [[LXAlertView alloc] initWithTitle:@"提示" message:@"请完整填写信息" cancelBtnTitle:nil otherBtnTitle:nil clickIndexBlock:^(NSInteger clickIndex) {
        }];
        [v showLXAlertView];
    }else if (![self.pwdText.text isEqualToString:self.pwdDoubleText.text]){
        LXAlertView *v = [[LXAlertView alloc] initWithTitle:@"提示" message:@"两次输入密码不一致" cancelBtnTitle:nil otherBtnTitle:nil clickIndexBlock:^(NSInteger clickIndex) {
        }];
        [v showLXAlertView];
    }else if(self.readProtocolBtn.selected == NO){
        
        LXAlertView *v = [[LXAlertView alloc] initWithTitle:@"提示" message:@"请阅读乐主用户条款" cancelBtnTitle:nil otherBtnTitle:nil clickIndexBlock:^(NSInteger clickIndex) {
            
        }];
        [v showLXAlertView];
    }else{
        // *************** 确认修改 ***************
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"mobile"] = self.phoneText.text;
        parameters[@"password"] = self.pwdText.text;
        parameters[@"code"] = self.identifyCodeText.text;
        
        JWNetWorking *mgr = [JWNetWorking sharedManager];
        [mgr postRequestWithUrl:GYForgetPwdURL parameter:parameters successBlock:^(id responseBody) {
            
            NSDictionary *dic = [responseBody mj_JSONObject];
            NSString *str = dic[@"code"];
            CGFloat code = [str integerValue];
            if (code == 0) {
                // 修改失败
                NSLog(@"修改失败");
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改失败" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertController animated:YES completion:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                });
            }else if (code == 1){
                // 修改成功
                NSLog(@"修改成功");
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertController animated:YES completion:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                    [self cancelBtnClick:nil];
                });
                
                
            }
        } failureBlock:^(NSString *error) {
            NSLog(@"%@", error);
        }];
        
    }

}

// 已读/未读用户协议 *********************************************************
- (IBAction)readProtocolBtnClick:(id)sender {
    self.readProtocolBtn.selected = !self.readProtocolBtn.selected;
}

// 取消
- (IBAction)cancelBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 协议详情 *********************************************************
- (IBAction)protocolBtnClick:(id)sender {
}


//开始编辑时 视图上移 如果输入框不被键盘遮挡则不上移。

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    CGFloat rects = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 +50);
    
    
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
                self.getIdentifyCodeBtn.layer.cornerRadius = 5;
                
                //设置按钮的样式
                [self.getIdentifyCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                //                [self.getIDCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]] forState:UIControlStateNormal];
                self.getIdentifyCodeBtn.backgroundColor = COLOR(244, 85, 62, 1);
                self.getIdentifyCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                self.getIdentifyCodeBtn.layer.cornerRadius = 5;
                [self.getIdentifyCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                //                [self.getIDCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
                self.getIdentifyCodeBtn.backgroundColor = [UIColor grayColor];
                
                self.getIdentifyCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
