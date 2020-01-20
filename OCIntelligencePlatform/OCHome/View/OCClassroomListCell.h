//
//  OCClassroomListCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/23.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCampusClassroomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCClassroomListCell : UICollectionViewCell

@property (strong, nonatomic) OCCampusClassroomModel *dataModel;
@property (strong, nonatomic) UIImageView *img;

@end

NS_ASSUME_NONNULL_END
