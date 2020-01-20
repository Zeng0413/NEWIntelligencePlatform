//
//  BRMoreColunmPickView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/22.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "BRMoreColunmPickView.h"
@interface BRMoreColunmPickView ()
// 保存传入的数据源
@property (nonatomic, strong) NSArray *dataSource;
// 学院数组
@property(nonatomic, strong) NSArray *provinceModelArr;
// 市模型数组
@property(nonatomic, strong) NSArray *cityModelArr;
// 区模型数组
@property(nonatomic, strong) NSArray *areaModelArr;
@end

@implementation BRMoreColunmPickView

//+(void)showMoreColunmPickerWithShowDataArr:(NSArray *)dataSource defaultSelected:(NSArray *)defaultSelectedArr isAutoSelect:(BOOL)isAutoSelect themeColor:(UIColor *)themeColor resultBlock:(BRMoreColunmResultBlock)resultBlock cancelBlock:(BRMoreColunmCancelBlock)cancelBlock{
//    BRMoreColunmPickView *pickView = [BRMoreColunmPickView alloc] ini
//}

#pragma mark - 初始化地址选择器
//- (instancetype)initWithDataSource:(NSArray *)dataSource
//                 defaultSelected:(NSArray *)defaultSelectedArr
//                    isAutoSelect:(BOOL)isAutoSelect
//                      themeColor:(UIColor *)themeColor
//                     resultBlock:(BRMoreColunmResultBlock)resultBlock
//                     cancelBlock:(BRMoreColunmCancelBlock)cancelBlock {
//    if (self = [super init]) {
//        self.dataSource = dataSource;
//        _defaultSelectedArr = defaultSelectedArr;
//        _isDataSourceValid = YES;
//
//        self.isAutoSelect = isAutoSelect;
//        self.themeColor = themeColor;
//        self.resultBlock = resultBlock;
//        self.cancelBlock = cancelBlock;
//
//        [self loadData];
//        if (_isDataSourceValid) {
//            [self initUI];
//        }
//    }
//    return self;
//}

@end
