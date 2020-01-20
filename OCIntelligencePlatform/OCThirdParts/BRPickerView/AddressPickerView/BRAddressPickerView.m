//
//  BRAddressPickerView.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRAddressPickerView.h"
#import "BRPickerViewMacro.h"

@interface BRAddressPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    BOOL _isDataSourceValid;    // 数据源是否合法
    NSInteger _provinceIndex;   // 记录省选中的位置
    NSInteger _cityIndex;       // 记录市选中的位置
    NSInteger _areaIndex;       // 记录区选中的位置
    
    NSInteger _academyIndex;   // 记录省选中的位置
    NSInteger _subjectIndex;       // 记录市选中的位置
    NSInteger _professionIndex;       // 记录区选中的位置
    
    NSArray * _defaultSelectedArr;
}
// 地址选择器
@property (nonatomic, strong) UIPickerView *pickerView;
// 保存传入的数据源
@property (nonatomic, strong) NSArray *dataSource;
// 省模型数组
@property(nonatomic, strong) NSArray *provinceModelArr;
// 市模型数组
@property(nonatomic, strong) NSArray *cityModelArr;
// 区模型数组
@property(nonatomic, strong) NSArray *areaModelArr;

// 学院数组
@property(nonatomic, strong) NSArray *academyModelArr;
// 课程数组
@property(nonatomic, strong) NSArray *subjectModelArr;
// 专业数组
@property(nonatomic, strong) NSArray *professionModelArr;


@property(nonatomic, strong) BRAcademyModel *selectAcademyModel;

@property(nonatomic, strong) BRSubjectModel *selectSubjectModel;

@property(nonatomic, strong) BRProfessionModel *selectProfressionModel;

@property(nonatomic, strong) xqModel *selectXqModel;

@property(nonatomic, strong) jxlModel *selectJxlModel;

@property(nonatomic, strong) jsModel *selectJsModel;

// 显示类型
@property (nonatomic, assign) BRAddressPickerMode showType;
// 选中的省
@property(nonatomic, strong) BRProvinceModel *selectProvinceModel;
// 选中的市
@property(nonatomic, strong) BRCityModel *selectCityModel;
// 选中的区
@property(nonatomic, strong) BRAreaModel *selectAreaModel;

// 是否开启自动选择
@property (nonatomic, assign) BOOL isAutoSelect;
// 主题色
@property (nonatomic, strong) UIColor *themeColor;
// 选中后的回调
@property (nonatomic, copy) BRAddressResultBlock resultBlock;
// 取消选择的回调
@property (nonatomic, copy) BRAddressCancelBlock cancelBlock;

// 选中后的回调
@property (nonatomic, copy) BRAcademyResultBlock academyResultBlock;
// 取消选择的回调
@property (nonatomic, copy) BRAcademyCancelBlock academyCancelBlock;

// 选中后的回调
@property (nonatomic, copy) BRClassroomResultBlock classroomResultBlock;
// 取消选择的回调
@property (nonatomic, copy) BRClassroomCancelBlock classroomCancelBlock;

@end

@implementation BRAddressPickerView

#pragma mark - 1.显示地址选择器
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                 resultBlock:(BRAddressResultBlock)resultBlock {
    [self showAddressPickerWithShowType:BRAddressPickerModeArea dataSource:nil defaultSelected:defaultSelectedArr isAutoSelect:NO themeColor:nil resultBlock:resultBlock cancelBlock:nil];
}

#pragma mark - 2.显示地址选择器（支持 设置自动选择 和 自定义主题颜色）
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                isAutoSelect:(BOOL)isAutoSelect
                                  themeColor:(UIColor *)themeColor
                                 resultBlock:(BRAddressResultBlock)resultBlock {
    [self showAddressPickerWithShowType:BRAddressPickerModeArea dataSource:nil defaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:nil];
}

#pragma mark - 3.显示地址选择器（支持 设置选择器类型、设置自动选择、自定义主题颜色、取消选择的回调）
+ (void)showAddressPickerWithShowType:(BRAddressPickerMode)showType
                     defaultSelected:(NSArray *)defaultSelectedArr
                        isAutoSelect:(BOOL)isAutoSelect
                          themeColor:(UIColor *)themeColor
                         resultBlock:(BRAddressResultBlock)resultBlock
                         cancelBlock:(BRAddressCancelBlock)cancelBlock {
    [self showAddressPickerWithShowType:showType dataSource:nil defaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
}

#pragma mark - 4.显示地址选择器（支持 设置选择器类型、传入地区数据源、设置自动选择、自定义主题颜色、取消选择的回调）
+ (void)showAddressPickerWithShowType:(BRAddressPickerMode)showType
                           dataSource:(NSArray *)dataSource
                      defaultSelected:(NSArray *)defaultSelectedArr
                         isAutoSelect:(BOOL)isAutoSelect
                           themeColor:(UIColor *)themeColor
                          resultBlock:(BRAddressResultBlock)resultBlock
                          cancelBlock:(BRAddressCancelBlock)cancelBlock {
    BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc] initWithShowType:showType dataSource:dataSource defaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
    NSAssert(addressPickerView->_isDataSourceValid, @"数据源不合法！参数异常，请检查地址选择器的数据源是否有误");
    if (addressPickerView->_isDataSourceValid) {
        [addressPickerView showWithAnimation:YES];
    }
}

