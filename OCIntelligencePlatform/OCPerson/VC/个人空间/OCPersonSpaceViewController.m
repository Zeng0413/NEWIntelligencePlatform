//
//  OCPersonSpaceViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/29.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCPersonSpaceViewController.h"
#import "OCDPersonDiskModel.h"
#import "OCPersonDiskCell.h"
#import "WKWebViewController.h"
#import "OCGetPhotoSheetView.h"
#import "OCPersonDiskPushView.h"

@interface OCPersonSpaceViewController ()<UITableViewDelegate, UITableViewDataSource, OCPersonDiskCellDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) OCPersonDiskCell *diskCell;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) OCDPersonDiskModel *selectedModel;
@property (strong, nonatomic) OCPersonDiskPushView *pushView;
@property (assign, nonatomic) NSInteger downCount;
@end

@implementation OCPersonSpaceViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.totalPage = 1;
    self.view.backgroundColor = WHITE;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"个人空间" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    UIButton *uploadBtn = [UIButton buttonWithTitle:@"" titleColor:nil backgroundColor:nil font:0 image:@"mine_btn_upload" frame:CGRectZero];
    uploadBtn.x = kViewW - 20*FITWIDTH - 30;
    uploadBtn.size = CGSizeMake(30, 30);
    uploadBtn.y = kStatusH + 12;
    [uploadBtn addTarget:self action:@selector(uploadClick)];
    [self.ts_navgationBar addSubview:uploadBtn];
    
    [self setupTableView];
    [self setupFootView];
    [self requestDiskListData];
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH, kViewW, kViewH - kNavH - 48*FITWIDTH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 198*FITWIDTH;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(noticePullRefresh)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(noticeDropRefresh)];
    NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];
    
    if ([has integerValue] == 1) {
        self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"" titleStr:@"" detailStr:@"暂无资源~"];
    }else{
        self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"" detailStr:@"请找个开阔的的地方再试试哦～"];
    }
    
    [self.view addSubview:self.tableView];
}

-(void)setupFootView{
    UIView *footView = [UIView viewWithBgColor:kAPPCOLOR frame:Rect(0, MaxY(self.tableView), kViewW, 48*FITWIDTH)];
    [self.view addSubview:footView];
    
    NSArray *imgArr = @[@"common_btn_download_white", @"mine_btn_delete", @"mine_icon_edit"];
    NSArray *titleArr = @[@"下载", @"删除", @"重命名"];
    for (int i = 0; i<imgArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.size = CGSizeMake(kViewW/3, 48*FITWIDTH);
        btn.x = btn.width*i;
        btn.y = 0;
        [btn setImage:GetImage(imgArr[i]) forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:WHITE forState:UIControlStateNormal];
        btn.titleFont = 11*FITWIDTH;
        [btn layoutButtonWithEdgInsetsStyle:WxyButtonEdgeInsetsStyleImageTop imageTitleSpacing:8*FITWIDTH];
        btn.tag = i+1;
        [btn addTarget:self action:@selector(diskOperateClick:)];
        [footView addSubview:btn];
    }
    
}

#pragma mark ------------------------------------------------------- 交互事件
-(void)uploadClick{
    Weak;
    [OCGetPhotoSheetView showPictureforController:self withMaxcount:1 withphoto:^(NSArray * _Nonnull photoDataArray) {
        [wself uploadPicWithImg:[photoDataArray firstObject]];
    }];
}

