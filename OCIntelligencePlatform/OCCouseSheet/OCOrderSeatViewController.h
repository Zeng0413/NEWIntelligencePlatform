//
//  OCOrderSeatViewController.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/8.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCClassroomBuildModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCOrderSeatViewController : UIViewController

@property (strong, nonatomic) OCClassroomBuildModel *classroomModel;

@property (copy, nonatomic) NSString *dateStr;

@property (copy, nonatomic) NSString *weekStr;

@property (assign, nonatomic) NSInteger selIndex1;

@property (assign, nonatomic) NSInteger selIndex2;


@end

NS_ASSUME_NONNULL_END
