//
//  OCCourseDiscussViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseDiscussViewController.h"
#import "OCCourseDiscussGetMessageCell.h"
#import "OCCourseDiscussSendMessageCell.h"
#import "OCDiscussModel.h"
#import "OCDiscussContentModel.h"

@interface OCCourseDiscussViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIImageView *contentImg;
@property (strong, nonatomic) OCCourseDiscussGetMessageCell *getMessageCell;
@property (strong, nonatomic) OCCourseDiscussSendMessageCell *sendMessageCell;

@property (strong, nonatomic) OCDiscussModel *discussModel;

@property (strong, nonatomic) NSMutableArray *dataSourse;

@property (weak, nonatomic) UITableView *tableView;
@end

@implementation OCCourseDiscussViewController
-(NSMutableArray *)dataSourse{
    if (!_dataSourse) {
        _dataSourse = [NSMutableArray array];
    }
    return _dataSourse;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBACKCOLOR;
    
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"第一次讨论" rightTitle:@"发言：5个" rightAction:^{
    } backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    [self.ts_navgationBar.rightButton setTitleColor:TEXT_COLOR_GRAY forState:UIControlStateNormal];
    
    [self requestDiscussData];
//    NSDictionary *dataDict = @{@"discussCount":@(2), @"headLine":@"asd", @"id":@(4), @"title":@"第二组讨论", @"type":@"2", @"imgsList":@[],
//                               @"answerList":@[@{@"content":@"当然是Python了！", @"groupId":@(1), @"groupName":@"第一组", @"headImg":@"", @"userId":@(4), @"userName":@"张三"},
//                                               @{@"content":@"PHP不接受反驳！PHP不接受反驳！PHP 不接受反驳！PHP不接受反驳！PHP不接 受反驳！PHP不接受反驳！", @"groupId":@(1), @"groupName":@"第一组", @"headImg":@"", @"userId":@(363412992789839872), @"userName":@"李四"},
//                                               @{@"content":@"当然是Python了！", @"groupId":@(2), @"groupName":@"第二组", @"headImg":@"", @"userId":@(2), @"userName":@"王五"},
//                                               @{@"content":@"当然是Python了！", @"groupId":@(2), @"groupName":@"第二组", @"headImg":@"", @"userId":@(363412992789839872), @"userName":@"周四"},
//                                               @{@"content":@"PHP不接受反驳！PHP不接受反驳！PHP 不接受反驳！PHP不接受反驳！PHP不接 受反驳！PHP不接受反驳！", @"groupId":@(3), @"groupName":@"第三组", @"headImg":@"", @"userId":@(5), @"userName":@"曾佳"}]
//                               };
//
//    self.discussModel = [OCDiscussModel objectWithKeyValues:dataDict];
//    NSArray *tempArr = self.discussModel.answerList;
//
//    NSString *userId = [kUserDefaults valueForKey:@"userId"];
//    NSInteger lastGroupId = 0;
//    if (tempArr.count>0) {
//        OCDiscussContentModel *model = [tempArr firstObject];
//        lastGroupId = model.groupId;
//    }
//
//    NSMutableArray *mutArr = [NSMutableArray array];
//    for (int i = 0; i<tempArr.count; i++) {
//        OCDiscussContentModel *model = tempArr[i];
//        if ([userId integerValue] == model.userId) {
//            model.type = 1;
//        }else{
//            model.type = 0;
//        }
//        if (lastGroupId == model.groupId) {
//            [mutArr addObject:model];
//
//        }else{
//            [self.dataSourse addObject:mutArr];
//            mutArr = [NSMutableArray array];
//            [mutArr addObject:model];
//            lastGroupId = model.groupId;
//        }
//        if (i == tempArr.count - 1) {
//            [self.dataSourse addObject:mutArr];
//        }
//    }
//
//
//    [self setupTableView];
    
    // Do any additional setup after loading the view.
}

