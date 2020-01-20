//
//  OCPlayVideoViewController.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/26.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCLiveVideoModel.h"
#import "OCCourseVideoListModel.h"
#import "OCClassSheetSubject.h"
NS_ASSUME_NONNULL_BEGIN

@interface OCPlayVideoViewController : UIViewController

@property (strong, nonatomic) OCLiveVideoModel *model;

@property (strong, nonatomic) OCCourseVideoListModel *courseListVideoModel;

@property (strong, nonatomic) OCClassSheetSubject *classSheetModel;

@property (assign, nonatomic) BOOL isLive;

@property (assign, nonatomic) BOOL isTourClass;

@property (strong, nonatomic) NSArray *commadArr;

@property (assign, nonatomic) BOOL isFromVideoPlay;
@end

NS_ASSUME_NONNULL_END
