//
//  OCCourseDiscussSendMessageCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCDiscussContentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OCCourseDiscussSendMessageCell : UITableViewCell
+(instancetype)initWithCourseDiscussSendMessageTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) OCDiscussContentModel *dataModel;

@property (assign, nonatomic) CGFloat cellH;
@end

NS_ASSUME_NONNULL_END
