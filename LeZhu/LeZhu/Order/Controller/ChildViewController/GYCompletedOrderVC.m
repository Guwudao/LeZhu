//
//  GYCompletedOrderVC.m
//  LeZhu
//
//  Created by apple on 17/2/4.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYCompletedOrderVC.h"
#import "GYPayCell.h"
#import "YZDisplayViewHeader.h"


static NSString *payCellID = @"fuckHer";
@interface GYCompletedOrderVC ()

@end

@implementation GYCompletedOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = COLOR(239, 239, 244, 1);
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GYPayCell" bundle:nil] forCellReuseIdentifier:payCellID];

    [self loadNetworkData];
}


// 加载网络数据
- (void)loadNetworkData{
    GYLog(@"滚动结束, 加载数据33");
    

}



#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150+10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYPayCell *cell = [tableView dequeueReusableCellWithIdentifier:payCellID forIndexPath:indexPath];
    // Configure the cell...
    cell.payStatusL.text = @"已完成";
    [cell.cancelBtn setTitle:@"我草泥马" forState:UIControlStateNormal];
    [cell.payBtn removeFromSuperview];
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
