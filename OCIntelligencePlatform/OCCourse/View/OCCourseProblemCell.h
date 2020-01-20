//
//  OCCourseProblemCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCCourseProblemCell : UITableViewCell

+(instancetype)initWithCourseProblemTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) NSArray *courseProblemArr;

@property (assign, nonatomic) CGFloat cellH;
@end

NS_ASSUME_NONNULL_END
