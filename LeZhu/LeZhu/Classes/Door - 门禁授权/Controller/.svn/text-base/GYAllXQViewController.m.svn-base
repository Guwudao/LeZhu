//
//  GYAllXQViewController.m
//  LeZhu
//
//  Created by apple on 17/3/8.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYAllXQViewController.h"
#import "GYxqModel.h"
#import "GYXQListTableViewCell.h"
#import "GYGetApproveViewController.h"

static NSString *const XQcellID = @"xqcell";

@interface GYAllXQViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>
@property(nonatomic, strong)NSMutableArray *xqArr;      // 过滤前的小区模型数组

@property(nonatomic, strong)NSMutableArray *searchArr;  // 过滤后的小区模型数组

@property(nonatomic, strong)NSArray *searchList;        // 过滤后的小区名字数组

@property(nonatomic, strong)NSMutableArray *xqList;     // 过滤前的小区名字数组

@property(nonatomic, strong)GYxqModel *chosenModel;     // 选中的模型


@property(nonatomic, assign)BOOL isSearch;

@end

@implementation GYAllXQViewController

-(NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr = [NSMutableArray array];
    }
    return _searchArr;
}

-(NSMutableArray *)xqList{
    if (!_xqList) {
        _xqList = [NSMutableArray array];
    }
    return _xqList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"所有小区";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GYXQListTableViewCell" bundle:nil] forCellReuseIdentifier:XQcellID];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self networkRequired];
    
    [self setupRefresh];
    
    [self addSearchBar];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

// 加上 搜索栏
- (void)addSearchBar{
    //加上 搜索栏
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 200, 35)];//allocate titleView
    UIColor *color =  self.navigationController.navigationBar.barTintColor;
    
    [titleView setBackgroundColor:color];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    
    searchBar.delegate = self;
    searchBar.frame = CGRectMake(0, 2, 200, 30);
    searchBar.backgroundColor = color;
    searchBar.layer.cornerRadius = 10;
    searchBar.layer.masksToBounds = YES;
    [searchBar.layer setBorderWidth:8];
    [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];  //设置边框为白色
    searchBar.tintColor=[UIColor orangeColor];
    searchBar.placeholder = @"搜索你要找的小区         ";
    
    [titleView addSubview:searchBar];
    
    //Set to titleView
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = titleView;
}

- (void)setupRefresh{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(networkRequired)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    self.tableView.mj_header = header;
}

- (void)networkRequired{
    [SVProgressHUD showWithStatus:@"加载中"];
    JWNetWorking *mgr = [JWNetWorking sharedManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"city"] = @"湛江市";
    [mgr getRequestWithUrl:GYXQListURL parameter:parameters successBlock:^(id responseBody) {
        
        NSArray *extraArr = responseBody[@"extra"]; // 字典数组
        _xqArr = [GYxqModel mj_objectArrayWithKeyValuesArray:extraArr];
        
        
        // 把所有名字保存进一个数组
        for (GYxqModel *model in _xqArr) {
            NSString *xqname = model.name;
            [self.xqList addObject:xqname];
        }
        

        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSString *error) {
        GYLog(@"%@", error);
        [self.tableView.mj_header endRefreshing];

        [SVProgressHUD dismiss];
        [JWAlert showMsg:@"网络不通畅, 请稍后再试" WithOwner:self];

    }];
}


#pragma mark - table view datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearch == YES) {
        return _searchList.count;
    }else{
        
        return _xqArr.count;

    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYXQListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XQcellID forIndexPath:indexPath];
    
    

    
    // 如果处于搜索状态
    if(_isSearch == YES)
    {
        GYxqModel *model2 = _searchArr[indexPath.row];

        // 使用searchData作为表格显示的数据
        cell.xqnameL.text = model2.name;
        
        cell.xqaddressL.text = model2.address;
    }
    else{
        GYxqModel *model = _xqArr[indexPath.row];

        // 否则使用原始的tableData作为表格显示的数据
        cell.xqnameL.text = model.name;
        
        cell.xqaddressL.text = model.address;
    }
    
    
 
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
//    GYxqModel *model = [GYxqModel new];
    if (_isSearch == YES) {
        _chosenModel = _searchArr[indexPath.row];
    }else{
        _chosenModel = _xqArr[indexPath.row];
    }
    
    
    
    
    JWNetWorking *mgr = [JWNetWorking sharedManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"xqid"] = _chosenModel.xqid;

    [mgr getRequestWithUrl:GYGetHouseURL parameter:parameters successBlock:^(id responseBody) {        

        
        NSDictionary *extraDic = responseBody[@"extra"];
        
        NSArray *bdListArr = extraDic[@"bdList"];
        

        UIStoryboard *stb = [UIStoryboard storyboardWithName:@"GYGetApproveViewController" bundle:nil];
        GYGetApproveViewController *vc = [stb instantiateInitialViewController];
        
        vc.bdDicArr = bdListArr;
        vc.xqname = _chosenModel.name;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
//        self.hidesBottomBarWhenPushed = YES;
        
    } failureBlock:^(NSString *error) {
        GYLog(@"%@", error);
        [JWAlert showMsg:@"网络堵塞, 请重试" WithOwner:self];
    }];
    

}

#pragma mark - search bar delegate

// UISearchBarDelegate定义的方法，用户单击取消按钮时激发该方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    GYLog(@"----searchBarCancelButtonClicked------");
    // 取消搜索状态
    _isSearch = NO;
    [self.tableView reloadData];
}


// UISearchBarDelegate定义的方法，当搜索文本框内文本改变时激发该方法
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    GYLog(@"----textDidChange------");
    // 调用filterBySubstring:方法执行搜索
    [self filterBySubstring:searchText];
    if (searchText.length == 0) {
        // 取消搜索状态
        _isSearch = NO;
        [searchBar resignFirstResponder];

        [self.tableView reloadData];
    }
}

// UISearchBarDelegate定义的方法，用户单击虚拟键盘上Search按键时激发该方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    GYLog(@"----searchBarSearchButtonClicked------");
    // 调用filterBySubstring:方法执行搜索
    [self filterBySubstring:searchBar.text];
    // 放弃作为第一个响应者，关闭键盘
    [searchBar resignFirstResponder];
}

- (void) filterBySubstring:(NSString*) subStr
{
    GYLog(@"----filterBySubstring------");
    // 设置为搜索状态
    _isSearch = YES;
    // 定义搜索谓词
    NSPredicate* pred = [NSPredicate predicateWithFormat:
                         @"SELF CONTAINS[c] %@" , subStr];
    // 使用谓词过滤NSArray
    _searchList = [_xqList filteredArrayUsingPredicate:pred];
    
    
    // 转回模型数组
    for (NSString *searchStr in _searchList) {
        for (GYxqModel *model in _xqArr) {
            if ([searchStr isEqualToString:model.name]) {
                [self.searchArr addObject:model];
            }
        }
    }
    
    
    GYLog(@"%@", _xqList);
    GYLog(@"%@", _searchList);
    // 让表格控件重新加载数据
    [self.tableView reloadData];
}

@end
