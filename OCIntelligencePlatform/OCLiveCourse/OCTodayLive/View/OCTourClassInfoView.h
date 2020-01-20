//
//  OCTourClassInfoView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/10.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCTourClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCTourClassInfoView : UIView

@property (assign, nonatomic) BOOL isEdit;

@property (strong, nonatomic) id dataSource;

@property (assign, nonatomic) CGFloat viewH;

@property (strong, nonatomic) OCTourClassModel *model;

@property (strong, nonatomic) UILabel *courseTitleLab;
@property (strong, nonatomic) UILabel *courseContentLab;
@property (strong, nonatomic) UITextView *courseContentTextView;

@property (strong, nonatomic) UILabel *adviseTitleLab;
@property (strong, nonatomic) UILabel *adviseContentLab;
@property (strong, nonatomic) UITextView *adviseContentTextView;

@property (strong, nonatomic) UILabel *attitudeScroeTitleLab;
@property (strong, nonatomic) UILabel *attitudeScroeLab;
@property (strong, nonatomic) UIView *attitudeScroeOperationView;
@property (strong, nonatomic) UITextField *attitudeRemarkTextField;
@property (strong, nonatomic) UILabel *attitudeRemarkContentLab;

@property (strong, nonatomic) UILabel *eduContentScroeTitleLab;
@property (strong, nonatomic) UILabel *eduContentScroeLab;
@property (strong, nonatomic) UIView *eduContentScroeOperationView;
@property (strong, nonatomic) UITextField *eduContentRemarkTextField;
@property (strong, nonatomic) UILabel *eduContentRemarkContentLab;

@property (strong, nonatomic) UIView *lineView1;
@property (strong, nonatomic) UIView *lineView2;
@property (strong, nonatomic) UIView *lineView3;

@property (strong, nonatomic) UITextField *attitudeScroeTextField;
@property (strong, nonatomic) UITextField *eduScroeTextField;

@property (assign, nonatomic) NSInteger attitudeScore;
@property (assign, nonatomic) NSInteger eduScore;

@property (strong, nonatomic) UILabel *attitudeScoreLab;
@property (strong, nonatomic) UILabel *eduScoreLab;

@end

NS_ASSUME_NONNULL_END
