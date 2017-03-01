//
//  AppDelegate.m
//  Fish
//
//  Created by zjtdmac3 on 15/6/5.
//  Copyright (c) 2015年 zjtdmac3. All rights reserved.
//

#import "AppDelegate.h"
#import "UserGuideViewController.h"
#import "ZJTabBarController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "ZJLoginController.h"
#import "WifeButlerAccount.h"
#import "UIWindow+existion.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
  
    if (self.window.isFirstLaunch) {
        
        [self.window switchGuidViewController];
    }else{
        [self.window switchRootViewController];
    }
    [self.window makeKeyAndVisible];

    
    //向微信注册wxd930ea5d5a258f4f
    [WXApi registerApp:@"wx4fe9cfcc13e33a10" withDescription:@"weiXinWifeButler"];
    [AMapServices sharedServices].apiKey = @"f7ecc75a1f94250a64b6a81b70c60914";
    
    return YES;
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    if ([url.host isEqualToString:@"pay"]) {
        
        return  [WXApi handleOpenURL:url delegate:self];
        
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return  [WXApi handleOpenURL:url delegate:self];
    
}


- (void) onResp:(BaseResp*)resp
{
    NSLog(@"%@",resp);
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
    
        switch (resp.errCode) {
            case WXSuccess:
                
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        SendAuthResp *aresp=(SendAuthResp *)resp;
        
        // 支付成功
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            [[NSUserDefaults standardUserDefaults] setObject:code forKey:@"WXcode"];
        }
    }
    
    // 创建通知 传递支付结果
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZT_WeiXinPay" object:@(resp.errCode)];
    
//    if (resp.errCode == 0) {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//    
//    if (resp.errCode == -1) {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付异常" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//    
//    if (resp.errCode == -2) {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"用户中途取消支付" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

/**
 *  程序进入唤醒状态
 *
 *
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
