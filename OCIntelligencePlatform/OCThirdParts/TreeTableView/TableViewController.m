//
//  TableViewController.m
//  MultilevelMenuWithCheckbox
//
//  Created by hyt on 2017/11/1.
//  Copyright © 2017年 hyt. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"

@interface TableViewController ()

@property (strong, nonatomic) TableViewCell *dataCell;
@end

@implementation TableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"学院" backAction:^{
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.tableView registerClass:[TableViewCell class]
           forCellReuseIdentifier:@"reuseIdentifier"];
   
    // 注册通知，刷新UI
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView
                                             selector:@selector(reloadData)
                                                 name:MMUIUPDATE object:nil];
}

#pragma mark - Table view data source
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
    
    self.dataCell = cell;
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

@end
