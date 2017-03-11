//
//  BalanceViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/11.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "BalanceViewController.h"
#import "BalanceRecordViewController.h"

@interface BalanceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UIButton *btnRecharge;

@property (weak, nonatomic) IBOutlet UIButton *btnWithDraw;

@end

@implementation BalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"余额";
    self.btnRecharge.layer.cornerRadius = 5;
    self.btnWithDraw.layer.cornerRadius = 5;
    self.btnWithDraw.clipsToBounds = YES;
    self.btnRecharge.clipsToBounds = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(recordClick)];
}
#pragma mark - 提现点击
- (IBAction)withdrawClick {
    
}
#pragma mark - 充值点击
- (IBAction)rechargeClick {
    
}

#pragma mark - 记录点击
- (void)recordClick
{
    BalanceRecordViewController * b = [[BalanceRecordViewController alloc]init];
    [self.navigationController pushViewController:b animated:YES];
}


@end
