//
//  EnzymesRecycleViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/17.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "EnzymesRecycleViewController.h"
#import "HuoQuFaJiaoTongViewController.h"
#import "WifeButlerNetWorking.h"
#import "NetWorkPort.h"
#import "EPCalendarViewController.h"

@interface EnzymesRecycleViewController ()

@end

@implementation EnzymesRecycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"酵素回收";
    self.view.backgroundColor = WifeButlerTableBackGaryColor;
    
}

- (IBAction)huoquClick:(id)sender {
    
    HuoQuFaJiaoTongViewController * huoqu = [HuoQuFaJiaoTongViewController new];
    [self.navigationController pushViewController:huoqu animated:YES];
}
- (IBAction)seekRecyclePoint:(id)sender {
    
    [SVProgressHUD showInfoWithStatus:@"暂未开通"];
}

- (IBAction)getKonwledgeOfEnzymes
{
    [SVProgressHUD showInfoWithStatus:@"暂未开通"];
}

- (IBAction)recycleRecord
{
    EPCalendarViewController * calendar = [[EPCalendarViewController alloc]init];
    [self.navigationController pushViewController:calendar animated:YES];

}

@end
