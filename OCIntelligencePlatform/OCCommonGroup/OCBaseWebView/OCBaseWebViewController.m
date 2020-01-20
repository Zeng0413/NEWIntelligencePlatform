//
//  OCBaseWebViewController.m
//  OCVocationalEducationiOS
//
//  Created by Alan on 2019/12/25.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCBaseWebViewController.h"
#import <WebKit/WebKit.h>

@interface OCBaseWebViewController ()<WKNavigationDelegate, UIScrollViewDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation OCBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE;
    
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:self.titleStr backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
//    self.ts_navgationBar.hidden = YES;
//    if (self.isShowNav) {
//        self.ts_navgationBar.hidden = NO;
//    }
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
   
    // 创建UserContentController（提供JavaScript向webView发送消息的方法）
    WKUserContentController *userContent = [[WKUserContentController alloc] init];
    // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
    //NativeMethod 这个方法一会要与JS里面的方法写的一样
//    [userContent addScriptMessageHandler:self name:@"fullScreen"];
//    [userContent addScriptMessageHandler:self name:@"goBack"];
    // 将UserConttentController设置到配置文件
    config.userContentController = userContent;
    
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preferences;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavH, kViewW, kViewH-kNavH) configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.backgroundColor = WHITE;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.scrollEnabled = YES;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    [self.view addSubview:self.webView];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark -------------------------------------------- 协议代理
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = YES;

}

- (UIProgressView *)progressView {
    if (_progressView) {
        return _progressView;
    }
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kViewW, 2)];
    [_progressView setTrackTintColor:[UIColor whiteColor]];
    _progressView.progressTintColor = [UIColor yellowColor];
    _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:_progressView];
    
    return _progressView;
}
@end
