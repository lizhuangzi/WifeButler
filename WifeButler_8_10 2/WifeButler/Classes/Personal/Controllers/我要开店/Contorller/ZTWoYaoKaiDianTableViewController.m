//
//  ZTWoYaoKaiDianTableViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/4.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTWoYaoKaiDianTableViewController.h"
#import "ZTKaiDianTableViewController.h"
#import "ZTDianPuXinXiTableViewController.h"

@interface ZTWoYaoKaiDianTableViewController ()


@property (weak, nonatomic) IBOutlet UIButton *dian1Btn;
@property (weak, nonatomic) IBOutlet UIButton *dian2Btn;
@property (weak, nonatomic) IBOutlet UIButton *dian3Btn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@end

@implementation ZTWoYaoKaiDianTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新开店铺";
    
    self.nextBtn.layer.borderWidth = 1;
    self.nextBtn.layer.borderColor = [UIColor colorWithRed:0.039 green:0.675 blue:0.569 alpha:1.000].CGColor;
    
    [self dianPu1Claick:nil];
    
    NSSaveUserDefaults(@"0", @"ZTAddressZT")
}


- (IBAction)dianPu1Claick:(id)sender {
    
    NSSaveUserDefaults(@"1", @"Shop_type");
    
    self.dian1Btn.selected = YES;
    self.dian2Btn.selected = NO;
    self.dian3Btn.selected = NO;
}

- (IBAction)dianPu2Click:(id)sender {
    
    NSSaveUserDefaults(@"2", @"Shop_type");

    
    self.dian1Btn.selected = NO;
    self.dian2Btn.selected = YES;
    self.dian3Btn.selected = NO;
}

- (IBAction)dianPu3Click:(id)sender {
    
    NSSaveUserDefaults(@"3", @"Shop_type");

    self.dian1Btn.selected = NO;
    self.dian2Btn.selected = NO;
    self.dian3Btn.selected = YES;
}

#pragma mark - 下一步
- (IBAction)nextClick:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTWoYaoKaiDian" bundle:nil];
    ZTKaiDianTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTKaiDianTableViewController"];

    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
