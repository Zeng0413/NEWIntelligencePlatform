//
//  OCCourseDetailCouserRourseCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCourseWareModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OCCourseDetailCouserRourseCellDelegate <NSObject>

-(void)courseWareClickWithWareDict:(OCCourseWareModel *)dataModel;

@end

@interface OCCourseDetailCouserRourseCell : UITableViewCell

+(instancetype)initWithCourseRourseTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) NSArray *couseRourseDataArr;

@property (weak, nonatomic) id<OCCourseDetailCouserRourseCellDelegate> delegate;
@property (assign, nonatomic) CGFloat cellH;
@end

NS_ASSUME_NONNULL_END
