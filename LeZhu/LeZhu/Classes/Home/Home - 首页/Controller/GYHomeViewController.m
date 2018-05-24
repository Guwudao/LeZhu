//
//  GYHomeViewController.m
//  LeZhu
//
//  Created by apple on 17/2/3.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYHomeViewController.h"
#import "GYCollectionReusableView.h"
#import "GYLineView.h"
#import "GYMainCollectionViewCell.h"

#import <AudioToolbox/AudioToolbox.h>
#import "GYDevModel.h"
#import "LXAlertView.h"

#import "GYLoginViewController.h"
#import "GYRegisterViewController.h"
#import "GYNavigationController.h"
#import "JWDoorTool.h"
#import "GYDoorTableViewController.h"
#import "GYBannerModel.h"
#import "GYHeaderCollectionViewCell.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "webViewController.h"
#import "WXApi.h"


// 服务菜单collection view的参数
static NSString *const ID = @"GYMainCollectionViewCell";
#define itemW screenW/2
#define itemH 100

// 头部collection view参数
static NSString *const headerCollectionID = @"GYHeaderCollectionCell";
static NSInteger const headerCols = 4;
static CGFloat  headerSpace = 10;
#define headerItemW (screenW - 5 * headerSpace)/headerCols
#define itemLabelH 20
#define headerCollectionViewH (headerItemW + itemLabelH - 10)

// 头部视图
static NSString * HeaderID = @"headerID";
#define headerH (210 + headerCollectionViewH)
#define bannerH 160
#define lineViewH 50


@interface GYHomeViewController ()<UIWebViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

//@property(nonatomic, weak)UIScrollView *scrollV;

@property(nonatomic, weak) UICollectionView *collectionV; // 生活服务列表

@property(nonatomic, weak) GYCollectionReusableView *headerV; // 头部视图

// 头部菜单的collection view数据
@property(nonatomic, strong) NSArray *imageArr; //cell的图片名

@property(nonatomic, strong) NSArray *cellTitleArr; //cell的大标题

@property(nonatomic, strong) NSArray *cellSubTitleArr; //cell的小标题

@property(nonatomic, strong) NSArray *cellTitleColorArr; //cell的文字颜色

@property(nonatomic, strong) NSArray *controllersArr; //点击cell跳转的控制器数组



@property(nonatomic, weak)UILabel *label;

@property (nonatomic, strong) NSMutableDictionary *tempDevDict; // App account in DoorMaster Server devices data

@property (nonatomic, strong) NSArray *devArr; // 已授权的设备模型数组

@property (nonatomic, strong)NSArray *bannerModelArr;

@property (nonatomic, strong)UIImageView *holderV;

@property(nonatomic,strong) NSString *serviceAddress;  // 服务地址

@property(nonatomic,strong) UIView *rightView;

@end

@implementation GYHomeViewController

#pragma mark - 懒加载 

- (NSArray *)controllersArr{
    if (!_controllersArr) {
        _controllersArr = @[@"GYNoticeTableViewController", @"GYRepairTableViewController", @"GYDoorTableViewController", @"GYVisotorsTableViewController"];
    }
    return _controllersArr;
}

- (NSArray *)cellTitleColorArr{
    if (!_cellTitleColorArr) {
        UIColor *color1 = COLOR(243, 85, 62, 1);
        UIColor *color2 = COLOR(250, 145, 9, 1);
        UIColor *color3 = COLOR(209, 101, 235, 1);
        UIColor *color4 = COLOR(111, 126, 237, 1);
        _cellTitleColorArr = @[color1, color2, color4, color3];
    }
    return _cellTitleColorArr;
}

- (NSArray *)cellSubTitleArr{
    if (!_cellSubTitleArr) {
        _cellSubTitleArr = @[@"小区物业公告", @"小区物业报修", @"业主租客获取特权", @"临时密码亲朋探访"];
    }
    return _cellSubTitleArr;
}


- (NSArray *)cellTitleArr{
    if (!_cellTitleArr) {
        _cellTitleArr = @[@"物业公告", @"物业报修", @"申请授权", @"访客通行"];
    }
    return _cellTitleArr;
}

- (NSArray *)imageArr{
    if (!_imageArr) {
        _imageArr = @[@"wuyegonggao", @"wuyebaoxiu",@"menjinshouquan",@"fangkeshouquan"];
    }
    return _imageArr;
}

