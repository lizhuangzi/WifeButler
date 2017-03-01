//
//  tempLoadingViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/1.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "tempLoadingViewController.h"

@interface tempLoadingViewController ()

@end

@implementation tempLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"启动页"];
    [self.view addSubview:imageView];
    
    imageView.frame = CGRectMake(0, 0, iphoneWidth, iphoneHeight);
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
