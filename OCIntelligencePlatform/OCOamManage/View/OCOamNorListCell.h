//
//  OCOamNorListCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/13.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCOamNorListCell : UITableViewCell

+(instancetype)initWithOCOamNorListCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@property (assign, nonatomic) CGFloat cellH;

@property (strong, nonatomic) NSDictionary *dataDict;
@end

NS_ASSUME_NONNULL_END
