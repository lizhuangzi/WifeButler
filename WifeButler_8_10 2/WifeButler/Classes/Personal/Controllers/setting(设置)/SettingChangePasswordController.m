//
//  SettingChangePasswordController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/11.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "SettingChangePasswordController.h"

@interface SettingChangePasswordController ()

@property (nonatomic,strong) ZJSeakPassWordVC * pwdVc;

@end

@implementation SettingChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
    self.pwdVc = [story instantiateViewControllerWithIdentifier:@"ZJSeakPassWordVC"];
    self.pwdVc.view.frame = self.view.bounds;
    [self.view addSubview:self.pwdVc.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
