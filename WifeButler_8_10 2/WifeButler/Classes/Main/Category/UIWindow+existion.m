//
//  UIWindow+existion.m
//  QF微博
//
//  Created by MS on 15-9-10.
//  Copyright (c) 2015年 QF. All rights reserved.
//

#import "UIWindow+existion.h"
#import "ZJTabBarController.h"
#import "UserGuideViewController.h"
#import "WifeButlerAccount.h"
#import "ZJLoginController.h"
#import "tempLoadingViewController.h"

@implementation UIWindow (existion)

- (void)switchRootViewController{
    
//    NSString * key = @"CFBundleVersion";
//    NSString * lastVersion = [[NSUserDefaults standardUserDefaults]objectForKey:@"version"];
//    NSString * currentVersion = [NSBundle mainBundle].infoDictionary[key];
   // if ([lastVersion isEqualToString:currentVersion]) {
    
    //1.看下本地是否有账号密码 有的话自动登录
    NSString * account = [WifeButlerAccount sharedAccount].userParty.userLoginAccount;
    NSString * pwd = [WifeButlerAccount sharedAccount].userParty.userLoginPassWord;
    ZJTabBarController * tabbar = [[ZJTabBarController alloc]init];
    
   
    
    if (pwd.length>0 && account.length>0) {
        
        tempLoadingViewController * temp = [[tempLoadingViewController alloc]init];
        self.rootViewController = temp;
        //自动登录
        [ZJLoginController autoLoginWithUserName:account Password:pwd andfinishBlock:^(LoginResultReturnType returnType) {
            
            if (returnType == LoginResultReturnTypeSuccess) {
                self.rootViewController = tabbar;
            }else{
                self.rootViewController = tabbar;
                
                UINavigationController * nv = tabbar.viewControllers.firstObject;
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
                ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
                vc.isLogo = YES;
                [nv pushViewController:vc animated:YES];
            }
        }];
        
    }else{
        self.rootViewController = tabbar;
        
        UINavigationController * nv = tabbar.viewControllers.firstObject;
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
        ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
        vc.isLogo = YES;
        [nv pushViewController:vc animated:YES];
    }
   
//    }else{
//        self.window.rootViewController = [[LZZNewfeatureViewController alloc]init];
//        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"version"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    }    
}

- (void)switchGuidViewController
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UserGuideViewController *userGuideViewController = [[UserGuideViewController alloc] init];
    self.rootViewController = userGuideViewController;

}

- (BOOL)isFirstLaunch
{
    return  ![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"];
}


@end
