//
//  OCCollegeNotiDetailViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/23.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCollegeNotiDetailViewController.h"
#import <WebKit/WebKit.h>

@interface OCCollegeNotiDetailViewController ()<UIScrollViewDelegate>

@end

@implementation OCCollegeNotiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE;
    
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"校园通知" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    UILabel *titleLab = [UILabel labelWithText:self.model.title font:14*FITWIDTH textColor:[UIColor blackColor] frame:CGRectZero];
    titleLab.font = kBoldFont(14*FITWIDTH);
    titleLab.width = kViewW - 80*FITWIDTH;
    titleLab.height = 14*FITWIDTH;
    titleLab.y = kNavH + 12*FITWIDTH;
    titleLab.centerX = kViewW/2;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    
    UILabel *timeLab = [UILabel labelWithText:self.model.createTime font:14*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(kViewW-20*FITWIDTH-200*FITWIDTH, MaxY(titleLab)+24*FITWIDTH, 200*FITWIDTH, 14*FITWIDTH)];
    timeLab.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:timeLab];

    if ([self.model.content containsString:@"<p"] || [self.model.content containsString:@"<p style"] || [self.model.content containsString:@"<div "]) {
        WKWebView *webView = [[WKWebView alloc] initWithFrame:Rect(20*FITWIDTH, MaxY(timeLab)+15*FITWIDTH, kViewW-40*FITWIDTH, kViewH - (MaxY(timeLab)+15*FITWIDTH))];
        webView.backgroundColor = WHITE;
        webView.scrollView.showsVerticalScrollIndicator = NO;
        webView.scrollView.delegate = self;
        [webView loadHTMLString:self.model.content baseURL:nil];
        [self.view addSubview:webView];
    }else{
        UILabel *contentLab = [UILabel labelWithText:self.model.content font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:CGRectZero];
        contentLab.size = [self.model.content sizeWithFont:kFont(12*FITWIDTH) maxW:kViewW - 40*FITWIDTH];
        contentLab.x = 20*FITWIDTH;
        contentLab.y = MaxY(timeLab)+15*FITWIDTH;
        contentLab.numberOfLines = 0;
        [self.view addSubview:contentLab];
    }

}

//- (void)webViewDidFinishLoad:(UIWebView*)webView {
//
//    //重写contentSize,防止左右滑动
//
//    CGSize size = webView.scrollView.contentSize;
//
//    size.width= webView.scrollView.frame.size.width;
//
//    webView.scrollView.contentSize= size;
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
