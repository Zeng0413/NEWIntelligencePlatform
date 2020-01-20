//
//  uploadImageView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/13.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface uploadImageView : UIView
@property(nonatomic,strong)UIImageView*iconView;
@property(nonatomic,strong)UIButton*deleteBtn;
@property (strong, nonatomic) UIButton *addBtn;

@property (assign, nonatomic) NSInteger maxRow;
@property (assign, nonatomic) NSInteger imageBorder;
@property (copy, nonatomic) NSString *defualtImgStr;
@property (copy, nonatomic) NSString *deleteImgStr;

-(void)configpic:(NSArray*)picArray;


@property(nonatomic,copy)void(^adPicclick)(void);
@property(nonatomic,copy)void(^dePicclick)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
