//
//  OCOrderSeatCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/11.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCOrderListModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol OCOrderSeatCellDelegate <NSObject>

-(void)cancelOrderSeatWithModel:(OCOrderListModel *)model;

@end

@interface OCOrderSeatCell : UITableViewCell

+(instancetype)initWithOCOrderSeatCellTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) OCOrderListModel *model;

@property (weak, nonatomic) id<OCOrderSeatCellDelegate> delegate;

@property (assign, nonatomic) NSInteger index;

@end

NS_ASSUME_NONNULL_END
