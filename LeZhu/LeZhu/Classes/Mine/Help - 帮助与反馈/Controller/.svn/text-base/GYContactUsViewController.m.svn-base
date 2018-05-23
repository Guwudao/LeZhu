//
//  GYContactUsViewController.m
//  LeZhu
//
//  Created by apple on 17/2/27.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYContactUsViewController.h"
#import "LXAlertView.h"

@interface GYContactUsViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textV;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation GYContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTextView];
    
    self.submitBtn.layer.cornerRadius = 8;
}



// 点击提交按钮
- (IBAction)submitBtnClick:(id)sender {
    
    if (self.textV.text.length != 0) {
        // 提交文本内容到服务器
        [self networkRequired];
        
    }else{
        LXAlertView *v = [[LXAlertView alloc] initWithTitle:@"提示" message:@"请完整填写您的反馈" cancelBtnTitle:nil otherBtnTitle:nil clickIndexBlock:^(NSInteger clickIndex) {
        }];
        [v showLXAlertView];
    }
    
}

- (void)networkRequired{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];

    [SVProgressHUD showWithStatus:@"提交中"];
    
    JWNetWorking *mgr = [JWNetWorking sharedManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = uid;
    parameters[@"detail"] = self.textV.text;
    [mgr getRequestWithUrl:GYFeedbackURL parameter:parameters successBlock:^(id responseBody) {
        
        GYLog(@"%@", responseBody);
        [SVProgressHUD dismiss];
        [self showMsg:@"提交成功. 谢谢您的反馈, 我们会尽快处理."];
    } failureBlock:^(NSString *error) {
        GYLog(@"%@", error);
        [SVProgressHUD dismiss];
        [self showMsg:@"您的网络出现了一点问题,请重试"];
        
    }];
}


// 初始化文本placeholder和完成按钮
- (void)initTextView{
    self.textV.text = @"请反馈您的建议, 以便让我们做得更好";
    self.textV.textColor = [UIColor lightGrayColor];
    
    self.textV.layer.borderColor = [[UIColor grayColor] CGColor];
    self.textV.layer.borderWidth = 0.5;
    
    //创建键盘右上角小完成按钮
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenW, 40)];
    UIButton *completeEditBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenW - 60, 7, 50, 30)];
    [completeEditBtn setTitle:@"完成" forState:UIControlStateNormal];
    completeEditBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [completeEditBtn setTitleColor:DARKBLUE forState:UIControlStateNormal];
    [completeEditBtn addTarget:self action:@selector(completeEditBtnClick) forControlEvents:UIControlEventTouchUpInside ];
    [bar addSubview:completeEditBtn];
    self.textV.inputAccessoryView = bar;
    
}

// 点击完成按钮
- (void)completeEditBtnClick{
    [self.view endEditing:YES];
}

// 弹框
- (void)showMsg:(NSString *)msg{
    // 弹框提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - Text view delegate

-(void)textViewDidEndEditing:(UITextView *)textView{
    if(textView.text.length < 1){
        textView.text = @"请反馈您的建议, 以便让我们做得更好";
        textView.textColor = [UIColor grayColor];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"请反馈您的建议, 以便让我们做得更好"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}


@end
