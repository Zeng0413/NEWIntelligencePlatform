//
//  OCGetPhotoSheetView.h
//  OCElocutionSys_iOS
//
//  Created by Tang on 2018/11/17.
//  Copyright © 2018 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^photoBlock)(NSArray *photoDataArray);

@interface OCGetPhotoSheetView : UIView
+ (void)showPictureforController:(UIViewController *)viewController withMaxcount:(NSInteger)macount withphoto:(photoBlock)photoBlock;

@property(nonatomic, strong) TYAlertController *alertController;

@property(nonatomic, copy) photoBlock photoBlock;

@property(nonatomic, strong) UIViewController *controller;

@property(nonatomic, assign) NSInteger maxCount;

//相机照片操作
- (BOOL)isCameraAvailable;

- (BOOL)isFrontCameraAvailable;

- (BOOL)isRearCameraAvailable;

- (BOOL)doesCameraSupportShootingVideos;

- (BOOL)doesCameraSupportTakingPhotos;

- (BOOL)isPhotoLibraryAvailable;

- (BOOL)canUserPickVideosFromPhotoLibrary;

- (BOOL)canUserPickPhotosFromPhotoLibrary;

- (void)show;

- (void)hideAlert;
@end

NS_ASSUME_NONNULL_END