+(void)showAcademyPickerWithShowType:(BRAddressPickerMode)showType dataSource:(NSArray *)dataSource defaultSelected:(NSArray *)defaultSelectedArr isAutoSelect:(BOOL)isAutoSelect themeColor:(UIColor *)themeColor resultBlock:(BRAcademyResultBlock)resultBlock cancelBlock:(BRAcademyCancelBlock)cancelBlock{
    BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc] initWithAcademyShowType:showType dataSource:dataSource defaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
    NSAssert(addressPickerView->_isDataSourceValid, @"数据源不合法！参数异常，请检查地址选择器的数据源是否有误");
    if (addressPickerView->_isDataSourceValid) {
        [addressPickerView showWithAnimation:YES];
    }
}

+(void)showClassroomPickerWithShowType:(BRAddressPickerMode)showType dataSource:(NSArray *)dataSource defaultSelected:(NSArray *)defaultSelectedArr isAutoSelect:(BOOL)isAutoSelect themeColor:(UIColor *)themeColor resultBlock:(BRClassroomResultBlock)resultBlock cancelBlock:(BRClassroomCancelBlock)cancelBlock{
    BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc] initWithClassroomShowType:showType dataSource:dataSource defaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
    NSAssert(addressPickerView->_isDataSourceValid, @"数据源不合法！参数异常，请检查地址选择器的数据源是否有误");
    if (addressPickerView->_isDataSourceValid) {
        [addressPickerView showWithAnimation:YES];
    }
}

#pragma mark - 初始化地址选择器
- (instancetype)initWithShowType:(BRAddressPickerMode)showType
                      dataSource:(NSArray *)dataSource
                 defaultSelected:(NSArray *)defaultSelectedArr
                    isAutoSelect:(BOOL)isAutoSelect
                      themeColor:(UIColor *)themeColor
                     resultBlock:(BRAddressResultBlock)resultBlock
                     cancelBlock:(BRAddressCancelBlock)cancelBlock {
    if (self = [super init]) {
        self.showType = showType;
        self.dataSource = dataSource;
        _defaultSelectedArr = defaultSelectedArr;
        _isDataSourceValid = YES;
    
        self.isAutoSelect = isAutoSelect;
        self.themeColor = themeColor;
        self.resultBlock = resultBlock;
        self.cancelBlock = cancelBlock;
        
        [self loadData];
        if (_isDataSourceValid) {
            [self initUI];
        }
    }
    return self;
}

- (instancetype)initWithAcademyShowType:(BRAddressPickerMode)showType
                      dataSource:(NSArray *)dataSource
                 defaultSelected:(NSArray *)defaultSelectedArr
                    isAutoSelect:(BOOL)isAutoSelect
                      themeColor:(UIColor *)themeColor
                     resultBlock:(BRAcademyResultBlock)resultBlock
                     cancelBlock:(BRAcademyCancelBlock)cancelBlock {
    if (self = [super init]) {
        self.showType = showType;
        self.dataSource = dataSource;
        _defaultSelectedArr = defaultSelectedArr;
        _isDataSourceValid = YES;
        
        self.isAutoSelect = isAutoSelect;
        self.themeColor = themeColor;
        self.academyResultBlock = resultBlock;
        self.academyCancelBlock = cancelBlock;
        
        [self loadData];
        if (_isDataSourceValid) {
            [self initUI];
        }
    }
    return self;
}

- (instancetype)initWithClassroomShowType:(BRAddressPickerMode)showType
                             dataSource:(NSArray *)dataSource
                        defaultSelected:(NSArray *)defaultSelectedArr
                           isAutoSelect:(BOOL)isAutoSelect
                             themeColor:(UIColor *)themeColor
                            resultBlock:(BRClassroomResultBlock)resultBlock
                            cancelBlock:(BRClassroomCancelBlock)cancelBlock {
    if (self = [super init]) {
        self.showType = showType;
        self.dataSource = dataSource;
        _defaultSelectedArr = defaultSelectedArr;
        _isDataSourceValid = YES;
        
        self.isAutoSelect = isAutoSelect;
        self.themeColor = themeColor;
        self.classroomResultBlock = resultBlock;
        self.classroomCancelBlock = cancelBlock;
        
        [self loadData];
        if (_isDataSourceValid) {
            [self initUI];
        }
    }
    return self;
}

