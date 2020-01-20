//
//  OCClassroomBuildCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/10.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCClassroomBuildModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCClassroomBuildCell : UITableViewCell

+(instancetype)initWithClassroomBulidTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) OCClassroomBuildModel *buildModel;

@end

NS_ASSUME_NONNULL_END
