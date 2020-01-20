//
//  OCClassroomApproveCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/9.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCClassroomBorrowModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OCClassroomApproveCellDelegate <NSObject>

-(void)cellOperateClickWithModel:(OCClassroomBorrowModel *)model withType:(NSInteger)type;

@end

@interface OCClassroomApproveCell : UITableViewCell

+(instancetype)initWithClassroomApproveWithTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath;

@property (assign, nonatomic) CGFloat cellH;

@property (assign, nonatomic) NSInteger type;

@property (strong, nonatomic) OCClassroomBorrowModel *dataModel;

@property (weak, nonatomic) id<OCClassroomApproveCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
