//
//  GYChangeNameViewController.m
//  LeZhu
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYChangeNameViewController.h"

@interface GYChangeNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation GYChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改昵称";

    self.confirmBtn.layer.cornerRadius = 4;
    
    self.textF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    
   
}

- (IBAction)confirmBtnClick:(id)sender {
    [SVProgressHUD showWithStatus:@"提交中,请稍等.."];
    
    JWNetWorking *mgr = [JWNetWorking sharedManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]);
    parameters[@"nickname"] = self.textF.text;
    [mgr getRequestWithUrl:GYChangeInfoURL parameter:parameters successBlock:^(id responseBody) {
        
        [[NSUserDefaults standardUserDefaults] setObject:self.textF.text forKey:@"name"];
        
        [SVProgressHUD dismiss];

        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(NSString *error) {
        GYLog(@"%@", error);
    }];
}


@end
