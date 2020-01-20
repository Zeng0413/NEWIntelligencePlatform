//
//  OCClassroomBorrowCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/23.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCClassroomBorrowModel.h"

NS_ASSUME_NONNULL_BEGIN

@class OCClassroomBorrowCell;
@protocol OCClassroomBorrowCellDelegate <NSObject>

-(void)selectedCell:(OCClassroomBorrowCell *)cell;

@end

@interface OCClassroomBorrowCell : UICollectionViewCell

@property (assign, nonatomic) BOOL isNoData;

@property (strong, nonatomic) UIButton *selectedBtn;

@property (strong, nonatomic) OCClassroomBorrowModel *borrowModel;

@property (weak, nonatomic) id<OCClassroomBorrowCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
