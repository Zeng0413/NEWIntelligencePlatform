//
//  OCVideoListCollectionViewCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/19.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCourseVideoListModel.h"

@class OCVideoListCollectionViewCell;
@protocol OCVideoListCollectionViewCellDelegate <NSObject>

-(void)selectedCell:(OCVideoListCollectionViewCell *)cell;

@end

@interface OCVideoListCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIButton *selectedBtn;

@property (strong, nonatomic) OCCourseVideoListModel *videoModel;
@property (strong, nonatomic) NSDictionary *dataDict;
@property (weak, nonatomic) id<OCVideoListCollectionViewCellDelegate> delegate;
@end