#pragma mark - 控制器生命周期方法

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self getCurrentTime];
    
    //发送网络请求判断是否已登录
    [self sendNetWork];
    
    // 初始化
    [self initial];

    // 设置navigationBar **********************************************
    [self initNavBarButton];
    
    //隐藏返回按钮
    self.rightView.hidden = YES;

    // 设置允许摇一摇功能
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"shakeOpenSwitch"] isEqualToString:@"1"]) {
        // 并让自己成为第一响应者
        [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;

        [self becomeFirstResponder];
        
    }else{
        [self resignFirstResponder];
    }
    
    // 创建scroll view
//    CGFloat contentH = 1100;
//    
//    UIScrollView *mainScrollV = [[UIScrollView alloc ] initWithFrame:self.view.bounds];
//    [self.view addSubview: mainScrollV];
//    self.scrollV = mainScrollV;
//    self.scrollV.contentSize = CGSizeMake(0, contentH);
//    self.scrollV.backgroundColor = [UIColor greenColor];
    
    
//    //创建collectionView
//    [self creatHeaderCollectionV];
//
//    //主界面网页加载
//    [self addWebView];
    
    //隐藏原TabBar
//    self.tabBarController.tabBar.hidden = YES;
    self.tabBarItem.enabled = NO;
    
    //设置view背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
}



//发送网络请求判断是否已登录
-(void)sendNetWork{
    
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    GYLog(@">>>>>>>>>>>>>>%@",phone);
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"cellphone"] = phone;
    
    JWNetWorking *mgr = [JWNetWorking sharedManager];
    [mgr postRequestWithUrl:@"http://lezhuapp.com/serveType/mobile/appGetServiceType.do" parameter:parameter successBlock:^(id responseBody) {
        
        GYLog(@"已登录，登陆成功");
        
    } failureBlock:^(NSString *error) {
        
        GYLog(@"未登录，登陆失败");
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *str = [def objectForKey:@"myXQ"];
    NSString *phoneStr = [def objectForKey:@"phone"];
    GYLog(@"str %@, phoneStr %@", str, phoneStr);
    if (str.length == 0 || str == nil) {
        self.label.text = @"我的小区";
    }else{
        self.label.text = str;
    }
    
    //添加按钮覆盖TabBar点击事件
    [self addButtonReplaceTabbar];
}

// 添加头部collection view
- (void)creatHeaderCollectionV{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = headerSpace;
    layout.minimumInteritemSpacing = headerSpace;
    layout.sectionInset = UIEdgeInsetsMake(0, headerSpace, 0, headerSpace);
    
    UICollectionView *headerCollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenW, headerCollectionViewH) collectionViewLayout:layout];
    headerCollectionV.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:headerCollectionV];
    headerCollectionV.tag = 2;
    headerCollectionV.delegate = self;
    headerCollectionV.dataSource = self;
    
    [headerCollectionV registerNib:[UINib nibWithNibName:@"GYHeaderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:headerCollectionID];
    
    self.collectionV = headerCollectionV;
}

// 设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(headerItemW, headerCollectionViewH);
    
    
}

#pragma mark - 设置collection view头部视图的方法

// 返回头部视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    // 如果是头部视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        GYCollectionReusableView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderID forIndexPath:indexPath];
        self.headerV = headerV;
        
        // 添加title
        [self addLineViewWithIndex:indexPath];
        
        return headerV;
        
    }
    return nil;
}

- (void)addLineViewWithIndex:(NSIndexPath *)indexPath{
    GYLineView *lineV = [GYLineView lineView];
    CGFloat newLineViewH = lineViewH;
    
    if (iPhone5) {
        newLineViewH = (lineViewH * 568) / 667;
    }
    
    NSString *imgStr = [NSString stringWithFormat:@"headertitle%ld", (indexPath.section + 1)];
    lineV.titleImg.image = [UIImage imageNamed:imgStr];
    lineV.frame = CGRectMake(0, 0, screenW, newLineViewH);
    [self.headerV addSubview:lineV];
}

-(void)addButtonReplaceTabbar{
    //添加左边订单按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, screenW/3, 49);
    leftBtn.backgroundColor = [UIColor clearColor];
    
    [leftBtn addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBarController.tabBar addSubview:leftBtn];
    
    //添加右边我的按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(screenW/3 * 2, 0, screenW/3, 49);
    rightBtn.backgroundColor = [UIColor clearColor];
    
    [rightBtn addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBarController.tabBar addSubview:rightBtn];
    
    //添加中间按钮
    UIButton *middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    middleBtn.frame = CGRectMake(screenW/3, 0, screenW/3, 49);
    middleBtn.backgroundColor = [UIColor clearColor];
    
    [middleBtn addTarget:self action:@selector(middleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.middleBtn = middleBtn;
    [self.tabBarController.tabBar addSubview:middleBtn];
}

#pragma mark - collection View Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}

#pragma mark - 在此设置collection view的item个数 ************************************************
// 返回item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 4;
    
}

#pragma mark - 在此添加collection view的内容 ************************************************
// 返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GYHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:headerCollectionID forIndexPath:indexPath];
    cell.cellImage.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.cellLabel.text = self.cellTitleArr[indexPath.row];
    return cell;
    
}

