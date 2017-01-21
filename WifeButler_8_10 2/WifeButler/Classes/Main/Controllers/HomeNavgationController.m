//
//  HomeNavgationController.m
//  WifeButler
//
//  Created by yms on 16/9/4.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "HomeNavgationController.h"
#import "UIColor+HexColor.h"

@implementation HomeNavgationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
    
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    self.navigationBar.tintColor = WifeButlerCommonRedColor;

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    [self.navigationBar setBarTintColor:WifeButlerCommonRedColor];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController * vc = [super popViewControllerAnimated:animated];
    if (self.viewControllers.count == 1) {
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
        
        [self.navigationBar setBarTintColor:[UIColor whiteColor]];
        
        self.navigationBar.tintColor = WifeButlerCommonRedColor;
    }
    
    return vc;
}

@end
