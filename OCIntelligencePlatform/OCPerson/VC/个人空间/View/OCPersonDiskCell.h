//
//  OCPersonDiskCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/30.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCDPersonDiskModel.h"

NS_ASSUME_NONNULL_BEGIN
@class OCPersonDiskCell;

@protocol OCPersonDiskCellDelegate <NSObject>

-(void)selectedWithCell:(OCPersonDiskCell *)cell;

@end

@interface OCPersonDiskCell : UITableViewCell

+(instancetype)initWithOCPersonDiskCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) OCDPersonDiskModel *diskModel;

@property (assign, nonatomic) CGFloat cellH;

@property (weak, nonatomic) id<OCPersonDiskCellDelegate> delegate;

@property (strong, nonatomic) UILabel *nameLab;

@end

NS_ASSUME_NONNULL_END
