//
//  OCCourseSheetCalenderView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/12.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateModel.h"
#import "LXCalendarDayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCCourseSheetCalenderView : UIView

typedef void(^sheetCalenderViewBlcok)(LXCalendarDayModel *dateModel);

@property (copy, nonatomic) sheetCalenderViewBlcok block;

@property (strong, nonatomic) LXCalendarDayModel *selectedDateModel;

@end

NS_ASSUME_NONNULL_END