#pragma mark - 获取地址数据
- (void)loadData {
    // 如果外部没有传入地区数据源，就使用本地的数据源
    if (!self.dataSource || self.dataSource.count == 0) {
        /*
            先拿到最外面的 bundle。
            对 framework 链接方式来说就是 framework 的 bundle 根目录，
            对静态库链接方式来说就是 target client 的 main bundle，
            然后再去找下面名为 BRPickerView 的 bundle 对象。
         */
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:@"BRPickerView" withExtension:@"bundle"];
        NSBundle *plistBundle = [NSBundle bundleWithURL:url];
        
        NSString *filePath = [plistBundle pathForResource:@"BRCity" ofType:@"plist"];
        NSArray *dataSource = [NSArray arrayWithContentsOfFile:filePath];
        if (!dataSource || dataSource.count == 0) {
            _isDataSourceValid = NO;
            return;
        }
        self.dataSource = dataSource;
    }
    
    if (self.showType == BRAcademyPickerMode || self.showType == BRClassroomPickerMode) {
        // 1.解析数据源
        [self parseAcademyDataSource];
        
        // 2.设置默认值
        [self setupAcademyDefaultValue];
        
        // 3.设置默认滚动
        [self academyScrollToRow:_academyIndex secondRow:_subjectIndex thirdRow:_professionIndex];
    }else{
        // 1.解析数据源
        [self parseDataSource];
        
        // 2.设置默认值
        [self setupDefaultValue];
        
        // 3.设置默认滚动
        [self scrollToRow:_provinceIndex secondRow:_cityIndex thirdRow:_areaIndex];
    }
    
}

#pragma mark - 解析数据源
-(void)parseAcademyDataSource{
    NSMutableArray *tempArr1 = [NSMutableArray array];
    if (self.showType == BRClassroomPickerMode) {
        for (NSDictionary *xqDict in self.dataSource) {
            xqModel *xqmodel = [xqModel objectWithKeyValues:xqDict];
            xqmodel.index = [self.dataSource indexOfObject:xqDict];
            NSArray *jxList = xqmodel.buildings;
            NSMutableArray *tempArr2 = [NSMutableArray array];
            for (NSDictionary *jxDict in jxList) {
                jxlModel *jxModel = [jxlModel objectWithKeyValues:jxDict];
                jxModel.index = [jxList indexOfObject:jxDict];
                NSArray *jsList = jxModel.roomList;
                NSMutableArray *tempArr3 = [NSMutableArray array];
                for (NSString *jsNameStr in jsList) {
                    jsModel *jsnModel = [[jsModel alloc]init];
                    jsnModel.jsName = jsNameStr;
                    jsnModel.index = [jsList indexOfObject:jsNameStr];
                    [tempArr3 addObject:jsnModel];
                }
                jxModel.roomList = [tempArr3 copy];
                [tempArr2 addObject:jxModel];
            }
            xqmodel.buildings = [tempArr2 copy];
            [tempArr1 addObject:xqmodel];
        }
    }else{
        for (NSDictionary *academyDic in self.dataSource) {
            BRAcademyModel *academyModel = [BRAcademyModel objectWithKeyValues:academyDic];
            academyModel.index = [self.dataSource indexOfObject:academyDic];
            NSArray *subjectlist = academyModel.list;
            NSMutableArray *tempArr2 = [NSMutableArray array];
            for (NSDictionary *subjectDict in subjectlist) {
                BRSubjectModel *subjectModel = [BRSubjectModel objectWithKeyValues:subjectDict];
                subjectModel.index = [subjectlist indexOfObject:subjectDict];
                NSArray *professionList = subjectModel.list;
                NSMutableArray *tempArr3 = [NSMutableArray array];
                for (NSDictionary *professionDic in professionList) {
                    BRProfessionModel *professionModel = [BRProfessionModel objectWithKeyValues:professionDic];
                    professionModel.index = [professionList indexOfObject:professionDic];
                    [tempArr3 addObject:professionModel];
                }
                subjectModel.list = [tempArr3 copy];
                [tempArr2 addObject:subjectModel];
            }
            academyModel.list = [tempArr2 copy];
            [tempArr1 addObject:academyModel];
        }
    }
    
    
    self.academyModelArr = [tempArr1 copy];
}

