//
//  OCOamGroupLeaderListCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/13.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCOamManageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCOamGroupLeaderListCell : UITableViewCell

+(instancetype)initWithOCOamGroupLeaderListCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@property (strong, nonatomic) OCOamManageModel *oamModel;

@end

NS_ASSUME_NONNULL_END