-(void)diskOperateClick:(UIButton *)button{
    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *idsArr = [NSMutableArray array];
    for (int index = 0; index < self.dataArray.count; index++) {
        OCDPersonDiskModel *model = self.dataArray[index];
        if (model.isSelected) {
            [tempArr addObject:model];
            [idsArr addObject:model.ID];
        }
    }
    if (tempArr.count == 0) {
        [MBProgressHUD showText:@"请先选择文件"];
        return;
    }
    if (button.tag == 1) { // 下载
        [self fileOpeateWithModel:self.selectedModel isCellClick:NO];
    }else if (button.tag == 2){ // 删除
        self.pushView = [OCPersonDiskPushView creatPersonDiskPushView];
        self.pushView.frame = self.view.bounds;
        self.pushView.titleStr = @"确认删除该文件夹及文件夹内所有内容吗？";
        Weak;
        self.pushView.block = ^(NSString * _Nonnull fileStr) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
            NSArray *fileArr = [fileManager contentsOfDirectoryAtPath:path error:NULL];
            
            for (OCDPersonDiskModel *model in tempArr) {
                NSString *filePath = model.url.lastPathComponent;
                for (NSString *fileStr in fileArr) {
                    if ([filePath isEqualToString:fileStr]) {
                        NSString *deleteStr = [path stringByAppendingPathComponent:fileStr];
                        [fileManager removeItemAtPath:deleteStr error:nil];
                    }
                }
            }
            [MBProgressHUD showMessage:@""];
            [APPRequest deleteRequestWithURLStr:NSStringFormat(@"%@/%@v1/cloudDisk/delete",kURL,APIUserURL) paramDic:@{@"idList":idsArr} success:^(id responseObject) {
                if (responseObject) {
                    [wself.tableView.mj_header beginRefreshing];
                }
            } error:^(id responseObject) {
            } failure:^(NSError *error) {
            } controller:wself];

        };
        [self.view addSubview:self.pushView];
    }else{ // 重命名
        if (tempArr.count > 1) {
            [MBProgressHUD showText:@"重命名只能选择一个文件"];
            return;
        }
        [self resetName:[tempArr firstObject]];
    }
}

-(void)resetName:(OCDPersonDiskModel *)diskModel{
    self.pushView = [OCPersonDiskPushView creatPersonDiskPushView];
    self.pushView.frame = self.view.bounds;
    Weak;
    self.pushView.block = ^(NSString * _Nonnull fileStr) {
        [wself requestResetNameWithModel:diskModel withFileName:fileStr];
    };
    [self.view addSubview:self.pushView];
}

- (void)noticePullRefresh {
    _page = 1;
    [self requestDiskListData];
}

- (void)noticeDropRefresh {
    _page ++;
    if (_page > _totalPage) {
        _page --;
        SLEndRefreshing(_tableView);
        return;
    }
    [self requestDiskListData];
}

-(void)fileOpeateWithModel:(OCDPersonDiskModel *)model isCellClick:(BOOL)flag{
    if (flag) {
        /* 下载路径 */
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
        NSString *filePath = [path stringByAppendingPathComponent:model.url.lastPathComponent];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            [self openFileWithPath:filePath];
        }else{
            [UIAlertController bme_alertWithTitle:@"提示" message:@"还未下载，是否需要下载？" sureTitle:@"确定" cancelTitle:@"取消" sureHandler:^(UIAlertAction * _Nonnull action) {
                Weak;
                [MBProgressHUD showMessage:@""];
                [APPRequest downloadFileWithFileName:model.name filePath:filePath requestUrlStr:model.url success:^(id responseObject) {
                    [MBProgressHUD hideHUD];
                    [wself openFileWithPath:responseObject];
                }];
            } cancelHandler:^(UIAlertAction * _Nonnull action) {}];
        }
    }else{
        NSMutableArray *tempArr = [NSMutableArray array];
        for (OCDPersonDiskModel *model in self.dataArray) {
            if (model.isSelected) {
                [tempArr addObject:model];
            }
        }
        
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        [MBProgressHUD showMessage:@""];
        
        self.downCount = 0;
        for (NSInteger i = 0; i < tempArr.count; i++) {
            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{
                @autoreleasepool {
                    OCDPersonDiskModel *model = tempArr[i];
                    /* 下载路径 */
                    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
                    NSString *filePath = [path stringByAppendingPathComponent:model.url.lastPathComponent];
                    
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    Weak;
                    if (![fileManager fileExistsAtPath:filePath]) {
                        wself.downCount++;
                        [APPRequest downloadFileWithFileName:model.name filePath:filePath requestUrlStr:model.url success:^(id responseObject) {
                            dispatch_group_leave(group);
//                            [wself openFileWithPath:responseObject];
                        }];
                    }
                }
            });
        }
        
        if (self.downCount==0) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showText:@"已下载"];
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"下载成功"];
        });
    }
}

