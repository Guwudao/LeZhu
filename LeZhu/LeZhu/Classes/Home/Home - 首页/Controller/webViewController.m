#import "webViewController.h"
#import "Reachability.h"
#import <WebKit/WebKit.h>
#import "SVProgressHUD.h"

@interface webViewController ()<UIWebViewDelegate,UIAlertViewDelegate>

@property (nonatomic) Reachability *hostReachability;//域名检查
@property (nonatomic) Reachability *internetReachability;//网络检查

@property (assign, nonatomic) BOOL isLoadFinish;//是否加载完成
@property (assign, nonatomic) BOOL isLandscape;//是否横屏

@property (weak, nonatomic) IBOutlet UIWebView *webView;//主体网页
@property (retain, nonatomic) IBOutlet UIView *noNetView;//无网络提示 视图

@property (strong,nonatomic) UIAlertView *alertView;//退出 确认 警告框
@property (retain, nonatomic) IBOutlet UIView *bottomBarView;//底部导航栏视图
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;//活动指示器
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webMarginTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabbarHeight;

@end

@implementation webViewController

+(instancetype)initWithURL:(NSString *)urlString{
    webViewController *adWKWebViewController = [[webViewController alloc]init];
    adWKWebViewController.webViewURL = urlString;
    return adWKWebViewController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    
    if (@available(iOS 11.0, *)) {
        
        if (statusBarFrame.size.height > 20) {
            self.webMarginTop.constant = 44;
            self.tabbarHeight.constant = 89;
        }
//        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRotateAction:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
 
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewURL]]];
    [self.view addSubview:self.webView];
    self.webView.scalesPageToFit = YES;
    
    self.noNetView.hidden = YES;
    [self.view addSubview:self.noNetView];
    
    [self listenNetWorkingStatus]; //监听网络是否可用
    
    [self.view addSubview:self.activityIndicatorView];
    
    self.activityIndicatorView.alpha = 0;
    [self.activityIndicatorView removeFromSuperview];
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    if ([[[UIDevice currentDevice]systemVersion]intValue ] >8) {
        
        NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]; // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
        
    }else{
        
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

//更新 UI 布局
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    if (self.isLandscape) {
//        self.webView.frame = self.view.bounds;
//    }else{
//        self.webView.frame = self.webView.frame;
//    }
}



#pragma mark - ------ 网页代理方法 ------

//是否允许加载网页
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    return YES;
}

// 网页开始加载时调用
- (void)webViewDidStartLoad:(UIWebView *)webView{
//    self.activityIndicatorView.hidden = NO;
     [SVProgressHUD showWithStatus:@"正在加载"];
    self.isLoadFinish = NO;
    
    //是否 跳转到 别的 应用
    [self openOtherAppWithUIWebView:webView];
}

//只管 固定的几个 跳转
-(void)openSomeTheAppWithUIWebView:(UIWebView *)webView{
    

    if ([webView.request.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]//Appstore
        ||[webView.request.URL.absoluteString hasPrefix:@"itms-services://"]//iOS 网页安装协议
        ||[webView.request.URL.absoluteString hasPrefix:@"weixin://"]//微信跳转
        ||[webView.request.URL.absoluteString hasPrefix:@"mqq://"])//QQ跳转
    {
        [[UIApplication sharedApplication] openURL:webView.request.URL];
    }
}


//是否 跳转到 别的 应用
-(void)openOtherAppWithUIWebView:(UIWebView *)webView{
    if ([webView.request.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]//Appstore
        ||[webView.request.URL.absoluteString hasPrefix:@"itms-services://"])//iOS 网页安装协议
    {
        [[UIApplication sharedApplication] openURL:webView.request.URL];
    }else{
        //如果不是 http 链接，判断 是否 可以进行 白名单跳转
        if (![webView.request.URL.absoluteString hasPrefix:@"http"]) {
            //获取 添加的 白名单
            NSArray *whitelist = [[[NSBundle mainBundle] infoDictionary] objectForKey : @"LSApplicationQueriesSchemes"];
            //遍历 查询 白名单
            for (NSString * whiteName in whitelist) {
                //白名单 跳转 规则
                NSString *rulesString = [NSString stringWithFormat:@"%@://",whiteName];
                //判断 链接前缀 是否在 白名单 范围内
                if ([webView.request.URL.absoluteString hasPrefix:rulesString]){
                    [[UIApplication sharedApplication] openURL:webView.request.URL];
                }
            }
        }
    }
}

// 网页加载完成之后调用
- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    self.activityIndicatorView.hidden = YES;
//    self.noNetView.hidden = YES;
    
    [SVProgressHUD dismiss];
    self.isLoadFinish = YES;
    
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=3.0, user-scalable=no\"", webView.frame.size.width];
//    [webView stringByEvaluatingJavaScriptFromString:meta];
}

// 网页加载失败时调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (!self.noNetView.hidden) {
//        self.activityIndicatorView.hidden = YES;
        [SVProgressHUD dismiss];
        
        [SVProgressHUD showErrorWithStatus:@"加载失败..."];
    }
}



#pragma mark - ------ 底部 导航栏 ------

//底部 导航栏 按钮 点击事件
- (IBAction)goingBT:(UIButton *)sender {
    if (sender.tag ==200) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewURL]]];
    }else if (sender.tag ==201) {
        if ([self.webView canGoBack]) {[self.webView goBack]; }
    }else if (sender.tag ==202) {
        if ([self.webView canGoForward]) {[self.webView goForward];}
    }else if (sender.tag ==203) {
        [self.webView reload];
    }else if (sender.tag ==204) {
        self.alertView = [[UIAlertView alloc]initWithTitle:@"是否退出？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
        [self.alertView show];
    }
}

//退出 确认
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self cleanCacheAndCookie];
        exit(0);
    }
}




#pragma mark - ------ 网络监听 ------

//无网络 重试 按钮 点击事件
- (IBAction)againBTAction:(UIButton *)sender {
//    self.activityIndicatorView.hidden = NO;
    [SVProgressHUD showWithStatus:@"正在加载"];
    self.noNetView.hidden = YES;
    self.isLoadFinish = NO;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewURL]]];
//    [self performSelector:@selector(checkNetwork) withObject:nil afterDelay:3];
    [self checkNetwork];
}

//检查网络
-(void)checkNetwork{
    self.hostReachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
}


//监听 网络状态
-(void)listenNetWorkingStatus{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    // 设置网络检测的站点
    NSString *remoteHostName = @"www.apple.com";
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}

//网络状态 通知事件
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    [self updateInterfaceWithReachability:curReach];
}

//当前网络类型
- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus) {
        case 0://无网络
            //网页加载完成，突然断网，不显示 无网络提醒视图
            if (!self.isLoadFinish) {
                self.noNetView.hidden = NO;
                [SVProgressHUD dismiss];
            }
            break;
            
        case 1://WIFI
            NSLog(@"ReachableViaWiFi----WIFI");
            break;
            
        case 2://蜂窝网络
            NSLog(@"ReachableViaWWAN----蜂窝网络");
            break;
            
        default:
            break;
    }
    
}



#pragma mark - ------ 横竖屏相关 ------

//支持旋转
-(BOOL)shouldAutorotate{
    return YES;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

//监听屏幕 横竖屏
- (void)doRotateAction:(NSNotification *)notification {
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
        self.webView.frame = self.webView.frame;
        self.bottomBarView.hidden = NO;
        self.isLandscape = NO;
    } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
               || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        NSLog(@"横屏");
//        self.webView.frame = self.view.bounds;
//        self.bottomBarView.hidden = YES;
//        self.isLandscape = YES;
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

