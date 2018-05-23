//
//  GYChangePwdViewController.m
//  LeZhu
//
//  Created by apple on 17/3/7.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYChangePwdViewController.h"
#import "LXAlertView.h"

@interface GYChangePwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextF;

@property (weak, nonatomic) IBOutlet UITextField *pwdNewTextF;

@property (weak, nonatomic) IBOutlet UITextField *pwdDoubleCheckTextF;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation GYChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self initSetting];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

// 点击确认
- (IBAction)confirmBtnClick:(id)sender {
    
    
    [self updatePwd];

}


- (void)initSetting{
    
    self.navigationItem.title = @"修改密码";
    
    self.confirmBtn.layer.cornerRadius = 5;
    
}


- (void)updatePwd{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *oldPwd = [def objectForKey:@"password"];
    
    if (![self.oldPwdTextF.text isEqualToString:oldPwd] ) {
        LXAlertView *v = [[LXAlertView alloc] initWithTitle:@"提示" message:@"旧密码不正确" cancelBtnTitle:nil otherBtnTitle:nil clickIndexBlock:^(NSInteger clickIndex) {
        }];
        [v showLXAlertView];
    }else if (![self.pwdNewTextF.text isEqualToString:self.pwdDoubleCheckTextF.text]){
        LXAlertView *v = [[LXAlertView alloc] initWithTitle:@"提示" message:@"您两次的新密码不一致" cancelBtnTitle:nil otherBtnTitle:nil clickIndexBlock:^(NSInteger clickIndex) {
        }];
        [v showLXAlertView];
    }else if(self.pwdNewTextF.text.length == 0 || self.pwdDoubleCheckTextF.text.length == 0){
        LXAlertView *v = [[LXAlertView alloc] initWithTitle:@"提示" message:@"请输入两次新密码" cancelBtnTitle:nil otherBtnTitle:nil clickIndexBlock:^(NSInteger clickIndex) {
        }];
        [v showLXAlertView];
    }else{
        [self networkRequired];

    }
    
}

- (void)networkRequired{

    [SVProgressHUD showWithStatus:@"提交中"];

    JWNetWorking *mgr = [JWNetWorking sharedManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    parameters[@"oldPassword"] = self.oldPwdTextF.text;
    parameters[@"newPassword"] = self.pwdNewTextF.text;

    [mgr getRequestWithUrl:GYChangeInfoURL parameter:parameters successBlock:^(id responseBody) {
        
        [[NSUserDefaults standardUserDefaults] setObject:self.pwdNewTextF.text forKey:@"password"];
        
        [SVProgressHUD dismiss];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(NSString *error) {
        GYLog(@"%@", error);
        LXAlertView *v = [[LXAlertView alloc] initWithTitle:@"提示" message:@"网络不好,请重试" cancelBtnTitle:nil otherBtnTitle:nil clickIndexBlock:^(NSInteger clickIndex) {
        }];
        [v showLXAlertView];
    }];

    
    
}

@end