-(void)openFileWithPath:(NSString *)pathStr{
    WKWebViewController *vc = [[WKWebViewController alloc] init];
    vc.urlStr1 = pathStr;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OCPersonDiskCell *cell = [OCPersonDiskCell initWithOCPersonDiskCellTableView:tableView
                                                           cellForRowAtIndexPath:indexPath];
    cell.diskModel = self.dataArray[indexPath.row];
    
    if ([cell.diskModel.fileType isEqualToString:@"jpeg"]) {
        cell.nameLab.text = NSStringFormat(@"fileImg%ld.jpg",indexPath.row+1);
    }
    cell.delegate = self;
    self.diskCell = cell;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OCDPersonDiskModel *model = self.dataArray[indexPath.row];
    [self fileOpeateWithModel:model isCellClick:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.diskCell.cellH;
}

#pragma mark - OCPersonDiskCell delegate
-(void)selectedWithCell:(OCPersonDiskCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    OCDPersonDiskModel *model = self.dataArray[indexPath.row];
    model.isSelected = !model.isSelected;
    self.selectedModel = model;
//    for (OCDPersonDiskModel *diskModel in self.dataArray) {
//        if ([diskModel.ID integerValue] == [model.ID integerValue]) {
//            diskModel.isSelected = YES;
//            self.selectedModel = diskModel;
//        }else{
//            diskModel.isSelected = NO;
//        }
//    }
    [self.tableView reloadData];
}

#pragma mark - 网络请求
-(void)uploadPicWithImg:(UIImage *)userImg{
    userImg = [OCPublicMethodManager reduceImage:userImg percent:0.6];
    NSArray *imgArr = userImg ? @[userImg] : @[];
    
    [MBProgressHUD showMessage:@""];
    Weak;
    [APPRequest postImageRequest:NSStringFormat(@"%@/%@v1/cloudDisk/add/file/0",kURL,APIUserURL) fileName:@"fileImg.jpeg" parameter:@{} postImageArray:imgArr success:^(id responseObject) {
        [MBProgressHUD showSuccess:@"上传成功"];
        [wself.tableView.mj_header beginRefreshing];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } controller:self];
}

-(void)requestResetNameWithModel:(OCDPersonDiskModel *)model withFileName:(NSString *)fileName{
    Weak;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"coverImg"] = model.coverImg;
    params[@"createTime"] = NSStringFormat(@"%ld",model.createTime);
    params[@"fileType"] = model.fileType;
    params[@"id"] = model.ID;
    params[@"name"] = fileName;
    params[@"parentId"] = model.parentId;
    params[@"size"] = model.size;
    params[@"type"] = NSStringFormat(@"%ld",model.type);
    params[@"url"] = model.url;
    params[@"userId"] = model.userId;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/cloudDisk/update",kURL,APIUserURL) parameters:params success:^(id responseObject) {
        [wself.tableView.mj_header beginRefreshing];
        NSLog(@"%@",responseObject);
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}

-(void)requestDiskListData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"currentPage"] = NSStringFormat(@"%ld",_page);
    params[@"pageSize"] = @"20";
    params[@"parentId"] = @"0";

    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/cloudDisk/list",kURL,APIUserURL) parameters:params success:^(id responseObject) {
        NSArray *list = [OCDPersonDiskModel objectArrayWithKeyValuesArray:responseObject[@"pageList"]];
        SLEndRefreshing(wself.tableView);
        if (wself.page == 1) {
            wself.selectedModel = nil;
            [wself.dataArray removeAllObjects];
        }
        wself.totalPage = [responseObject[@"totalPage"] integerValue];
        if (wself.page >= wself.totalPage) {
            wself.tableView.mj_footer.hidden = YES;
        }else{
            wself.tableView.mj_footer.hidden = NO;
        }
        [wself.dataArray addObjectsFromArray:list];
        [wself.tableView reloadData];
    } stateError:^(id responseObject) {
        SLEndRefreshing(wself.tableView);
    } failure:^(NSError *error) {
        SLEndRefreshing(wself.tableView);
    } viewController:self];
}
@end
