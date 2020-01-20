//
//  OCCourseSheetPushView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/24.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCCourseSheetPushView : UIView

typedef void(^courseSheetPushViewBlcok)(NSInteger type);

@property (copy, nonatomic) courseSheetPushViewBlcok block;

@end

NS_ASSUME_NONNULL_END
