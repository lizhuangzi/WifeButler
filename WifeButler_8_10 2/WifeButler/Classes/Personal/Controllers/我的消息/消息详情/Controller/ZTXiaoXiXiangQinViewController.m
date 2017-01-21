//
//  ZTXiaoXiXiangQinViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/23.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTXiaoXiXiangQinViewController.h"

@interface ZTXiaoXiXiangQinViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *desLab;



@end

@implementation ZTXiaoXiXiangQinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的消息";
    
    self.titleLab.text = self.titleZ;
    self.desLab.text = self.desZ;
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
