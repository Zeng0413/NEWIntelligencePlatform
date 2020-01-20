//
//  SLCollectionLogTool.m
//  RunningMan
//
//  Created by Seven Lv on 16/4/16.
//  Copyright © 2016年 Toocms. All rights reserved.
//

#import "SLCollectionLogTool.h"
#import <CommonCrypto/CommonDigest.h>

static SLCollectionLogTool *_tool = nil;

@implementation SLCollectionLogTool

void printPropertyName (NSDictionary * request) {
    SLLog(@"打印属性------------------begin");
    [request enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString * property = [NSString stringWithFormat:@"@property (nonatomic,   copy) NSString * %@;", key];
        SLLog(property);
    }];
    SLLog(@"打印属性------------------end");
    
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    SLLog(@"sdfsdf");
}

+ (instancetype)sharedTool {
    if (_tool == nil) {
        _tool = [[self alloc] init];
    }
    return _tool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [super allocWithZone:zone];
    });
    return _tool;
}

- (NSMutableArray *)logs {
    if (!_logs) {
        _logs = [NSMutableArray array];
    }
    return _logs;
}

///  包装
id __sl_box(const char * type, ...) {
    va_list variable_param_list;
    va_start(variable_param_list, type);
    
    id object = nil;
    
    if (strcmp(type, @encode(id)) == 0) {
        id param = va_arg(variable_param_list, id);
        object = param;
    }
    else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint param = (CGPoint)va_arg(variable_param_list, CGPoint);
        object = [NSValue valueWithCGPoint:param];
    }
    else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize param = (CGSize)va_arg(variable_param_list, CGSize);
        object = [NSValue valueWithCGSize:param];
    }
    else if (strcmp(type, @encode(CGVector)) == 0) {
        CGVector param = (CGVector)va_arg(variable_param_list, CGVector);
        object = [NSValue valueWithCGVector:param];
    }
    else if (strcmp(type, @encode(CGRect)) == 0) {
        CGRect param = (CGRect)va_arg(variable_param_list, CGRect);
        object = [NSValue valueWithCGRect:param];
    }
    else if (strcmp(type, @encode(NSRange)) == 0) {
        NSRange param = (NSRange)va_arg(variable_param_list, NSRange);
        object = [NSValue valueWithRange:param];
    }
    else if (strcmp(type, @encode(CFRange)) == 0) {
        CFRange param = (CFRange)va_arg(variable_param_list, CFRange);
        object = [NSValue value:&param withObjCType:type];
    }
    else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
        CGAffineTransform param = (CGAffineTransform)va_arg(variable_param_list, CGAffineTransform);
        object = [NSValue valueWithCGAffineTransform:param];
    }
    else if (strcmp(type, @encode(CATransform3D)) == 0) {
        CATransform3D param = (CATransform3D)va_arg(variable_param_list, CATransform3D);
        object = [NSValue valueWithCATransform3D:param];
    }
    else if (strcmp(type, @encode(SEL)) == 0) {
        SEL param = (SEL)va_arg(variable_param_list, SEL);
        object = NSStringFromSelector(param);
    }
    else if (strcmp(type, @encode(Class)) == 0) {
        Class param = (Class)va_arg(variable_param_list, Class);
        object = NSStringFromClass(param);
    }
    else if (strcmp(type, @encode(SLOffset)) == 0) {
        SLOffset param = (SLOffset)va_arg(variable_param_list, SLOffset);
        object = [NSValue valueWithSLOffset:param];
    }
    else if (strcmp(type, @encode(SLEdgeInsets)) == 0) {
        SLEdgeInsets param = (SLEdgeInsets)va_arg(variable_param_list, SLEdgeInsets);
        object = [NSValue valueWithSLEdgeInsets:param];
    }
    else if (strcmp(type, @encode(short)) == 0) {
        short param = (short)va_arg(variable_param_list, int);
        object = @(param);
    }
    else if (strcmp(type, @encode(int)) == 0) {
        int param = (int)va_arg(variable_param_list, int);
        object = @(param);
    }
    else if (strcmp(type, @encode(long)) == 0) {
        long param = (long)va_arg(variable_param_list, long);
        object = @(param);
    }
    else if (strcmp(type, @encode(long long)) == 0) {
        long long param = (long long)va_arg(variable_param_list, long long);
        object = @(param);
    }
    else if (strcmp(type, @encode(float)) == 0) {
        float param = (float)va_arg(variable_param_list, double);
        object = @(param);
    }
    else if (strcmp(type, @encode(double)) == 0) {
        double param = (double)va_arg(variable_param_list, double);
        object = @(param);
    }
    else if (strcmp(type, @encode(BOOL)) == 0) {
        BOOL param = (BOOL)va_arg(variable_param_list, int);
        object = param ? @"YES" : @"NO";
    }
    else if (strcmp(type, @encode(bool)) == 0) {
        bool param = (bool)va_arg(variable_param_list, int);
        object = param ? @"true" : @"false";
    }
    else if (strcmp(type, @encode(char)) == 0) {
        char param = (char)va_arg(variable_param_list, int);
        object = [NSString stringWithFormat:@"%c", param];
    }
    else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short param = (unsigned short)va_arg(variable_param_list, unsigned int);
        object = @(param);
    }
    else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int param = (unsigned int)va_arg(variable_param_list, unsigned int);
        object = @(param);
    }
    else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long param = (unsigned long)va_arg(variable_param_list, unsigned long);
        object = @(param);
    }
    else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long param = (unsigned long long)va_arg(variable_param_list, unsigned long long);
        object = @(param);
    }
    else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char param = (unsigned char)va_arg(variable_param_list, unsigned int);
        object = [NSString stringWithFormat:@"%c", param];
    }
    else {
        void * param = (void *)va_arg(variable_param_list, void *);
        object = [NSString stringWithFormat:@"%p", param];
    }
    
    va_end(variable_param_list);
    
    return object;
}

