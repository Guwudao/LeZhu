//
//  GYMyHousingDetailTableViewController.m
//  LeZhu
//
//  Created by apple on 17/2/27.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYMyHousingDetailTableViewController.h"

static NSString *const detailID = @"cell2";


@interface GYMyHousingDetailTableViewController ()

@end

@implementation GYMyHousingDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:detailID];
    
    self.navigationItem.title = @"霞山区";

}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailID forIndexPath:indexPath];
    
    cell.textLabel.text = @"海景小区";
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

@end
