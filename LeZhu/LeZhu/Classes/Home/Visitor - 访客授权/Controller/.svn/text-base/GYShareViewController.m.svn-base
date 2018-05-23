//
//  GYShareViewController.m
//  LeZhu
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYShareViewController.h"
#import "UMSocialUIManager.h"


@interface GYShareViewController ()
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adaptWidthCons;
@property (weak, nonatomic) IBOutlet UILabel *validTimeL;
@property (copy, nonatomic) NSString *time;

@end

@implementation GYShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetting];
    
    [SVProgressHUD showWithStatus:@"正在生成密码"];
    
    [self networkRequired];
   
    _adaptWidthCons.constant = screenW - 35;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

- (void)networkRequired{
    JWNetWorking *mgr = [JWNetWorking sharedManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"devKey"] = self.devKey;
    NSLog(@"self.devKey为%@", self.devKey);
    [mgr getRequestWithUrl:GYGetPasswordURL parameter:parameters successBlock:^(id responseBody) {
        NSLog(@"%@", responseBody);
        
        NSDictionary *dic = responseBody[@"extra"];
        
        NSString *tempPwd = dic[@"pwd"];
        
        [SVProgressHUD dismiss];
        
        self.passwordTextV.text = tempPwd;
        
        NSString *validTime = [self getValidTime];
        self.validTimeL.text = [NSString stringWithFormat:@"临时密码有效至:%@", validTime];
        
    } failureBlock:^(NSString *error) {
        NSLog(@"请求临时密码错误%@", error);
        [SVProgressHUD dismiss];
        [self showMsg:@"请求超时,请重试"];
        
    }];
    
}

- (NSString *)getValidTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:00"];
    NSString*dateTime = [formatter stringFromDate:[NSDate  dateWithTimeIntervalSinceNow:2*60*60]];
    self.time = dateTime;
    return dateTime;
}

- (void)initSetting{
    self.navigationItem.title = @"临时密码";

    self.passwordTextV.layer.cornerRadius = 4;
    
    self.shareBtn.layer.cornerRadius = 4;
    
    self.devNameLabel.layer.cornerRadius = 4;
    
    self.devNameLabel.text = self.devName;

}

// 点击分享按钮
- (IBAction)shareBtnClick:(id)sender {
    // 分享测试 ****************
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        // 根据获取的platformType确定所选平台进行下一步操作
        UMSocialMessageObject *msgObject = [UMSocialMessageObject messageObject];
        msgObject.text = [NSString stringWithFormat:@"%@的临时密码为%@,有效期至%@, 请在门禁主机上输入，按#号确定，按*号取消。", self.devNameLabel.text, self.passwordTextV.text, self.time];
        
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:msgObject currentViewController:self completion:^(id result, NSError *error) {
            if (error) {
                NSLog(@"fail");
            }else{
                NSLog(@"分享成功");
            }
        }];
    }];
}


- (void) showMsg:(NSString *) msg
{
    // 弹框提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
    
}

@end
