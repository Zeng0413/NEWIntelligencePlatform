//
//  WKWebViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/30.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
@interface WKWebViewController ()<WKNavigationDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"课件资料" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
    
    self.webView = [[WKWebView alloc] initWithFrame:Rect(0, kNavH, kViewW, kViewH)];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.delegate = self;
    NSURL *url = [NSURL fileURLWithPath:self.urlStr1];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    
    NSURL *accessUrl = [url URLByDeletingLastPathComponent];
    [self.webView loadFileURL:url allowingReadAccessToURL:accessUrl];
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

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = YES;

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

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    scrollView.contentOffset = CGPointMake((scrollView.contentSize.width - kViewW)/2, scrollView.contentOffset.y);
}

- (UIProgressView *)progressView {
    if (_progressView) {
        return _progressView;
    }
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kViewW, 2)];
    [_progressView setTrackTintColor:WHITE];
    _progressView.progressTintColor = kAPPCOLOR;
    _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:_progressView];
    
    return _progressView;
}
@end
