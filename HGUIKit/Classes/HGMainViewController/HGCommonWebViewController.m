//
//  HGCommonWebViewController.m
//  HGUIKit
//

#import "HGCommonWebViewController.h"
#import <WebKit/WebKit.h>
#import "HGUIMacros.h"
#import <QMUIKit/UIView+QMUI.h>
#import <YYKit/UIColor+YYAdd.h>
#import <YYKit/UIView+YYAdd.h>
#import <YYKit/UIImage+YYAdd.h>

@interface HGCommonWebViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKUserContentController *userContentController ;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIView *bottomToolBar;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *forwardBtn;

@property (nonatomic, strong, readonly) HGCommonViewModel *viewModel;

@end

@implementation HGCommonWebViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

- (void)bindViewModel {
    [super bindViewModel];
        
    @weakify(self)
    [RACObserve(self, self.webView.title) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.navigationItem.title = self.webView.title;
    }];
    
    [RACObserve(self, self.webView.estimatedProgress) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.progressView.hidden = x.doubleValue == 1;
        [self.progressView setProgress:x.doubleValue animated:YES];
    }];
    
    [[[RACObserve(self, self.webView.canGoBack) distinctUntilChanged] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.backBtn.enabled = self.webView.canGoBack;
    }];
    
    [[[RACObserve(self, self.webView.canGoForward) distinctUntilChanged] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.forwardBtn.enabled = self.webView.canGoForward;
    }];
    
    self.url = self.viewModel.params[@"url"];
}

- (void)setUrl:(NSString *)url {
    _url = url;
    
    if (url.length <= 0) {
        return;
    }
    
    if ([url hasPrefix:@"http"]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
        [self.webView loadRequest:request];
    } else {
        [self.webView loadHTMLString:url baseURL:nil];
    }
}

- (void)btnClicked:(UIButton *)btn {
    if (btn.tag == 0) {
        [self.webView goBack];
    } else {
        [self.webView goForward];
    }
}

#pragma mark - WKWebView代理
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        //如果不添加这个，那么wkwebview跳转不了AppStore
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    /// js call OC function
}

#pragma mark - lazy
- (WKUserContentController *)userContentController {
    if (!_userContentController) {
        _userContentController = [[WKUserContentController alloc] init];
        [_userContentController addScriptMessageHandler:self name:@"yyets.openWithSafari"];
    }
    return _userContentController;
}

- (WKWebView *)webView {
    if(!_webView) {
        /// 注册JS
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences.minimumFontSize = 10;
        configuration.userContentController = self.userContentController;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, HGTopNavBarHeight, self.view.frame.size.width, HGTopNavBarHeight-HGTopNavBarHeight-50-self.view.qmui_safeAreaInsets.bottom) configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [self.view insertSubview:_webView belowSubview:self.progressView];
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if(!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, HGTopNavBarHeight, HGScreenWidth, 0)];
        self.progressView.tintColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0];
        self.progressView.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:self.progressView];
    }
    return _progressView;
}

- (UIView *)bottomToolBar {
    if (!_bottomToolBar) {
        CGFloat h = 50 + self.view.qmui_safeAreaInsets.bottom;
        _bottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-h, self.view.frame.size.width, h)];
        _bottomToolBar.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
        _bottomToolBar.qmui_borderPosition = QMUIViewBorderPositionTop;
        [self.view addSubview:_bottomToolBar];
    }
    return _bottomToolBar;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.bottomToolBar.width-160)/2.0, 0, 80, 50)];
        [_backBtn setImage:[[UIImage imageNamed:@"HG_back"] imageByTintColor:UIColor.blackColor] forState:UIControlStateNormal];
        [_backBtn setImage:[[UIImage imageNamed:@"HG_back"] imageByTintColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        _backBtn.tag = 0;
        [_backBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomToolBar addSubview:_backBtn];
    }
    return _backBtn;
}

- (UIButton *)forwardBtn {
    if (!_forwardBtn) {
        _forwardBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.backBtn.right, self.backBtn.top, self.backBtn.width, self.backBtn.height)];
        [_forwardBtn setImage:[[[UIImage imageNamed:@"HG_back"] imageByTintColor:UIColor.blackColor] imageByRotate180] forState:UIControlStateNormal];
        [_forwardBtn setImage:[[[UIImage imageNamed:@"HG_back"] imageByTintColor:[UIColor lightGrayColor]] imageByRotate180] forState:UIControlStateDisabled];
        _forwardBtn.tag = 1;
        [_forwardBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomToolBar addSubview:_forwardBtn];
    }
    return _forwardBtn;
}

@end
