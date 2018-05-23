//
//  GYVisitorsTableViewController.m
//  LeZhu
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYVisitorsTableViewController.h"
#import "GYXiaoQuModel.h"
#import "GYDeviceModel.h"
#import "GYVisitorTableViewCell.h"
#import "PopoverView.h"
#import "GYShareViewController.h"
#import "GYBannerModel.h"
//#import "SDCycleScrollView.h"

static NSString *const cellID = @"cell";

@interface GYVisitorsTableViewController ()

@property(nonatomic, strong)NSArray *xqModelArr;

@property(nonatomic, strong)NSMutableArray *devModelArr;

@property(nonatomic, weak)UIButton *rightBtn;

@property(nonatomic, assign)NSInteger currentXQid;// 当前选中的小区id

@property (weak, nonatomic) IBOutlet UIImageView *bannerImgV;

@property(nonatomic, strong)NSMutableArray *popActionArr;// popover view

@property (nonatomic, strong)NSArray *bannerModelArr;



@end

@implementation GYVisitorsTableViewController

-(NSMutableArray *)popActionArr{
    if (!_popActionArr) {
        _popActionArr = [NSMutableArray array];
    }
    return _popActionArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerImgV.userInteractionEnabled = YES;
    
    [SVProgressHUD showWithStatus:@"加载中"];
    
    [self setBanner];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GYVisitorTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    
    [self setupNavBar];
    
    [self getXQNetworkRequest];

    [self setupRefresh];

}

- (void)setBanner{
    // get banner images
    NSMutableArray *bannerArr = [NSMutableArray array];
    
    JWNetWorking *mgr = [JWNetWorking sharedManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"2";
    [mgr getRequestWithUrl:GYBannerURL parameter:parameters successBlock:^(id responseBody) {
        NSDictionary *extraDic = responseBody[@"extra"];
        NSArray *Arr = extraDic[@"banners"];
        _bannerModelArr = [GYBannerModel mj_objectArrayWithKeyValuesArray:Arr];
        for (GYBannerModel *model in _bannerModelArr) {
            [bannerArr addObject:model.pic];
        }
        //        CGFloat newBannerH = bannerH;
        //
        //        if (iPhone5) {
        //            newBannerH = (bannerH * 568) / 667;
        //        }
        
//        SDCycleScrollView *bannerV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screenW, 150) imageURLStringsGroup:bannerArr];
//        if (_bannerModelArr.count == 1) {
//            bannerV.infiniteLoop = NO;
//        }else{
//            bannerV.infiniteLoop = YES;
//            bannerV.titlesGroup = @[@"", @"", @""];
//            bannerV.titleLabelHeight = 20;
//        }
//        bannerV.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
//        bannerV.delegate = self;
//        bannerV.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//        bannerV.autoScrollTimeInterval = 3;
//        bannerV.pageControlDotSize = CGSizeMake(7, 7);
//        
//        bannerV.pageControlBottomOffset = -3;
//        bannerV.placeholderImage = [UIImage imageNamed:@"banner"];
//        [self.bannerImgV addSubview:bannerV];
        GYLog(@"banner res %@", responseBody);
        //        [self addLineView];
        
    } failureBlock:^(NSString *error) {
        GYLog(@"banner error %@", error);
    }];
    
    
}



- (void)setupNavBar{
    self.navigationItem.title = @"设备列表";

    // 设置导航条右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBtn setTitle:@"      " forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    rightBtn.tintColor = [UIColor whiteColor];
    rightBtn.frame = CGRectMake(0, 0, 70, 30);
    rightBtn.userInteractionEnabled = NO;
    self.rightBtn = rightBtn;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 80, 30)];
    [view addSubview:rightBtn];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(rightBtn.gy_width - 5, 10, 10, 10)];
    imgV.image = [UIImage imageNamed:@"向下"];
    [view addSubview:imgV];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightBtnClick)]];
}

