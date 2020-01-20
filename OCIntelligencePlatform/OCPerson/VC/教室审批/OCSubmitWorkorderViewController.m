//
//  OCSubmitWorkorderViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/6.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCSubmitWorkorderViewController.h"
#import "uploadImageView.h"
#import "OCGetPhotoSheetView.h"
@interface OCSubmitWorkorderViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewTopLayout;

@property (weak, nonatomic) uploadImageView *loadImgView;
@property (strong, nonatomic) NSMutableArray *picArray;

@end

@implementation OCSubmitWorkorderViewController

-(NSMutableArray *)picArray{
    if (!_picArray) {
        _picArray = [NSMutableArray array];
    }
    return _picArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ts_navgationBar = [[TSNavigationBar alloc]initWithTitle_:@"提交工单"];
    
    [self setupLoadImgUI];
    
    UIButton *submitBtn = [UIButton buttonWithTitle:@"提交" titleColor:WHITE backgroundColor:kAPPCOLOR font:16 image:nil target:self action:@selector(submitClick) frame:Rect(20, kViewH-32-48, kViewW-40, 48)];
    submitBtn.layer.cornerRadius = 24;
    [self.view addSubview:submitBtn];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupLoadImgUI{
    uploadImageView *loadImgView = [[uploadImageView alloc] initWithFrame:Rect(105, 394, kViewW-105-20, 0)];
    loadImgView.maxRow = 4;
    loadImgView.imageBorder = 15*FITWIDTH;
    loadImgView.defualtImgStr = @"icon_addpicture";
    loadImgView.deleteImgStr = @"yw_btn_close";
    [loadImgView configpic:self.picArray];
    [self.view addSubview:loadImgView];
    self.loadImgView = loadImgView;
    
    Weak;
    [self.loadImgView setAdPicclick:^{
        [OCGetPhotoSheetView showPictureforController:self withMaxcount:5 withphoto:^(NSArray * _Nonnull photoDataArray) {
            for (UIImage *image in photoDataArray) {
                [wself.picArray addObject:image];
            }
            [wself.loadImgView configpic:wself.picArray];
            wself.lineViewTopLayout.constant = wself.loadImgView.height+28;
            
        }];
    }];
    
    [self.loadImgView setDePicclick:^(NSInteger tag) {
        [wself.picArray removeObjectAtIndex:tag];
        [wself.loadImgView configpic:wself.picArray];
        wself.lineViewTopLayout.constant = wself.loadImgView.height+28;
    }];
    
}


-(void)submitClick{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
