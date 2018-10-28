//
//  GFBNewWebViewController.m
//  GFB
//
//  Created by 维信金科 on 2017/11/20.
//  Copyright © 2017年 Shanghai Aopai Data Technology Co., Ltd. All rights reserved.
//

#import "GFBNewWebViewController.h"
#import "GFBWebProgressLayerLoc.h"
#import "iOSNative.h"

///// =========== model =============
/**
 *  需要带入web的基本信息 使用name进行区分各个页面
 */

@interface GFBNewWebViewController ()<UIWebViewDelegate,iOSNativeDelegate>
// 内部转模型

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) GFBWebProgressLayerLoc *progress;
@property (nonatomic, strong) iOSNative  *iOSNative;

@end

@implementation GFBNewWebViewController

#pragma mark - The life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (!self.presentingViewController) {
        self.navigationController.navigationBar.hidden = NO;
    }
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self creatProgressLayer];
    [self setupWebView];
    [self setupiOSNative];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.progress progressAnimationCompletion];
}

#pragma mark - 初始化进度条
- (void)creatProgressLayer
{
    self.progress = [GFBWebProgressLayerLoc new];
    _progress.progressStyle = webProgressStyle_Normal;
    _progress.progressColor = [UIColor redColor];
    _progress.frame = CGRectMake(0, 41, APPWIDTH, 2);
    [self.navigationController.navigationBar.layer addSublayer:_progress];
}

#pragma mark - 初始化WebView
- (void)setupWebView
{
    self.webView = [[UIWebView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat Y = self.navigationController?0.0:19.0;
    CGFloat height = APPHEIGHT - (self.navigationController?SafeAreaTopHeight:19.0) - SafeAreaBottomHeight;
    
    CGRect webFrame = CGRectMake(0, Y, APPWIDTH,height);
    self.webView.frame = webFrame;
    
    [self.view addSubview:_webView];
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    
    NSString *path= [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSURL *url=[NSURL fileURLWithPath:path];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    _webView.delegate=self;
}

#pragma mark - <UIWebViewDelegate>
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_progress progressAnimationStart];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_progress progressAnimationCompletion];
    JSContext *jsContext = self.iOSNative.jsContext;

    [self common:jsContext];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_progress progressAnimationCompletion];
}

//////////////////////////   和H5的交互  ////////////////////////
#pragma mark ==================  JSContext ===================

- (void)setupiOSNative
{
    iOSNative *native = [[iOSNative alloc]initWithWebView:_webView];
    native.jsContext[@"AppModel"] = native;
    native.delegate = self;
    self.iOSNative = native;
    
    // jsContext环境 错误反馈
    [native iOSNativeExceptionHandlerBlock:^(JSContext *context, JSValue *exceptionValue) {
        NSString *error = exceptionValue.toString;
        NSLog(@"exceptionValue - %@",error);
    }];
}

#pragma mark - 通用的一些方法
- (void)common:(JSContext *)jsContext
{
    // 去掉自带的长按手势
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    // 获取页面默认的标题
    NSString *titleStr = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationController.title = titleStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
