//
//  OCClassSheetCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/24.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCClassSheetClassroomModel.h"
#import "OCClassSheetSubject.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OCClassSheetCellDelegate <NSObject>

-(void)chooseClaseeSheetCourseWithModel:(OCClassSheetSubject *)model;

@end

@interface OCClassSheetCell : UITableViewCell

+(instancetype)initWithOCClassSheetCellTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) NSArray *timeArray;

@property (strong, nonatomic) OCClassSheetClassroomModel *classroomModel;

@property (weak, nonatomic) id <OCClassSheetCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
