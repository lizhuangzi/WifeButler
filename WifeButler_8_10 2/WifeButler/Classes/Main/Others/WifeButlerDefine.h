//
//  WifeButlerDefine.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/24.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJLoginController.h"
#import "WifeButlerAccount.h"

/**请求数据返状态判断*/
extern int const SUCCESS;
extern NSString * const CodeKey;

/**经纬度*/
extern NSString * const WifeButlerLongtitudeKey;
extern NSString * const  WifeButlerLatitudeKey;
/**是否记住密码*/
extern NSString * const WifeButlerisRememberPasswrod;

#define WEAKSELF typeof(self) __weak weakSelf = self;


//************** 登录失效时的代码
#define WifeButlerLoginLosingEffection   __weak typeof(self) weakSelf = self;\
UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您登录已经失效,请重新进行登录哦!" preferredStyle:UIAlertControllerStyleAlert];\
UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {\
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];\
    ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];\
    vc.isLogo = YES;\
    [weakSelf.navigationController pushViewController:vc animated:YES];\
}];\
[vc addAction:otherAction];\
[weakSelf presentViewController:vc animated:YES completion:nil];

//*****************

//**********没有登录时提示的代码

#define  WifeButlerLetUserLoginCode  if (![WifeButlerAccount sharedAccount].isLogin) {\
    __weak typeof(self) weakSelf = self;\
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有登录,请先进行登录哦!" preferredStyle:UIAlertControllerStyleAlert];\
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {\
    }];\
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {\
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];\
        ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];\
        vc.isLogo = YES;\
        [weakSelf.navigationController pushViewController:vc animated:YES];\
    }];\
    [vc addAction:action];\
    [vc addAction:otherAction];\
    [weakSelf presentViewController:vc animated:YES completion:nil];\
}
//**********没有登录时提示的代码

//**** 网络请求失败时候svd的代码
#define SVDCommonErrorDeal   if (error.code == 40000) {\
                                WifeButlerLoginLosingEffection\
                                }\
                                else if (error.code == 20000) {\
                                    [SVProgressHUD showErrorWithStatus:@"数据请求发生错误"];\
                                }else{\
                                    [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];\
                                }
//**** 网络请求失败时候svd的代码