-(void)setupAcademyDefaultValue{
    __block NSString *selectAcademyName = nil;
    __block NSString *selectSubjectName = nil;
    __block NSString *selectProfressionName = nil;
    if (_defaultSelectedArr) {
        if (_defaultSelectedArr.count > 0 && [_defaultSelectedArr[0] isKindOfClass:[NSString class]]) {
            selectAcademyName = _defaultSelectedArr[0];
        }
        if (_defaultSelectedArr.count > 1 && [_defaultSelectedArr[1] isKindOfClass:[NSString class]]) {
            selectSubjectName = _defaultSelectedArr[1];
        }
        if (_defaultSelectedArr.count > 2 && [_defaultSelectedArr[2] isKindOfClass:[NSString class]]) {
            selectProfressionName = _defaultSelectedArr[2];
        }
    }
    
    @weakify(self)
    [self.academyModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        if (self.showType == BRClassroomPickerMode) {
            xqModel *model = obj;
            if ([model.campus isEqualToString:selectAcademyName]) {
                _academyIndex = idx;
                self.selectXqModel = model;
                *stop = YES;
            } else {
                if (idx == self.academyModelArr.count - 1) {
                    _academyIndex = 0;
                    self.selectXqModel = [self.academyModelArr firstObject];
                }
            }
        }else{
            BRAcademyModel *model = obj;
            if ([model.name isEqualToString:selectAcademyName]) {
                _academyIndex = idx;
                self.selectAcademyModel = model;
                *stop = YES;
            } else {
                if (idx == self.academyModelArr.count - 1) {
                    _academyIndex = 0;
                    self.selectAcademyModel = [self.academyModelArr firstObject];
                }
            }
        }
        
    }];
    
    if (self.showType == BRClassroomPickerMode) {
        self.subjectModelArr = [self getJxlModelArray:_academyIndex];
    }else{
        self.subjectModelArr = [self getSubjectModelArray:_academyIndex];
    }
    [self.subjectModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        if (self.showType == BRClassroomPickerMode) {
            jxlModel *model = obj;
            if ([model.buildingName isEqualToString:selectSubjectName]) {
                _subjectIndex = idx;
                self.selectJxlModel = model;
                *stop = YES;
            } else {
                if (idx == self.subjectModelArr.count - 1) {
                    _subjectIndex = 0;
                    self.selectJxlModel = [self.subjectModelArr firstObject];
                }
            }
        }else{
            BRSubjectModel *model = obj;
            if ([model.name isEqualToString:selectSubjectName]) {
                _subjectIndex = idx;
                self.selectSubjectModel = model;
                *stop = YES;
            } else {
                if (idx == self.subjectModelArr.count - 1) {
                    _subjectIndex = 0;
                    self.selectSubjectModel = [self.subjectModelArr firstObject];
                }
            }
        }
        
    }];
    
    if (self.showType == BRClassroomPickerMode) {
        self.professionModelArr = [self getJsArray:_academyIndex cityIndex:_subjectIndex];
    }else{
        self.professionModelArr = [self getProfessionModelArray:_academyIndex subjectIndex:_subjectIndex];
    }
    
    [self.professionModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        if (self.showType == BRClassroomPickerMode) {
            jsModel *model = obj;
            if ([model.jsName isEqualToString:selectProfressionName]) {
                _professionIndex = idx;
                self.selectJsModel = model;
                *stop = YES;
            } else {
                if (idx == self.professionModelArr.count - 1) {
                    _professionIndex = 0;
                    self.selectJsModel = [self.professionModelArr firstObject];
                }
            }
        }else{
            BRProfessionModel *model = obj;
            if ([model.name isEqualToString:selectProfressionName]) {
                _professionIndex = idx;
                self.selectProfressionModel = model;
                *stop = YES;
            } else {
                if (idx == self.professionModelArr.count - 1) {
                    _professionIndex = 0;
                    self.selectProfressionModel = [self.professionModelArr firstObject];
                }
            }
        }
        
    }];
    
}