- (void)rightBtnClick{
    NSLog(@"弹出popover");
   
    // 创建popoverview
    for (NSInteger i = 0; i < _xqModelArr.count; i ++) {
        GYXiaoQuModel *xqModel = _xqModelArr[i];
        PopoverAction *ac = [PopoverAction actionWithImage:nil title:xqModel.name handler:^(PopoverAction *action) {
            
            [self.rightBtn setTitle:xqModel.name forState:UIControlStateNormal];
            
            self.currentXQid = xqModel.xqid;
            
            [self.tableView.mj_header beginRefreshing];
            
            [self getDevListNetworkRequired];
        }];
        [self.popActionArr addObject:ac];
    }

    if (self.popActionArr.count != 0) {
        PopoverView *popV = [[PopoverView alloc] init];
        popV.showShade = YES; // 显示阴影背景
        //    popV.style = PopoverViewStyleDark; // 设置为黑色风格
        [popV showToView:self.rightBtn withActions:_popActionArr];
        
        [_popActionArr removeAllObjects];
    }

    
}

- (void)setupRefresh{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getDevListNetworkRequired)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    self.tableView.mj_header = header;
}

// 获取授权小区列表
- (void)getXQNetworkRequest{
    // 取出Userdefault里面的电话
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *phone = [def valueForKey:@"phone"];
    // 如果有保存到账号
    if (phone.length != 0) {
        JWNetWorking *mgr = [JWNetWorking sharedManager];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"mobile"] = phone;
        
        [mgr getRequestWithUrl:GYGetXQURL parameter:parameters successBlock:^(id responseBody) {
            
            [self.tableView.mj_header endRefreshing];
            
            [SVProgressHUD dismiss];

            // 解析数据
            NSMutableArray *XQDicArr = responseBody[@"extra"];
            _xqModelArr = [GYXiaoQuModel mj_objectArrayWithKeyValuesArray:XQDicArr]; // 所有授权小区
            
            if (_xqModelArr.count != 0) {
                GYXiaoQuModel *xqModel = _xqModelArr.firstObject;
                // 保存当前选中的小区id
                self.currentXQid = xqModel.xqid;
                
                NSLog(@"当前选中的小区id %ld", self.currentXQid);
                
                // 设置右上角显示内容
                [self.rightBtn setTitle:xqModel.name forState:UIControlStateNormal];
                
                // 获取当前小区的设备列表
                [self getDevListNetworkRequired];
                
                
                [self.tableView reloadData];
            }else{
                [self.rightBtn setTitle:@"无授权小区" forState:UIControlStateNormal];
                [JWAlert showMsg:@"您还没有授权的小区" WithOwner:self];
            }
            

            
        } failureBlock:^(NSString *error) {
            GYLog(@"%@", error);
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self showMsg:@"网络不通畅，请稍后重试"];

        }];
    }else{
        [self showMsg:@"请先登录.."];
    }
    
}

// 获取当前小区的设备列表
- (void)getDevListNetworkRequired{
    JWNetWorking *mgr = [JWNetWorking sharedManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mobile"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    parameters[@"xqid"] = [NSString stringWithFormat:@"%ld", self.currentXQid];
    [mgr getRequestWithUrl:GYGetXQDevicesURL parameter:parameters successBlock:^(id responseBody) {
        GYLog(@"该小区的设备列表%@", responseBody);
        [self.tableView.mj_header endRefreshing];

        NSMutableArray *devDicArr = responseBody[@"extra"];
        _devModelArr = [GYDeviceModel mj_objectArrayWithKeyValuesArray:devDicArr];

        [self.tableView reloadData];
    } failureBlock:^(NSString *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self showMsg:@"网络不通畅，请稍后重试"];
        
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

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _devModelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GYVisitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    GYDeviceModel *model = _devModelArr[indexPath.row];
    
    cell.xiaoQuL.text = model.devname;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GYDeviceModel *model = _devModelArr[indexPath.row];
    
    UIStoryboard *stb = [UIStoryboard storyboardWithName:@"GYShareViewController" bundle:nil];
    GYShareViewController *vc = [stb instantiateInitialViewController];

    vc.devKey = model.devkey;
    
    vc.devName = model.devname;
    
    vc.xqName = model.name;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 轮播图代理

//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    GYLog(@"点击了第%ld张广告",index);
//    
//}

@end
