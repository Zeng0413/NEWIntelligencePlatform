//
//  OCAboutAsUViewController.m
//  OCPhoenix
//
//  Created by Alan on 2019/7/9.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCAboutAsUViewController.h"

@interface OCAboutAsUViewController ()

@end

@implementation OCAboutAsUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBACKCOLOR;
    
    Weak;
    wself.ts_navgationBar = [TSNavigationBar navWithTitle:@"关于我们" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    [self setupUI];
    // Do any additional setup after loading the view.
}

-(void)setupUI{
    UIScrollView *scrollView = [UIScrollView scrollViewWithBgColor:WHITE frame:Rect(0, kNavH, kViewW, kViewH-kNavH)];
    [self.view addSubview:scrollView];
    
    UIImageView *headImg = [UIImageView imageViewWithImage:GetImage(@"mine_img") frame:Rect(32*FITWIDTH, 24*FITWIDTH, kViewW-64*FITWIDTH, 204*FITWIDTH)];
    [scrollView addSubview:headImg];
    
    UILabel *descHeadLab = [UILabel labelWithText:@"简介" font:14*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH, MaxY(headImg)+36*FITWIDTH, 100, 14*FITWIDTH)];
    descHeadLab.font = kBoldFont(14*FITWIDTH);
    [scrollView addSubview:descHeadLab];
    
    NSString *contentStr = @"重庆课堂内外智汇科技有限公司成立于2017年10月，秉承课堂内外“科学 人文 生活”的核心理念，以“服务三亿青少年”为己任，依托自有知识产权的先进的“智慧引擎”技术和课堂内外丰富的教育资源，深耕教育需求，协同国内外多名教育信息化专家，引入国内外教育最新理念，致力于并提供教育产品开发、技术支持、课程研发、招考咨询、国级赛事组织等相关服务。";
    CGSize contentSize = [contentStr sizeWithFont:[UIFont systemFontOfSize:12*FITWIDTH] maxW:kViewW-40*FITWIDTH];
    UILabel *descContentLab = [UILabel labelWithText:contentStr font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(20*FITWIDTH, MaxY(descHeadLab)+24*FITWIDTH, contentSize.width, contentSize.height)];
    descContentLab.numberOfLines = 0;
    [scrollView addSubview:descContentLab];
    
    UILabel *contactHeadLab = [UILabel labelWithText:@"联系我们" font:14*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH, MaxY(descContentLab)+32*FITWIDTH, 100, 14*FITWIDTH)];
    contactHeadLab.font = kBoldFont(14*FITWIDTH);
    [scrollView addSubview:contactHeadLab];
    
    NSArray *imgArr = @[@"mine_icon_tel",@"mine_icon_e-mail"];
    NSArray *titleArr = @[@"023-67395968", @"business@oczhkj.com"];
    
    for (int i = 0; i < imgArr.count; i++) {
        UIImageView *img = [UIImageView imageViewWithImage:[UIImage imageNamed:imgArr[i]] frame:Rect(23*FITWIDTH, (MaxY(contactHeadLab)+27*FITWIDTH)+ (13*FITWIDTH + 16*FITWIDTH)*i, 20*FITWIDTH, 20*FITWIDTH)];
        [scrollView addSubview:img];
        
        NSString *titleStr = titleArr[i];
        UILabel *lab = [UILabel labelWithText:titleStr font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(MaxX(img)+16*FITWIDTH, 0, 150, 12*FITWIDTH)];
        CGSize labSize = [titleStr sizeWithFont:[UIFont systemFontOfSize:12*FITWIDTH]];
        lab.size = labSize;
        lab.centerY = img.centerY;
        [scrollView addSubview:lab];
        
        if (i == imgArr.count - 1) {
            scrollView.contentSize = CGSizeMake(0, MaxY(lab) + 55*FITWIDTH);
        }
    }
}
@end
