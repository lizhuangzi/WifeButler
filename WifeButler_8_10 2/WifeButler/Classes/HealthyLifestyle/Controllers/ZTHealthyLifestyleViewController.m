
//
//  ZTHealthyLifestyleViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/16.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTHealthyLifestyleViewController.h"
#import "masonry.h"
#import "XMGSocialViewController.h"

@interface ZTHealthyLifestyleViewController ()

@end

@implementation ZTHealthyLifestyleViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

}

- (void)setupChildVc
{
    XMGSocialViewController *social0 = [[XMGSocialViewController alloc] init];
    social0.title = @"老伴头条";
    [self addChildViewController:social0];
    
    XMGSocialViewController *social1 = [[XMGSocialViewController alloc] init];
    social1.title = @"垃圾分类";
    [self addChildViewController:social1];
    
    XMGSocialViewController *social2 = [[XMGSocialViewController alloc] init];
    social2.title = @"环保知识";
    [self addChildViewController:social2];
    
    XMGSocialViewController *social3 = [[XMGSocialViewController alloc] init];
    social3.title = @"社区活动";
    [self addChildViewController:social3];
    
    XMGSocialViewController *social4 = [[XMGSocialViewController alloc] init];
    social4.title = @"养生保健";
    [self addChildViewController:social4];
    
    XMGSocialViewController *social5 = [[XMGSocialViewController alloc] init];
    social5.title = @"健康生活";
    [self addChildViewController:social5];
    
    XMGSocialViewController *social6 = [[XMGSocialViewController alloc] init];
    social6.title = @"近期热点";
    [self addChildViewController:social6];
}

@end
