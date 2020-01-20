//
//  OCCourseSheetSearchCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/25.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCSearchCourseSheetModel.h"

NS_ASSUME_NONNULL_BEGIN
@class OCCourseSheetSearchCell;

@protocol OCCourseSheetSearchCellDelegate <NSObject>

-(void)courseSheetLookWithModel:(OCSearchCourseSheetModel *)model;

-(void)courseSheetCollectWithModel:(OCSearchCourseSheetModel *)model withForCell:(OCCourseSheetSearchCell *)cell;
@end
@interface OCCourseSheetSearchCell : UITableViewCell

+(instancetype)initOCCourseSheetSearchCellWithTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) OCSearchCourseSheetModel *sheetModel;

@property (weak, nonatomic) id <OCCourseSheetSearchCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
