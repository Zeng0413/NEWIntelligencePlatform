//
//  OCAcademyClassListViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/20.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCAcademyClassListViewController.h"

@interface OCAcademyClassListViewController ()

@end

@implementation OCAcademyClassListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBACKCOLOR;
    
    UILabel *titleLab = [UILabel labelWithText:@"全部学院" font:16*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH, kStatusH+15*FITWIDTH, 100*FITWIDTH, 16*FITWIDTH)];
    titleLab.font = kBoldFont(16*FITWIDTH);
    [self.view addSubview:titleLab];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundImage:GetImage(@"common_btn_blackClose") forState:UIControlStateNormal];
    cancelBtn.frame = Rect(kViewW-20*FITWIDTH-28*FITWIDTH, kStatusH+9*FITWIDTH, 28*FITWIDTH, 28*FITWIDTH);
    [cancelBtn addTarget:self action:@selector(cancelClick)];
    cancelBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:cancelBtn];
    
    [self setupSubView];
    // Do any additional setup after loading the view.
}

-(void)setupSubView{
    NSArray *titles = self.titleArray;
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = kStatusH+31*FITWIDTH+28*FITWIDTH;//用来控制button距离父视图的高
    
    UIButton *lastBtn = nil;
    for (int i = 0; i<titles.count; i++) {
        NSString *str = titles[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = i;
        button.titleFont = 14*FITWIDTH;
        button.backgroundColor = RGBA(234, 234, 234, 1);
        [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleColor = TEXT_COLOR_BLACK;
        
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14*FITWIDTH]};
        
        CGFloat length = [str boundingRectWithSize:CGSizeMake(kViewW, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width + 10*FITWIDTH;
        
        [button setTitle:str forState:UIControlStateNormal];
        button.frame = CGRectMake(20*FITWIDTH + w, h, length + 15*FITWIDTH, 38*FITWIDTH);
        if (i==0) {
            button.x = 20*FITWIDTH;
        }else{
            button.x = MaxX(lastBtn)+11*FITWIDTH;
        }
        
        if (i == self.selectedIndex) {
            [button setBackgroundColor:RGBA(229, 236, 247, 1)];
            [button setTitleColor:kAPPCOLOR];
        }
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if (MaxX(lastBtn) + length + 15*FITWIDTH > kViewW) {
            w = 0; //换行时将w置为0
            h = h + button.height + 10*FITWIDTH;//距离父视图也变化
            button.frame = Rect(20*FITWIDTH + w, h, length + 15*FITWIDTH, 38*FITWIDTH);//重设button的frame
        }
        lastBtn = button;
        
        [self.view addSubview:button];
    }
}
-(void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)handleClick:(UIButton *)btn{
    if (self.block) {
        self.block(btn.tag);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)returnBlock:(clickAcademyBlock)block{
    self.block = block;
}
@end
