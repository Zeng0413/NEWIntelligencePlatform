//
//  BRMoreColunmPickView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/22.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "BRBaseView.h"
#import "OCCollegeSubject.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^BRMoreColunmResultBlock)(BRAcademyModel *Academy, BRSubjectModel *subject, BRProfessionModel *profession);
typedef void(^BRMoreColunmCancelBlock)(void);

@interface BRMoreColunmPickView : BRBaseView

+ (void)showMoreColunmPickerWithShowDataArr:(NSArray *)dataSource
                      defaultSelected:(NSArray *)defaultSelectedArr
                         isAutoSelect:(BOOL)isAutoSelect
                           themeColor:(UIColor *)themeColor
                          resultBlock:(BRMoreColunmResultBlock)resultBlock
                          cancelBlock:(BRMoreColunmCancelBlock)cancelBlock;

@end

NS_ASSUME_NONNULL_END