- (void)parseDataSource {
    NSMutableArray *tempArr1 = [NSMutableArray array];

    if (self.showType == BRAcademyPickerMode) {
        for (NSDictionary *proviceDic in self.dataSource) {
            BRProvinceModel *proviceModel = [[BRProvinceModel alloc]init];
            proviceModel.code = proviceDic[@"code"];
            proviceModel.name = proviceDic[@"name"];
            proviceModel.index = [self.dataSource indexOfObject:proviceDic];
            NSArray *citylist = proviceDic[@"citylist"];
            NSMutableArray *tempArr2 = [NSMutableArray array];
            for (NSDictionary *cityDic in citylist) {
                BRCityModel *cityModel = [[BRCityModel alloc]init];
                cityModel.code = cityDic[@"code"];
                cityModel.name = cityDic[@"name"];
                cityModel.index = [citylist indexOfObject:cityDic];
                NSArray *arealist = cityDic[@"arealist"];
                NSMutableArray *tempArr3 = [NSMutableArray array];
                for (NSDictionary *areaDic in arealist) {
                    BRAreaModel *areaModel = [[BRAreaModel alloc]init];
                    areaModel.code = areaDic[@"code"];
                    areaModel.name = areaDic[@"name"];
                    areaModel.index = [arealist indexOfObject:areaDic];
                    [tempArr3 addObject:areaModel];
                }
                cityModel.arealist = [tempArr3 copy];
                [tempArr2 addObject:cityModel];
            }
            proviceModel.citylist = [tempArr2 copy];
            [tempArr1 addObject:proviceModel];
        }
    }else if (self.showType == BRClassroomPickerMode){
        for (NSDictionary *proviceDic in self.dataSource) {
            BRProvinceModel *proviceModel = [[BRProvinceModel alloc]init];
            proviceModel.code = proviceDic[@"code"];
            proviceModel.name = proviceDic[@"name"];
            proviceModel.index = [self.dataSource indexOfObject:proviceDic];
            NSArray *citylist = proviceDic[@"citylist"];
            NSMutableArray *tempArr2 = [NSMutableArray array];
            for (NSDictionary *cityDic in citylist) {
                BRCityModel *cityModel = [[BRCityModel alloc]init];
                cityModel.code = cityDic[@"code"];
                cityModel.name = cityDic[@"name"];
                cityModel.index = [citylist indexOfObject:cityDic];
                NSArray *arealist = cityDic[@"arealist"];
                NSMutableArray *tempArr3 = [NSMutableArray array];
                for (NSDictionary *areaDic in arealist) {
                    BRAreaModel *areaModel = [[BRAreaModel alloc]init];
                    areaModel.code = areaDic[@"code"];
                    areaModel.name = areaDic[@"name"];
                    areaModel.index = [arealist indexOfObject:areaDic];
                    [tempArr3 addObject:areaModel];
                }
                cityModel.arealist = [tempArr3 copy];
                [tempArr2 addObject:cityModel];
            }
            proviceModel.citylist = [tempArr2 copy];
            [tempArr1 addObject:proviceModel];
        }
    }
    
    
    self.provinceModelArr = [tempArr1 copy];
}

#pragma mark - 设置默认值
- (void)setupDefaultValue {
    __block NSString *selectProvinceName = nil;
    __block NSString *selectCityName = nil;
    __block NSString *selectAreaName = nil;
    // 1. 获取默认选中的省市区的名称
    if (_defaultSelectedArr) {
        if (_defaultSelectedArr.count > 0 && [_defaultSelectedArr[0] isKindOfClass:[NSString class]]) {
            selectProvinceName = _defaultSelectedArr[0];
        }
        if (_defaultSelectedArr.count > 1 && [_defaultSelectedArr[1] isKindOfClass:[NSString class]]) {
            selectCityName = _defaultSelectedArr[1];
        }
        if (_defaultSelectedArr.count > 2 && [_defaultSelectedArr[2] isKindOfClass:[NSString class]]) {
            selectAreaName = _defaultSelectedArr[2];
        }
    }
    
    // 2. 根据名称找到默认选中的省市区索引
    @weakify(self)
    [self.provinceModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        BRProvinceModel *model = obj;
        if ([model.name isEqualToString:selectProvinceName]) {
            _provinceIndex = idx;
            self.selectProvinceModel = model;
            *stop = YES;
        } else {
            if (idx == self.provinceModelArr.count - 1) {
                _provinceIndex = 0;
                self.selectProvinceModel = [self.provinceModelArr firstObject];
            }
        }
    }];
    if (self.showType == BRAddressPickerModeCity || self.showType == BRAddressPickerModeArea) {
        self.cityModelArr = [self getCityModelArray:_provinceIndex];
        @weakify(self)
        [self.cityModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            BRCityModel *model = obj;
            if ([model.name isEqualToString:selectCityName]) {
                _cityIndex = idx;
                self.selectCityModel = model;
                *stop = YES;
            } else {
                if (idx == self.cityModelArr.count - 1) {
                    _cityIndex = 0;
                    self.selectCityModel = [self.cityModelArr firstObject];
                }
            }
        }];
    }
    if (self.showType == BRAddressPickerModeArea) {
        self.areaModelArr = [self getAreaModelArray:_provinceIndex cityIndex:_cityIndex];
        @weakify(self)
        [self.areaModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            BRAreaModel *model = obj;
            if ([model.name isEqualToString:selectAreaName]) {
                _areaIndex = idx;
                self.selectAreaModel = model;
                *stop = YES;
            } else {
                if (idx == self.cityModelArr.count - 1) {
                    _areaIndex = 0;
                    self.selectAreaModel = [self.areaModelArr firstObject];
                }
            }
        }];
    }
}

