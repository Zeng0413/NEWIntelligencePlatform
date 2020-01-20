//
//  OCHomeCourseCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCourseListModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface OCHomeCourseCell : UITableViewCell

+(instancetype)initWithHomeCourseTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) OCCourseListModel *dataModel;
@end

NS_ASSUME_NONNULL_END
