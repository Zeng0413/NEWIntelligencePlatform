//
//  OCSystemMessageCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/30.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCSystemMessageModel.h"
#import "OCCollegeNotiModel.h"
@class OCSystemMessageCell;
@protocol OCSystemMessageCellDelegate <NSObject>

-(void)clickWithCell:(OCSystemMessageCell *)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface OCSystemMessageCell : UITableViewCell

+(instancetype)initWithOCSystemMessageCellTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) OCSystemMessageModel *model;

@property (strong, nonatomic) OCCollegeNotiModel *collegeNotiModel;

@property (assign, nonatomic) CGFloat cellH;

@property (weak, nonatomic) id<OCSystemMessageCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