#pragma mark - 滚动到指定行
- (void)scrollToRow:(NSInteger)provinceIndex secondRow:(NSInteger)cityIndex thirdRow:(NSInteger)areaIndex {
    if (self.showType == BRAddressPickerModeProvince) {
        [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
    } else if (self.showType == BRAddressPickerModeCity) {
        [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:cityIndex inComponent:1 animated:YES];
    } else if (self.showType == BRAddressPickerModeArea) {
        [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:cityIndex inComponent:1 animated:YES];
        [self.pickerView selectRow:areaIndex inComponent:2 animated:YES];
    }
}

-(void)academyScrollToRow:(NSInteger)provinceIndex secondRow:(NSInteger)cityIndex thirdRow:(NSInteger)areaIndex {
    [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
    [self.pickerView selectRow:cityIndex inComponent:1 animated:YES];
    [self.pickerView selectRow:areaIndex inComponent:2 animated:YES];
}

// 根据 省索引 获取 城市模型数组
- (NSArray *)getCityModelArray:(NSInteger)provinceIndex {
    BRProvinceModel *provinceModel = self.provinceModelArr[provinceIndex];
    // 返回城市模型数组
    return provinceModel.citylist;
}

// 根据 省索引和城市索引 获取 区域模型数组
- (NSArray *)getAreaModelArray:(NSInteger)provinceIndex cityIndex:(NSInteger)cityIndex {
    BRProvinceModel *provinceModel = self.provinceModelArr[provinceIndex];
    BRCityModel *cityModel = provinceModel.citylist[cityIndex];
    // 返回地区模型数组
    return cityModel.arealist;
}


- (NSArray *)getJsArray:(NSInteger)provinceIndex cityIndex:(NSInteger)cityIndex {
    xqModel *xqModel = self.academyModelArr[provinceIndex];
    jxlModel *jxModel = xqModel.buildings[cityIndex];
    // 返回地区模型数组
    return jxModel.roomList;
}

- (NSArray *)getSubjectModelArray:(NSInteger)provinceIndex {
    BRAcademyModel *academyModel = self.academyModelArr[provinceIndex];
    // 返回城市模型数组
    return academyModel.list;
}

- (NSArray *)getJxlModelArray:(NSInteger)provinceIndex {
    xqModel *academyModel = self.academyModelArr[provinceIndex];
    // 返回城市模型数组
    return academyModel.buildings;
}

- (NSArray *)getProfessionModelArray:(NSInteger)academyIndex subjectIndex:(NSInteger)subjectIndex {
    BRAcademyModel *academyModel = self.academyModelArr[academyIndex];
    BRSubjectModel *subjectModel = academyModel.list[subjectIndex];
    // 返回地区模型数组
    return subjectModel.list;
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    if (self.showType == BRAddressPickerModeProvince) {
        self.titleLabel.text = @"请选择省份";
    } else if (self.showType == BRAddressPickerModeCity) {
        self.titleLabel.text = @"请选择城市";
    }else if (self.showType == BRAcademyPickerMode){
        self.titleLabel.text = @"请选择院系";
    }
    else {
        self.titleLabel.text = @"请选择地区";
    }
    // 添加时间选择器
    [self.alertView addSubview:self.pickerView];
    if (self.themeColor && [self.themeColor isKindOfClass:[UIColor class]]) {
        [self setupThemeColor:self.themeColor];
    }
    [self.pickerView reloadAllComponents];
}

#pragma mark - 地址选择器
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, self.alertView.frame.size.width, kPickerHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        // 设置子视图的大小随着父视图变化
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}


#pragma mark - UIPickerViewDataSource
// 1.指定pickerview有几个表盘(几列)
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.showType) {
        case BRAddressPickerModeProvince:
            return 1;
            break;
        case BRAddressPickerModeCity:
            return 2;
            break;
        case BRAddressPickerModeArea:
            return 3;
            break;
        case BRAcademyPickerMode:
            return 3;
            break;
        case BRClassroomPickerMode:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}

// 2.指定每个表盘上有几行数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        if (self.showType == BRAcademyPickerMode || self.showType == BRClassroomPickerMode) {
            return self.academyModelArr.count;
        }else{
            // 返回省个数
            return self.provinceModelArr.count;
        }
        
    }
    if (component == 1) {
        if (self.showType == BRAcademyPickerMode || self.showType == BRClassroomPickerMode) {
            return self.subjectModelArr.count;
        }else{
            // 返回市个数
            return self.cityModelArr.count;
        }
        
    }
    if (component == 2) {
        if (self.showType == BRAcademyPickerMode || self.showType == BRClassroomPickerMode) {
            return self.professionModelArr.count;
        }else{
            // 返回区个数
            return self.areaModelArr.count;
        }
        
    }
    return 0;
    
}

