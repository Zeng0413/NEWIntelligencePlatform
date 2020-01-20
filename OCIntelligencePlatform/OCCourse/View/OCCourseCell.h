//
//  OCCourseCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/14.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCourseLessonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCCourseCell : UITableViewCell

+(instancetype)initWithCourseTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) OCCourseLessonModel *dataModel;
@end

NS_ASSUME_NONNULL_END
