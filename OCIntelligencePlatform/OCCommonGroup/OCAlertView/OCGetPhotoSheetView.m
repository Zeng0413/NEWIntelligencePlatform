//
//  OCGetPhotoSheetView.m
//  OCElocutionSys_iOS
//
//  Created by Tang on 2018/11/17.
//  Copyright © 2018 OCZHKJ. All rights reserved.
//

#import "OCGetPhotoSheetView.h"
#import "TZImagePickerController.h"
@interface OCGetPhotoSheetView () <TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic, strong) UIImagePickerController *imagePickerVc;
@end

@implementation OCGetPhotoSheetView

+ (void)showPictureforController:(UIViewController *)viewController withMaxcount:(NSInteger)macount withphoto:(photoBlock)photoBlock {
    OCGetPhotoSheetView *navView = [[OCGetPhotoSheetView alloc] initWithFrame:Rect(0, 0, kViewW, 0)];
    navView.backgroundColor = WHITE;
    if (photoBlock) {
        navView.photoBlock = photoBlock;
    }
    if (viewController) {
        navView.controller = viewController;
    }
    navView.maxCount = macount;
    [navView initDataViews:@[@"本地相册", @"拍照"]];
    [navView show];
}


- (void)initDataViews:(NSArray *)data {
    UIView *selectView = [[UIView alloc] initWithFrame:Rect(0, 0, kViewW, 0)];
    selectView.backgroundColor = kBACKCOLOR;
    self.backgroundColor = kBACKCOLOR;
    [self addSubview:selectView];
    NSInteger datacount = data.count;
    for (NSInteger i = 0; i < datacount; i++) {

        UIView *view = [[UIView alloc] init];
        view.tag = i + 300;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeViewClicked:)];
        [view addGestureRecognizer:gesture];
        UILabel *lable = [[UILabel alloc] init];
        lable.font = kFont(15);
        lable.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((kViewW - 20) / 3, 40));
            make.center.equalTo(view);
        }];
        lable.text = data[i];
        UILabel *lineLabe = [[UILabel alloc] init];
        [view addSubview:lineLabe];
        lineLabe.backgroundColor = kBACKCOLOR;
        [lineLabe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kViewW, 1));
            make.bottom.equalTo(view);
            make.left.mas_equalTo(0);
        }];
        CGFloat width = kViewW;
        CGFloat height = 42;

        CGFloat couloum = i % data.count;
        view.backgroundColor = WHITE;
        view.frame = CGRectMake(0, couloum * (height), width, height);
        [selectView addSubview:view];
        if (i == (datacount - 1)) {
            selectView.height = view.oc_bottom;
        }
    }
    [self creatCancleView:selectView.oc_bottom + 10];
}

- (void)creatCancleView:(CGFloat)y {
    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, y, kViewW, 42.f)];
    dismissBtn.backgroundColor = WHITE;
    [dismissBtn setTitleColor:RGBA(61, 61, 61, 1) forState:UIControlStateNormal];
    [dismissBtn setTitle:@"取消" forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissAlertCont) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dismissBtn];
    self.height = dismissBtn.oc_bottom;
}

- (void)dismissAlertCont {
    [self hideAlert];
}


- (void)typeViewClicked:(UITapGestureRecognizer *)gesture {

    [self hideAlert];
    switch (gesture.view.tag - 300) {
        case 0:
            [self addPicture];
            break;
        case 1:
            [self addCamera];
            break;

        default:
            break;
    }

    // [self hideAlert];

}

- (void)addPicture {
    NSMutableArray *imageDataArray = [[NSMutableArray alloc] init];
    Weak
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCount columnNumber:4 delegate:self];
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowTakeVideo = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (wself.photoBlock) {
            for (NSInteger i = 0; i < photos.count; i++) {
                [imageDataArray addObject:[OCPublicMethodManager reduceImage:photos[i] percent:0.5]];
            }
            self.photoBlock(imageDataArray);
        }
    }];
    [self.controller presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)addCamera {
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        // 初始化图片选择控制器
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        [controller setSourceType:UIImagePickerControllerSourceTypeCamera];//设置类型

        //设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
        NSString *requiredMediaType = (NSString *) kUTTypeImage;
        NSArray *arrMediaTypes = [NSArray arrayWithObjects:requiredMediaType, nil];
        [controller setMediaTypes:arrMediaTypes];
        [controller setAllowsEditing:YES];//设置是否可以管理已经存在的图片或者视频
        [controller setDelegate:self];// 设置代理
        [self.controller presentViewController:controller animated:YES completion:nil];
    } else {
        NSLog(@"Photo is not available.");
        [MBProgressHUD showError:@"请前往设置打开相机/相册权限"];
    }
}

- (void)ensureBtnClicked {
    NSLog(@"Base Alert Confirm Button");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}

#pragma mark -
#pragma mark - UIImagePickerController

- (void)imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError contextInfo:(void *)paramContextInfo {

    if (paramError == nil) {
        NSLog(@"Image was savedsuccessfully.");
    } else {
        NSLog(@"An error happened while saving theimage.");
        NSLog(@"Error= %@", paramError);
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSMutableArray *imageDataArray = [[NSMutableArray alloc] init];
    NSLog(@"Picker returnedsuccessfully.");
    NSLog(@"%@", info);
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断获取类型：图片
    if ([mediaType isEqualToString:(NSString *) kUTTypeImage]) {
        UIImage *theImage = nil;
        // 判断，图片是否允许修改
        if ([picker allowsEditing]) {
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        // 保存图片到相册中
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
            UIImageWriteToSavedPhotosAlbum(theImage, self, selectorToCall, NULL);
        }

        theImage = [OCPublicMethodManager reduceImage:theImage percent:0.5];
        [imageDataArray addObject:theImage];
        if (_photoBlock) {
            self.photoBlock(imageDataArray);
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 摄像头和相册相关的公共类

// 判断设备是否有摄像头
- (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 前面的摄像头是否可用
- (BOOL)isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

// 后面的摄像头是否可用
- (BOOL)isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

// 判断是否支持某种多媒体类型：拍照，视频
- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType {
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        NSLog(@"Media type is empty.");
        return NO;
    }

    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *) obj;
        if ([mediaType isEqualToString:paramMediaType]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

// 检查摄像头是否支持录像
- (BOOL)doesCameraSupportShootingVideos {
    return [self cameraSupportsMedia:(NSString *) kUTTypeMovie sourceType:UIImagePickerControllerSourceTypeCamera];
}

// 检查摄像头是否支持拍照
- (BOOL)doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(NSString *) kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - 相册文件选取相关

// 相册是否可用
- (BOOL)isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];

}

// 是否可以在相册中选择视频
- (BOOL)canUserPickVideosFromPhotoLibrary {
    return [self cameraSupportsMedia:(NSString *) kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

// 是否可以在相册中选择视频
- (BOOL)canUserPickPhotosFromPhotoLibrary {
    return [self cameraSupportsMedia:(NSString *) kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}


- (void)show {
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:self preferredStyle:TYAlertControllerStyleActionSheet];
    alertController.backgoundTapDismissEnable = YES;
    self.alertController = alertController;
    [self.controller presentViewController:alertController animated:YES completion:nil];
}

- (void)hideAlert {
    [self.alertController dismissViewControllerAnimated:YES completion:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
