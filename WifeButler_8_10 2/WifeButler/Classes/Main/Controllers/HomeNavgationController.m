//
//  HomeNavgationController.m
//  WifeButler
//
//  Created by yms on 16/9/4.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "HomeNavgationController.h"
#import "UIColor+HexColor.h"
#import "UIImage+ColorExistion.h"

@implementation HomeNavgationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:WifeButlerCommonRedColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationBar.translucent = NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:YES];
}

@end