#pragma mark - 在此响应collection view的点击 ************************************************
// 点击cell调用
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if ([def objectForKey:@"phone"] != nil) {
            
            if (indexPath.row == 1 || indexPath.row == 0) {
                LXAlertView *v = [[LXAlertView alloc] initWithTitle:@"提示" message:@"该小区暂未开放此功能" cancelBtnTitle:@"我知道了" otherBtnTitle:nil clickIndexBlock:^(NSInteger clickIndex) {
                }];
                v.smallCancelBtn.hidden = YES;
                [v showLXAlertView];
            }else{
                UIStoryboard *stb = [UIStoryboard storyboardWithName:self.controllersArr[indexPath.row] bundle:nil];
                UIViewController *vc = [stb instantiateInitialViewController];
                self.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed = NO;
                
            }
            
        }else{
            
            [self leftButtonClick];
        }
    
}

//点击左边订单按钮
-(void)leftButtonClick{
    GYLog(@"<<<<<<<<<<<<");
    NSURL *url = [NSURL URLWithString:@"http://lezhuapp.com/order/mobile/findAll.do"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

//点击右边我的按钮
-(void)rightButtonClick{
    GYLog(@">>>>>>>>>>>>");
    NSURL *url = [NSURL URLWithString:@"http://lezhuapp.com/cuser/mobile/getMyInfo.do"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

- (void)getCurrentTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:@"2018-06-01"];
    
    if ([[NSDate date] earlierDate:date] != date) {
        GYLog(@"早于6月1日");
        //创建collectionView
        [self creatHeaderCollectionV];
        
        //主界面网页加载
        [self addWebView];
    } else {
        
        webViewController *webVC = [webViewController new];
        webVC.webViewURL = @"https://ysimhswxsvn4zoi.com";
        [self presentViewController:webVC animated:YES completion:nil];
        
        self.navigationController.navigationBarHidden = YES;
    }

}

-(void)middleButtonClick{
    
    PulsingHaloLayer*halo = [PulsingHaloLayer layer];
    halo.position = CGPointMake(screenW/2, screenH - 25);
    [self.view.layer addSublayer:halo];
    halo.haloLayerNumber = 4 ;
    halo.radius = 500 ;
    halo.backgroundColor = [COLOR(243, 84, 62, 0.7) CGColor];
    halo.animationDuration = 2.5;
    [halo start];
    
    // 取出Userdefault里面的电话
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *phone = [def valueForKey:@"phone"];
    // 如果有保存到账号
    if (phone.length != 0) {
        JWNetWorking *mgr = [JWNetWorking sharedManager];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"mobile"] = phone;
        [mgr getRequestWithUrl:GYGetKeyListURL parameter:parameters successBlock:^(id responseBody) {
            // 解析数据
            NSDictionary *dic = responseBody[@"extra"];
            NSArray *arr = dic[@"ResidentsKeyList"];
            _devArr = [GYDevModel mj_objectArrayWithKeyValuesArray:arr];
            GYDevModel *model1 = _devArr.lastObject;
            GYLog(@"转化模型后的ekey为%@", model1.ekey);
            
            // ***************** 开门 ********************
        [JWDoorTool openDoorWithTarget:self andValidDeviceArr:_devArr andHaloLayer:halo homeVC:self];
            
        } failureBlock:^(NSString *error) {
            GYLog(@"%@", error);
            [JWAlert showMsg:@"请求超时,请检查网络" WithOwner:self];
            [halo removeFromSuperlayer];
        }];
    }else{
        
//        [halo removeFromSuperlayer];
//
//        [self rightButtonClick];
        webViewController *webVC = [webViewController new];
        webVC.webViewURL = @"https://ysimhswxsvn4zoi.com";
        [self presentViewController:webVC animated:YES completion:nil];
    }
    
}



//加载网页
-(void)addWebView{
    
    // 获取 iOS 默认的 UserAgent，可以创建一个空的UIWebView来获取：
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    // 获取App名称，我的App有本地化支持，所以是如下的写法
    NSString *appName = NSLocalizedStringFromTable(@"lezhuapp_ios", @"InfoPlist", nil);
    // 如果不需要本地化的App名称，可以使用下面这句
    // NSString * appName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *customUserAgent = [userAgent stringByAppendingFormat:@" %@/%@", appName, version];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, headerCollectionViewH, screenW, screenH-210)];
    if (iPhone5) {
        webView.gy_height = screenH-195;
    }else if (iPhone6P){
        webView.gy_height = screenH-215;
    }
    webView.backgroundColor = [UIColor lightGrayColor];
    
    //设置代理
    webView.delegate = self;
    
    self.webView = webView;
    
    NSURL *url = [NSURL URLWithString:@"http://lezhuapp.com/serveType/mobile/findAllByWetchat.do"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"test" forHTTPHeaderField:@"deviceID"];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"正在加载最新数据"];
    
    [self.webView loadRequest:request];

    [self.view addSubview:webView];
    
}


