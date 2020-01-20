//
//  OCQuickChooseAnswerCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/17.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCourseSubjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCQuickChooseAnswerCell : UITableViewCell
+(instancetype)initWithOCQuickChooseAnswerWithTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath;
@property (strong, nonatomic) OCCourseSubjectModel *dataModel;
@property (assign, nonatomic) CGFloat cellH;
@property (assign, nonatomic) NSInteger subjectCount;
@property (assign, nonatomic) NSInteger currentPage;
@end

NS_ASSUME_NONNULL_END
