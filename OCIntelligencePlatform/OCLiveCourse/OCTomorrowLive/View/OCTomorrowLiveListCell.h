//
//  OCTomorrowLiveListCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/19.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCLiveVideoModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol OCTomorrowLiveListCellDelegate <NSObject>

-(void)likeLookWithModel:(OCLiveVideoModel *)model;

@end

@interface OCTomorrowLiveListCell : UITableViewCell

+(instancetype)initWithTomorrowLiveListTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) OCLiveVideoModel *dataModel;
@property (assign, nonatomic) CGFloat cellH;

@property (weak, nonatomic) id<OCTomorrowLiveListCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
