//
//  GYGetApproveViewController.m
//  LeZhu
//
//  Created by apple on 17/3/8.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYGetApproveViewController.h"

@interface GYGetApproveViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *buildingNoText;
@property (weak, nonatomic) IBOutlet UITextField *ownerText;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (strong, nonatomic) UIPickerView *buildingNoPickerV;

@property (strong, nonatomic) UIPickerView *ownerPickerV;

@property (strong, nonatomic)NSArray *ownerPickerArr;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UILabel *xqNameL;

@property (nonatomic, copy) NSString *houseid;

// 记录当前选中的是哪一个楼栋的角标.
@property(nonatomic, assign) NSInteger curProIndex;

@property(nonatomic, copy)NSString *lastText;

@end

@implementation GYGetApproveViewController

-(NSArray *)ownerPickerArr{
    if (!_ownerPickerArr) {
        _ownerPickerArr = @[@"业主", @"家属", @"租客"];
    }
    return _ownerPickerArr;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatOwnerTextPickV];
    
    [self creatBuildingPickV];
    
    [self initSetting];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.hidesBottomBarWhenPushed = YES;
    [SVProgressHUD dismiss];
}


- (void)initSetting{
    self.submitBtn.layer.cornerRadius = 8;
    
    self.xqNameL.text = self.xqname;
    
    self.phoneLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    
    NSDictionary *bdDic1 = self.bdDicArr[0];
    //获取楼栋的名称
    NSString *bdname = bdDic1[@"bdname"]; // 拿bdname
    //获取当前选中省下面选中的城市名称.
    NSArray *houseArr = bdDic1[@"houses"];
    NSDictionary *houseDic = houseArr[0];
    NSString *housename =  houseDic[@"housename"]; // 拿housename
    NSString *houseid = houseDic[@"id"];  // 拿house id
    self.houseid = houseid;
    GYLog(@"%@, %@, %@", bdname, housename, houseid);
    //显示数据
    self.buildingNoText.text = [NSString stringWithFormat:@"%@ %@", bdname, housename];
}

- (void)creatOwnerTextPickV{
    
    _ownerPickerV = [[UIPickerView alloc] init];
    _ownerPickerV.backgroundColor = [UIColor whiteColor];
    _ownerPickerV.tag = 0;
    _ownerPickerV.delegate = self;
    _ownerPickerV.dataSource = self;
    self.ownerText.inputView = _ownerPickerV;
    
}

-(void) pickerHechoClicked :(id)sender{

    [self.view endEditing:YES];
}

- (void)creatBuildingPickV{
    _buildingNoPickerV = [[UIPickerView alloc] init];
    _buildingNoPickerV.backgroundColor = [UIColor whiteColor];
    _buildingNoPickerV.tag = 1;
    _buildingNoPickerV.delegate = self;
    _buildingNoPickerV.dataSource = self;
    self.buildingNoText.inputView = _buildingNoPickerV;
    
    // 添加完成按钮
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", @"Button")                                                                                                         style:UIBarButtonItemStylePlain target:self                                                                   action:@selector(pickerHechoClicked:)];
    
    doneButton.tintColor = [UIColor blueColor];
    
    //Para ponerlo a la derecha del todo voy a crear un botón de tipo Fixed Space
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace                                                                                    target:nil action:nil];
    
    fixedSpace.width = keyboardDoneButtonView.frame.size.width - 100;
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:fixedSpace, doneButton, nil]];
    
    self.buildingNoText.inputAccessoryView = keyboardDoneButtonView;
}

// 点击确认提交
- (IBAction)submitBtnClick:(id)sender {
    if (self.nameText.text.length != 0) {
        
        NSString *rpidStr = 0;
        if ([self.ownerText.text isEqualToString:@"业主"]) {
            rpidStr = @"1";
        }else if([self.ownerText.text isEqualToString:@"家属"]){
            rpidStr = @"2";
        }else{
            rpidStr = @"3";
        }
        
        [SVProgressHUD showWithStatus:@"提交中.."];
        
        JWNetWorking *mgr = [JWNetWorking sharedManager];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"houseid"] = self.houseid;
        parameters[@"rpid"] = rpidStr;
        parameters[@"name"] = self.nameText.text;
        parameters[@"mobile"] = self.phoneLabel.text;
        
        [mgr getRequestWithUrl:GYApproveURL parameter:parameters successBlock:^(id responseBody) {
            
            GYLog(@"%@", responseBody[@"msg"]);
            GYLog(@"%@", responseBody);
            [JWAlert showMsg:@"提交成功，请耐心等待审核" WithOwner:self];
            [SVProgressHUD dismiss];
            
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController popViewControllerAnimated:YES];
            
        } failureBlock:^(NSString *error) {
            GYLog(@"%@", error);
            
            [SVProgressHUD dismiss];

        }];

    }else{
        [self showMsg:@"请完整填写您的信息"];
    }
    
    
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.view endEditing:YES];

}

#pragma mark - UIPickerView data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView.tag == 0) {
        return 1;
    }else{
        return 2;

    }
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
        return 3;
    }else{
        if (component == 0) {  //选楼栋
            return self.bdDicArr.count;
        }else{
                NSDictionary *bdDic = self.bdDicArr[self.curProIndex];
                NSArray *houseDicArr = bdDic[@"houses"];
                return houseDicArr.count;
        }
        
        
    }
    return  0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    if (pickerView.tag == 0) {
        return self.ownerPickerArr[row];
    }else{
        if (component == 0) {
            NSDictionary *bdDic = self.bdDicArr[row];
            return bdDic[@"bdname"];
        }else{
            NSDictionary *bdDic1 = self.bdDicArr[self.curProIndex];
            NSArray *houseArr1 = bdDic1[@"houses"];
            NSDictionary *houseDic = houseArr1[row];
            return houseDic[@"housename"];
        }
    }

    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
        self.ownerText.text = self.ownerPickerArr[row];
        [self.view endEditing:YES];
    }else if(pickerView.tag == 1){
//        self.buildingNoText.text =
        // 把楼房号赋值给对应的text
        if (component == 0) {
            self.curProIndex = row;
            [pickerView reloadAllComponents];
            // 让第1列的第0行成为选中状态.(让城市列每次刷新时,都选中第一个)
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }
        NSDictionary *bdDic1 = self.bdDicArr[self.curProIndex];
        //获取楼栋的名称
        NSString *bdname = bdDic1[@"bdname"]; // 拿bdname
        //获取第一列选中的行号.(housename列)
        NSInteger seleRow = [pickerView selectedRowInComponent:1];
        //获取当前选中省下面选中的城市名称.
        NSArray *houseArr = bdDic1[@"houses"];
        NSDictionary *houseDic = houseArr[seleRow];
        NSString *housename =  houseDic[@"housename"]; // 拿housename
        NSString *houseid = houseDic[@"id"];  // 拿house id
        self.houseid = houseid;
        GYLog(@"%@, %@, %@", bdname, housename, houseid);
        //显示数据
        self.buildingNoText.text = [NSString stringWithFormat:@"%@ %@", bdname, housename];
    }
}

- (void)showMsg:(NSString *)msg{
    // 弹框提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });

}

@end
