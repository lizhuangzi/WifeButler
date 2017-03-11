//
//  CardPocketAddViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/11.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CardPocketAddViewController.h"

@interface CardPocketAddViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UITextField *cardPersonNameFiled;
@property (weak, nonatomic) IBOutlet UITextField *cardNumNameFiled;

@end

@implementation CardPocketAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"添加银行卡";
    self.sureButton.layer.cornerRadius = 5;
    self.sureButton.clipsToBounds = YES;
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
