//
//  GYNotPayOrderVC.m
//  LeZhu
//
//  Created by apple on 17/2/4.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYNotPayOrderVC.h"
#import "GYPayCell.h"
#import "YZDisplayViewHeader.h"

static NSString *payCellID = @"fucku";

@interface GYNotPayOrderVC ()<GYPayCellProtocol>

@end

@implementation GYNotPayOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR(239, 239, 244, 1);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GYPayCell" bundle:nil] forCellReuseIdentifier:payCellID];

    [self loadData];
}


//加载网络数据
-(void)loadData{
    
    NSUserDefaults *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:1];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"cUserId"] = userID;
    parameter[@"type"] = @"0";
    parameter[@"currPage"] = indexPath;
    
    JWNetWorking *mgr = [JWNetWorking sharedManager];
    [mgr postRequestWithUrl:GYCheckOutOrdersURL parameter:parameter successBlock:^(id responseBody) {
        
    } failureBlock:^(NSString *error) {
        
    }];
}




#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150+10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYPayCell *cell = [tableView dequeueReusableCellWithIdentifier:payCellID forIndexPath:indexPath];
    cell.delegate = self;
    // Configure the cell...
    
    return cell;
}


#pragma mark - GYPayCell delegate
- (void)payBtnClick:(GYPayCell *)payCell{
    GYLog(@"点击确认付款");
}

- (void)cancelOrderBtnClick:(GYPayCell *)payCell{
    GYLog(@"点击取消订单");
}

@end