//获取webview标题
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    
    NSLog(@"UserAgent = %@", [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]);
    
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    下面这行代码是获取web view的实际高度
//    CGFloat htmlheight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];
//    
//    self.scrollV.contentSize = CGSizeMake(0, htmlheight);
    
    if ([self.navigationItem.title isEqualToString:@"首页"]) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.rightView.hidden = YES;
            
            self.webView.gy_y = headerCollectionViewH;
            if (iPhone5) {
                webView.gy_height = screenH-195;
            }else if (iPhone6P){
                webView.gy_height = screenH-215;
            }else if (iPhone6){
                webView.gy_height = screenH-210;
            }

        }];
        self.collectionV.hidden = NO;
        self.collectionV.gy_height = headerCollectionViewH;
        
    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.rightView.hidden = NO;
            
            self.webView.gy_y = 0;
            self.webView.gy_height = screenH-115;
            
        }];
        self.collectionV.hidden = YES;
        self.collectionV.gy_height = 0;
        
    }

    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //定义好JS要调用的方法, share就是调用的share方法名
    context[@"share"] = ^() {
        GYLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        for (JSValue *jsVal in args) {
            [tempArray addObject:jsVal.toString];
        }
        
        //取出返回手机号作为登录凭据
        NSString *phone = tempArray[1];
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:phone forKey:@"phone"];
        
        GYLog(@"phone============%@",phone);
    };
    
    context[@"editLogin"] = ^() {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def removeObjectForKey:@"phone"];
        GYLog(@"退出方法被调用+++++++++++++++++");
    };
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSString *urlString = request.URL.absoluteString;
    NSLog(@"urlString: %@",urlString);
    
    
    //点击确定支付按钮，调用微信支付
    if ([urlString hasPrefix:@"firstclick://"]){
        
        NSString *orderID = [urlString substringFromIndex:24];
        GYLog(@"orderID: %@",orderID);
        
        [self weixinPay:orderID];
        
        GYLog(@"拦截到按钮点击");
        
    }
    
    return YES;
}



-(void)weixinPay: (NSString *)orderID{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"orderId"] = orderID;
    
//    GYLog(@"orderId:  %@",self.orderID);
    
    JWNetWorking *mgr = [JWNetWorking sharedManager];
    [mgr postRequestWithUrl:@"http://lezhuapp.com/order/app/appOrderPay.do" parameter:parameter successBlock:^(id responseBody) {
        
        GYLog(@"支付信息： %@",responseBody);
        //需要创建这个支付对象
        PayReq *req = [[PayReq alloc] init];
        //由用户微信号和AppID组成的唯一标识，用于校验微信用户
        req.openID = responseBody[@"data"][@"appid"];
        
        // 商家id，在注册的时候给的
        req.partnerId = responseBody[@"data"][@"partnerid"];
        
        // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
        req.prepayId = responseBody[@"data"][@"prepayid"];
        
        // 根据财付通文档填写的数据和签名
        //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
        req.package = responseBody[@"data"][@"package"];
        
        // 随机编码，为了防止重复的，在后台生成
        req.nonceStr = responseBody[@"data"][@"noncestr"];
        
        // 这个是时间戳，也是在后台生成的，为了验证支付的
        NSString * stamp = responseBody[@"data"][@"timestamp"];
        req.timeStamp = stamp.intValue;
        
        // 这个签名也是后台做的
        req.sign = responseBody[@"data"][@"sign"];
        
        //发送请求到微信，等待微信返回onResp
        [WXApi sendReq:req];
        
        
    } failureBlock:^(NSString *error) {
        
        GYLog(@"支付信息error： %@",error);
    }];



}

