//
//  OCCourseSheetCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/29.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCourseSheetModel.h"

@class OCCourseSheetCell;
@protocol OCCourseSheetCellDelegate <NSObject>

-(void)selectedCell:(OCCourseSheetCell *)cell withIsOpen:(BOOL)isOpen;

@end

@interface OCCourseSheetCell : UITableViewCell

+(instancetype)initWithOCCourseSheetCellTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath;


@property (strong, nonatomic) OCCourseSheetModel *sheetModel;

@property (assign, nonatomic) CGFloat cellH;

@property (weak, nonatomic) id<OCCourseSheetCellDelegate> delegate;
@end