#pragma mark - UIPickerViewDelegate
// 3.设置 pickerView 的 显示内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    // 设置分割线的颜色
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (self.alertView.frame.size.width) / 3, 35 * kScaleFit)];
    bgView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5 * kScaleFit, 0, (self.alertView.frame.size.width) / 3 - 10 * kScaleFit, 35 * kScaleFit)];
    [bgView addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    //label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:18.0f * kScaleFit];
    // 字体自适应属性
    label.adjustsFontSizeToFitWidth = YES;
    // 自适应最小字体缩放比例
    label.minimumScaleFactor = 0.5f;
    if (self.showType == BRAcademyPickerMode || self.showType == BRClassroomPickerMode) {
        if (component == 0) {
            if (self.showType == BRClassroomPickerMode) {
                xqModel *model = self.academyModelArr[row];
                label.text = model.campus;
            }else{
                BRAcademyModel *model = self.academyModelArr[row];
                label.text = model.name;
            }
            
        }else if (component == 1){
            if (self.showType == BRClassroomPickerMode) {
                jxlModel *model = self.subjectModelArr[row];
                label.text = model.buildingName;
            }else{
                BRSubjectModel *model = self.subjectModelArr[row];
                label.text = model.name;
            }
        }else if (component == 2){
            if (self.showType == BRClassroomPickerMode) {
                jsModel *model = self.professionModelArr[row];
                label.text = model.jsName;
            }else{
                BRProfessionModel *model = self.professionModelArr[row];
                label.text = model.name;
            }
            
        }
    }else{
        if (component == 0) {
            BRProvinceModel *model = self.provinceModelArr[row];
            label.text = model.name;
        }else if (component == 1){
            BRCityModel *model = self.cityModelArr[row];
            label.text = model.name;
        }else if (component == 2){
            BRAreaModel *model = self.areaModelArr[row];
            label.text = model.name;
        }
    }
    
    return bgView;
}

