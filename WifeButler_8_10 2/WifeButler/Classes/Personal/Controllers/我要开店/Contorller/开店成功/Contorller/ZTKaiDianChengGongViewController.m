//
//  ZTKaiDianChengGongViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/18.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTKaiDianChengGongViewController.h"
#import "ZTKaiDianAddressViewController.h"

@interface ZTKaiDianChengGongViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;


@end

@implementation ZTKaiDianChengGongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btn1.selected = YES;
    self.btn2.selected = YES;
    self.btn3.selected = YES;
    self.btn4.selected = YES;
    
    self.title = @"我的开店";
    
}

- (IBAction)jinRuDianPuClick:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTWoYaoKaiDian" bundle:nil];
    ZTKaiDianAddressViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTKaiDianAddressViewController"];
    vc.phpAddress = self.phpAddress;
    vc.passWord = self.passWord;
    vc.zhangHao = self.zhangHao;
    [self.navigationController pushViewController:vc animated:YES];
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