-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH, kViewW, kViewH-kNavH)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = kBACKCOLOR;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.tableHeaderView = [self setTableViewHeadView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(UIView *)setTableViewHeadView{
    UIView *backView = [UIView viewWithBgColor:kBACKCOLOR frame:Rect(0, 0, kViewW, 243*FITWIDTH)];
    
    self.titleLab = [UILabel labelWithText:self.discussModel.title font:18*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH, 24*FITWIDTH, kViewW-40*FITWIDTH, 18*FITWIDTH)];
    self.titleLab.numberOfLines = 0;
    self.titleLab.size = [self.discussModel.title sizeWithFont:kFont(18*FITWIDTH) maxW:kViewW-40*FITWIDTH];
    self.titleLab.font = kBoldFont(18*FITWIDTH);
    [backView addSubview:self.titleLab];
    
    if (self.discussModel.imgsList.count!=0) {
        self.contentImg = [UIImageView imageViewWithUrl:[NSURL URLWithString:[self.discussModel.imgsList firstObject]] frame:Rect(20*FITWIDTH, MaxY(self.titleLab)+12*FITWIDTH, kViewW-40*FITWIDTH, 189*FITWIDTH)];
        self.contentImg.layer.cornerRadius = 7;
        self.contentImg.contentMode = UIViewContentModeScaleAspectFit;
        self.contentImg.backgroundColor = [UIColor clearColor];
        [backView addSubview:self.contentImg];
        
        backView.height = MaxY(self.contentImg)+12*FITWIDTH;
    }else{
        backView.height = MaxY(self.titleLab)+12*FITWIDTH;
    }
    
    
    return backView;
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourse.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tempArr = self.dataSourse[section];
    return tempArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *tempArr = self.dataSourse[indexPath.section];
    OCDiscussContentModel *model = tempArr[indexPath.row];
    if (model.type == 0) {
        OCCourseDiscussGetMessageCell *cell = [OCCourseDiscussGetMessageCell initWithCourseDiscussGetMessageTableView:tableView cellForAtIndexPath:indexPath];
        cell.dataModel = model;
        self.getMessageCell = cell;
        return cell;
    }else{
        OCCourseDiscussSendMessageCell *cell = [OCCourseDiscussSendMessageCell initWithCourseDiscussSendMessageTableView:tableView cellForAtIndexPath:indexPath];
        cell.dataModel = model;
        self.sendMessageCell = cell;
        return cell;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *tempArr = self.dataSourse[section];
    OCDiscussContentModel *model = [tempArr firstObject];
    UIView *backView = [UIView viewWithBgColor:kBACKCOLOR frame:Rect(0, 0, kViewH, 36*FITWIDTH)];
    
    UILabel *label = [UILabel labelWithText:model.groupName font:16*FITWIDTH textColor:arc4randomColor frame:Rect(20*FITWIDTH, 10*FITWIDTH, kViewW - 40*FITWIDTH, 16*FITWIDTH)];
    [backView addSubview:label];
    return backView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36*FITWIDTH;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *tempArr = self.dataSourse[indexPath.section];
    OCDiscussContentModel *model = tempArr[indexPath.row];
    if (model.type == 0) {
        return self.getMessageCell.cellH;
    }else{
        return self.sendMessageCell.cellH;
    }
    
}

#pragma mark - 网络请求
-(void)requestDiscussData{
    Weak; 
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/lesson/discuss/%ld/%@",kURL,APIInteractiveURl,[self.tempDict[@"id"] integerValue],[kUserDefaults valueForKey:@"signClazzId"]) parameters:@{} success:^(id responseObject) {
        NSDictionary *dataDict = responseObject;
        wself.discussModel = [OCDiscussModel objectWithKeyValues:dataDict];
        wself.ts_navgationBar.titleLabel.text = wself.discussModel.headLine;
        [wself.ts_navgationBar.rightButton setTitle:NSStringFormat(@"发言：%ld个",wself.discussModel.discussCount) forState:UIControlStateNormal];
        CGSize rightSize = [wself.ts_navgationBar.rightButton.titleLabel.text sizeWithFont:kBoldFont(14)];
        wself.ts_navgationBar.rightButton.size = CGSizeMake(rightSize.width, rightSize.height+16);
        
        NSArray *tempArr = wself.discussModel.answerList;
        
        NSString *userId = [kUserDefaults valueForKey:@"userId"];
        NSInteger lastGroupId = 0;
        if (tempArr.count>0) {
            OCDiscussContentModel *model = [tempArr firstObject];
            lastGroupId = model.groupId;
        }
        
        NSMutableArray *mutArr = [NSMutableArray array];
        for (int i = 0; i<tempArr.count; i++) {
            OCDiscussContentModel *model = tempArr[i];
            if ([userId integerValue] == model.userId) {
                model.type = 1;
            }else{
                model.type = 0;
            }
            if (lastGroupId == model.groupId) {
                [mutArr addObject:model];
                
            }else{
                [wself.dataSourse addObject:mutArr];
                mutArr = [NSMutableArray array];
                [mutArr addObject:model];
                lastGroupId = model.groupId;
            }
            if (i == tempArr.count - 1) {
                [wself.dataSourse addObject:mutArr];
            }
        }
        
        
        [wself setupTableView];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}
@end