// 4.选中时回调的委托方法，在此方法中实现省份和城市间的联动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) { // 选择省
        // 保存选择的省份的索引
        _provinceIndex = _academyIndex = row;
    
        switch (self.showType) {
            case BRAddressPickerModeProvince:
            {
                self.selectProvinceModel = self.provinceModelArr[_provinceIndex];
                self.selectCityModel = nil;
                self.selectAreaModel = nil;
            }
                break;
            case BRAddressPickerModeCity:
            {
                self.cityModelArr = [self getCityModelArray:_provinceIndex];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                self.selectProvinceModel = self.provinceModelArr[_provinceIndex];
                self.selectCityModel = self.cityModelArr[0];
                self.selectAreaModel = nil;
            }
                break;
            case BRAddressPickerModeArea:
            {
                self.cityModelArr = [self getCityModelArray:_provinceIndex];
                self.areaModelArr = [self getAreaModelArray:_provinceIndex cityIndex:0];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                self.selectProvinceModel = self.provinceModelArr[_provinceIndex];
                self.selectCityModel = self.cityModelArr[0];
                self.selectAreaModel = self.areaModelArr[0];
            }
                break;
            case BRAcademyPickerMode:
            {
                self.subjectModelArr = [self getSubjectModelArray:_academyIndex];
                self.professionModelArr = [self getProfessionModelArray:_academyIndex subjectIndex:0];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                self.selectAcademyModel = self.academyModelArr[_academyIndex];
                self.selectSubjectModel = self.subjectModelArr[0];
                self.selectProfressionModel = self.professionModelArr[0];
            }
                break;
            case BRClassroomPickerMode:
            {
                self.subjectModelArr = [self getJxlModelArray:_academyIndex];
                self.professionModelArr = [self getJsArray:_academyIndex cityIndex:0];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                self.selectXqModel = self.academyModelArr[_academyIndex];
                self.selectJxlModel = self.subjectModelArr[0];
                self.selectJsModel = self.professionModelArr[0];
            }
                break;
            default:
                break;
        }
    }
    if (component == 1) { // 选择市
        // 保存选择的城市的索引
        _cityIndex = _subjectIndex = row;
        switch (self.showType) {
            case BRAddressPickerModeCity:
            {
                self.selectCityModel = self.cityModelArr[_cityIndex];
                self.selectAreaModel = nil;
            }
                break;
            case BRAddressPickerModeArea:
            {
                self.areaModelArr = [self getAreaModelArray:_provinceIndex cityIndex:_cityIndex];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                self.selectCityModel = self.cityModelArr[_cityIndex];
                self.selectAreaModel = self.areaModelArr[0];
            }
                break;
            case BRAcademyPickerMode:
            {
                self.professionModelArr = [self getProfessionModelArray:_academyIndex subjectIndex:_subjectIndex];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                self.selectSubjectModel = self.subjectModelArr[_subjectIndex];
                self.selectProfressionModel = self.professionModelArr[0];
            }
                break;
            case BRClassroomPickerMode:
            {
                self.professionModelArr = [self getJsArray:_academyIndex cityIndex:_subjectIndex];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                self.selectJxlModel = self.subjectModelArr[_subjectIndex];
                self.selectJsModel = self.professionModelArr[0];
            }
                break;
            default:
                break;
        }
    }
    if (component == 2) { // 选择区
        // 保存选择的地区的索引
        _areaIndex = _professionIndex = row;
        if (self.showType == BRAddressPickerModeArea) {
            self.selectAreaModel = self.areaModelArr[_areaIndex];
        }else if (self.showType == BRAcademyPickerMode){
            self.selectProfressionModel = self.professionModelArr[_professionIndex];
        }else if (self.showType == BRClassroomPickerMode){
            self.selectJsModel = self.professionModelArr[_professionIndex];
        }
    }
    
    // 自动获取数据，滚动完就执行回调
    if (self.isAutoSelect) {
        if (self.resultBlock) {
           self.resultBlock(self.selectProvinceModel, self.selectCityModel, self.selectAreaModel);
        }
        if (self.academyResultBlock) {
            self.academyResultBlock(self.selectAcademyModel, self.selectSubjectModel, self.selectProfressionModel);
        }
        
        if (self.classroomResultBlock) {
            self.classroomResultBlock(self.selectXqModel, self.selectJxlModel, self.selectJsModel);
        }
    }
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0f * kScaleFit;
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
    
    if (self.showType == BRAcademyPickerMode) {
        if (self.academyCancelBlock) {
            self.academyCancelBlock();
        }
    }else if (self.showType == BRClassroomPickerMode){
        if (self.classroomCancelBlock) {
            self.classroomCancelBlock();
        }
    }
    else{
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }
    
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    [self dismissWithAnimation:YES];
    
    if (self.showType == BRAcademyPickerMode) {
        if (self.academyCancelBlock) {
            self.academyCancelBlock();
        }
    }else if (self.showType == BRClassroomPickerMode){
        if (self.classroomCancelBlock) {
            self.classroomCancelBlock();
        }
    }
    else{
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }
    
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
    [self dismissWithAnimation:YES];
    // 点击确定按钮后，执行回调
    
    if (self.showType == BRAcademyPickerMode) {
        if(self.academyResultBlock) {
            self.academyResultBlock(self.selectAcademyModel, self.selectSubjectModel, self.selectProfressionModel);
        }
    }else if (self.classroomResultBlock) {
        self.classroomResultBlock(self.selectXqModel, self.selectJxlModel, self.selectJsModel);
    }
    else{
        if(self.resultBlock) {
            self.resultBlock(self.selectProvinceModel, self.selectCityModel, self.selectAreaModel);
        }
    }
    
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    // 1.获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = SCREEN_HEIGHT;
        self.alertView.frame = rect;
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= kPickerHeight + kTopViewHeight + BR_BOTTOM_MARGIN;
            self.alertView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += kPickerHeight + kTopViewHeight + BR_BOTTOM_MARGIN;
        self.alertView.frame = rect;
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSArray *)provinceModelArr {
    if (!_provinceModelArr) {
        _provinceModelArr = [NSArray array];
    }
    return _provinceModelArr;
}

- (NSArray *)cityModelArr {
    if (!_cityModelArr) {
        _cityModelArr = [NSArray array];
    }
    return _cityModelArr;
}

- (NSArray *)areaModelArr {
    if (!_areaModelArr) {
        _areaModelArr = [NSArray array];
    }
    return _areaModelArr;
}

- (BRProvinceModel *)selectProvinceModel {
    if (!_selectProvinceModel) {
        _selectProvinceModel = [[BRProvinceModel alloc]init];
    }
    return _selectProvinceModel;
}

- (BRCityModel *)selectCityModel {
    if (!_selectCityModel) {
        _selectCityModel = [[BRCityModel alloc]init];
        _selectCityModel.code = @"";
        _selectCityModel.name = @"";
    }
    return _selectCityModel;
}

- (BRAreaModel *)selectAreaModel {
    if (!_selectAreaModel) {
        _selectAreaModel = [[BRAreaModel alloc]init];
        _selectAreaModel.code = @"";
        _selectAreaModel.name = @"";
    }
    return _selectAreaModel;
}

@end
