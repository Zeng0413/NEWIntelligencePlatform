//
//  OCSettingsViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/25.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCSettingsViewController.h"
#import "loginViewController.h"
#import "OCOpinionViewController.h"
#import "OCAboutAsUViewController.h"

@interface OCSettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLab;

@end

@implementation OCSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"设置" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString * version = NSStringFormat(@"%@V%@",kEnv,app_Version);
    self.versionLab.text = version;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)quitLoginClick:(id)sender {
    [OCUserModel clearUserData];
    loginViewController * login = [[loginViewController alloc] init];
    TSNavigationController *tabNav = [[TSNavigationController alloc] initWithRootViewController:login];
    [UIApplication sharedApplication].delegate.window.rootViewController = tabNav;
}

- (IBAction)aboutAsClick:(id)sender {
    OCAboutAsUViewController *vc = [[OCAboutAsUViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)opinionClick:(id)sender {
    OCOpinionViewController *vc = [[OCOpinionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