@end

//@interface SLLogCell : UITableViewCell
//@property (nonatomic,   copy) NSString * content;
//@end
//
//@implementation SLLogCell {
//
//    UILabel * _text;
//}
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (!self) {
//        return nil;
//    }
//
//    _text = [UILabel labelWithText:nil font:12 textColor:[UIColor blackColor] frame:CGRectZero];
//    _text.numberOfLines = 0;
//    _text.preferredMaxLayoutWidth = kScreenWidth - 20;
//    [self.contentView addSubview:_text];
//
//    return self;
//}
//
//- (void)layoutSubviews {
//
//    [super layoutSubviews];
//
//}
//
//- (void)setContent:(NSString *)content {
//    _content = [content copy];
//    _text.text = content;
//    _text.frame = Rect(10, 5, kScreenWidth - 20, 200);
//    [_text sizeToFit];
//}
//@end
//
//@interface SLLogView () <UITableViewDataSource,UITableViewDelegate>
//
//@end
//
//@implementation SLLogView
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor redColor];
//
//        UILabel * title = [UILabel labelWithText:@"日志输出" font:17 textColor:[UIColor whiteColor] frame:Rect(0, 20, kScreenWidth, 44)];
//        title.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:title];
//
//        UIButton * close = [UIButton buttonWithTitle:@"关闭" titleColor:[UIColor whiteColor] backgroundColor:nil font:15 image:nil frame:Rect(0, 0, 80, 44)];
//        close.centerY = title.centerY;
//        close.maxX = kScreenWidth;
//
//        @weakify(self);
//        [[close rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            @strongify(self);
//            [UIView animateWithDuration:0.25 animations:^{
//                self.y = kScreenHeigth;
//            } completion:^(BOOL finished) {
//                [self removeFromSuperview];
//            }];
//        }];
//        [self addSubview:close];
//
//        UIButton * clear = [UIButton buttonWithTitle:@"清空" titleColor:[UIColor whiteColor] backgroundColor:nil font:15 image:nil frame:Rect(0, 0, 80, 44)];
//        clear.centerY = title.centerY;
//
//        [[clear rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            @strongify(self);
//            [UIView animateWithDuration:0.25 animations:^{
//                self.y = kScreenHeigth;
//            } completion:^(BOOL finished) {
//                [[SLCollectionLogTool sharedTool].logs removeAllObjects];
//                [self removeFromSuperview];
//            }];
//        }];
//        [self addSubview:clear];
//
//        UITableView * tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeigth - 64) style:UITableViewStylePlain];
//        tableView.delegate = self;
//        tableView.dataSource = self;
//        tableView.backgroundColor = [UIColor clearColor];
//        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        tableView.tableFooterView = [UIView new];
//        [self addSubview:tableView];
//        self.tableView = tableView;
//    }
//    return self;
//}
//
//
//#pragma mark - Delegate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    return self.logs.count;
//}
//
//
//
//-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return [self cellHeight:indexPath];
//
//
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString * ID = @"ID";
//    SLLogCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[SLLogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    NSString * str = self.logs[indexPath.row];
//    if ([str hasSuffix:@"\n\n"]) {
//        str = [str stringByReplacingCharactersInRange:NSMakeRange(str.length - 2, 2) withString:@""];
//    }
//    cell.content = str;
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 200;
//}
//
//
//- (CGFloat)cellHeight:(NSIndexPath *)indexPath {
//
//    NSString * str = self.logs[indexPath.row];
//    if ([str hasSuffix:@"\n\n"]) {
//        str = [str stringByReplacingCharactersInRange:NSMakeRange(str.length - 2, 2) withString:@""];
//    }
//    CGSize s = [NSString getStringRect:str fontSize:12 width:kScreenWidth - 20];
//    return s.height + 10;
//
//}
//@end

