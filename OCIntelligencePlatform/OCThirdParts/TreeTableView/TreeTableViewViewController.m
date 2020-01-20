//
//  TreeTableViewViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/18.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "TreeTableViewViewController.h"
#import "TableViewCell.h"
@interface TreeTableViewViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@end

@implementation TreeTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"消息通知范围" rightTitle:@"完成" rightAction:^{
        [wself setupData];
    } backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    [self setupTableView];
    
    [kNotificationCenter addObserver:self selector:@selector(reloadDataNotification) name:MMUIUPDATE object:nil];
}

-(void)setupData{
    BOOL isSelectedAllSchool = NO;
    NSMutableArray *temp = [NSMutableArray array];
    NSArray *arr = [DATAHANDLER getShowingModelArray];
    for (MultilevelMenuModel *model in arr) {
        if (model.MMSelectState == selectAll) {
            if ([model.dataDict[@"text"] isEqualToString:@"全校"]) {
                isSelectedAllSchool = YES;
            }
            NSArray *listArr = model.dataDict[@"list"];
            if (listArr.count==0) {
                [temp addObject:model.dataDict];
            }else{
                if (!model.MMIsOpen) {
                    NSArray *listArr = model.dataDict[@"list"];
                    if (listArr.count==0) {
                        [temp addObject:model.dataDict];
                    }else{
                        for (NSDictionary *dict in listArr) {
                            NSArray *list = dict[@"list"];
                            if (list.count == 0) {
                                [temp addObject:dict];
                            }else{
                                for (NSDictionary *dict in list) {
                                    NSArray *list1 = dict[@"list"];
                                    if (list1.count == 0) {
                                        [temp addObject:dict];
                                    }else{
                                        for (NSDictionary *dict in list1) {
                                            NSArray *list2 = dict[@"list"];
                                            if (list2.count == 0) {
                                                [temp addObject:dict];
                                            }else{
                                                for (NSDictionary *dict in list2) {
                                                    NSArray *list3 = dict[@"list"];
                                                    if (list3.count == 0) {
                                                        [temp addObject:dict];
                                                    }else{
                                                        for (NSDictionary *dict in list3) {
                                                            NSArray *list4 = dict[@"list"];
                                                            if (list4.count == 0) {
                                                                [temp addObject:dict];
                                                            }else{
                                                                
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
    if (self.block) {
        self.block([temp copy], isSelectedAllSchool?1:0);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reloadDataNotification{
    [self.tableView reloadData];
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH, kViewW, kViewH - kNavH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[TableViewCell class]
           forCellReuseIdentifier:@"reuseIdentifier"];
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [DATAHANDLER getShowingModelArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"
                                                          forIndexPath:indexPath];
    
    MultilevelMenuModel *model = [[DATAHANDLER getShowingModelArray]
                                  objectAtIndex:indexPath.row];
    [cell updateByModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [DATAHANDLER modelClicked:[[DATAHANDLER getShowingModelArray]
                               objectAtIndex:indexPath.row]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)returnBlock:(chooseCompleteBlock)block{
    self.block = block;
}
@end
