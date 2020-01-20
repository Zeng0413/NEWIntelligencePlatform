//
//  TSNavigationController.h
//  AntMaintenance
//
//  Created by Seven Lv on 16/3/29.
//  Copyright © 2016年 Toocms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSNavigationController : UINavigationController
///  截屏图片数组
@property (nonatomic, strong) NSMutableArray * screenShotArray;

+ (instancetype)naviWithRootViewController:(UIViewController *)aviewController;

@end