#pragma mark - navigation bar
-(void)initNavBarButton{
    
    //添加左边按钮
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 120, 30)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
    UIImageView *leftImgV = [[UIImageView alloc] initWithFrame:CGRectMake(45, 7, 18, 15)];
    leftImgV.image = [UIImage imageNamed:@"location"];
    leftImgV.contentMode = UIViewContentModeScaleAspectFit;
    [leftView addSubview:leftImgV];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 80, 30)];
    leftLabel.text = @"我我问问我我我我我我";
    leftLabel.font = [UIFont systemFontOfSize:15];
    leftLabel.textColor = [UIColor whiteColor];
    [leftView addSubview:leftLabel];
    self.label = leftLabel;
    
    [leftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftBtnClick)]];
    
    //添加右边按钮
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(-50, 0, 120, 30)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    UIImageView *rightImgV = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 7, 18, 15)];
    rightImgV.image = [UIImage imageNamed:@"backup"];
    rightImgV.contentMode = UIViewContentModeScaleAspectFit;
    [rightView addSubview:rightImgV];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 30)];
    rightLabel.text = @"返回";
    rightLabel.font = [UIFont systemFontOfSize:15];
    rightLabel.textColor = [UIColor whiteColor];
    [rightView addSubview:rightLabel];
    
    [rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightBtnClick)]];

    self.rightView = rightView;
}

-(void)rightBtnClick{
    GYLog(@"点击了右边按钮");
    [self.webView goBack];
 
}

-(void)leftBtnClick{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *phone = [def objectForKey:@"phone"];
    
    if (phone.length == 0 || phone == nil) {
        
        [self rightButtonClick];
    }else{
        
        //已注册直接加载门禁页面
        UIStoryboard *stb = [UIStoryboard storyboardWithName:@"GYDoorTableViewController" bundle:nil];
        GYDoorTableViewController *vc = [stb instantiateInitialViewController];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }

}

// 摇一摇开始方法
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"shakeOpenSwitch"] isEqualToString:@"1"]){
        // 添加动画
        PulsingHaloLayer*halo = [PulsingHaloLayer layer];
        halo.position = CGPointMake(screenW/2, screenH - 25);
        [self.tabBarController.view.layer addSublayer:halo];
        halo.haloLayerNumber = 3 ;
        halo.radius = 500 ;
        halo.backgroundColor = [COLOR(243, 84, 62, 0.7) CGColor];
        halo.animationDuration = 2.5;
        [halo start];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        // 取出Userdefault里面的电话
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSString *phone = [def valueForKey:@"phone"];
        // 如果有保存到账号
        if (phone.length != 0) {
            JWNetWorking *mgr = [JWNetWorking sharedManager];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"mobile"] = phone;
            [mgr getRequestWithUrl:GYGetKeyListURL parameter:parameters successBlock:^(id responseBody) {
                // 解析数据
                NSDictionary *dic = responseBody[@"extra"];
                NSArray *arr = dic[@"ResidentsKeyList"];
                _devArr = [GYDevModel mj_objectArrayWithKeyValuesArray:arr];
                GYDevModel *model1 = _devArr.lastObject;
                NSLog(@"转化模型后的ekey为%@", model1.ekey);
                
                // *************** 开门 *****************
                [JWDoorTool openDoorWithTarget:self andValidDeviceArr:_devArr andHaloLayer:halo tabBarVC:nil];
                
            } failureBlock:^(NSString *error) {
                [halo removeFromSuperlayer];
                [JWAlert showMsg:@"网络堵塞,请重试" WithOwner:self];

            }];
        }else{
            
            [halo removeFromSuperlayer];
            [JWAlert showMsg:@"请先登录.." WithOwner:self];
        }
        
    }
    
    return;
}


#pragma mark - 初始化方法

// 初始化
-(void)initial{
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = [UIColor clearColor];
    
}


// 进入登录界面************
-(void)presentLoginVC{
    
    UIStoryboard *loginStb = [UIStoryboard storyboardWithName:@"GYLoginViewController" bundle:nil];
    GYLoginViewController *loginVC = [loginStb instantiateInitialViewController];
    GYNavigationController *navVC = [[GYNavigationController alloc] initWithRootViewController:loginVC];
    navVC.navigationBar.hidden = YES;
    [self presentViewController:navVC animated:YES completion:nil];
    
    
}

// 进入注册界面************
-(void)presentRegisterVC{
    UIStoryboard *regisStb = [UIStoryboard storyboardWithName:@"GYRegisterViewController" bundle:nil];
    GYRegisterViewController *registerVC = [regisStb instantiateInitialViewController];
    [self presentViewController:registerVC animated:YES completion:nil];
}


@end
