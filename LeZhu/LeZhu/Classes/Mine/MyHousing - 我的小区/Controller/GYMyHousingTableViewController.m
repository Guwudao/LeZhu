//
//  GYMyHousingTableViewController.m
//  LeZhu
//
//  Created by apple on 17/2/27.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYMyHousingTableViewController.h"
#import "GYMyHousingDetailTableViewController.h"

static NSString *const myhouseID = @"cell1";

@interface GYMyHousingTableViewController ()

@end

@implementation GYMyHousingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:myhouseID];
    
    [self initNavBarBtn];
}


- (void)initNavBarBtn{
    self.navigationItem.title = @"所属区域";
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myhouseID forIndexPath:indexPath];

    cell.textLabel.text = @"霞山区";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYMyHousingDetailTableViewController *vc = [[GYMyHousingDetailTableViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
