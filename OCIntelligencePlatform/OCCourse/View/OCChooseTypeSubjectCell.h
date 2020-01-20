//
//  OCChooseTypeSubjectCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/16.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCourseSubjectModel.h"
#import "OCSubObjQuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCChooseTypeSubjectCell : UITableViewCell

+(instancetype)initWithOCChooseTypeSubjectWithTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath;

//@property (strong, nonatomic) OCCourseSubjectModel *dataModel;
@property (strong, nonatomic) OCSubObjQuestionModel *dataModel;

@property (assign, nonatomic) CGFloat cellH;

@property (assign, nonatomic) NSInteger subjectCount;
@property (assign, nonatomic) NSInteger currentPage;
@end

NS_ASSUME_NONNULL_END
