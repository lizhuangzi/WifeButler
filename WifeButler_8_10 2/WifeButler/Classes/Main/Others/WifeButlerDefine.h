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


#define DISPATCH_GLOBAL_QUEUE  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define tableViewEdgeInsetsLeft 10.0f
#define tableViewEdgeInsetsLeftNew 10.0f


#define systembigfont      15.0f

#define systemheaderfont   14.0f

#define systemcontentfont   13.0f

#define systemlittlefont    12.0f

#define systemNumfont 10.0f

#define ThinFont(font)  [UIFont systemFontOfSize:font weight:UIFontWeightLight]

#define MoreThaniOS7 ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
#define MoreThaniOS8 ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)

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
    return;\
}
//**********没有登录时提示的代码

//**** 网络请求失败时候svd的代码
#define SVDCommonErrorDeal   if (error.code == 40000) {\
                                WifeButlerLoginLosingEffection\
                                }\
                                else if (error.code == 20000 || error.code == 30000) {\
                                    if(error.userInfo[@"msg"]){\
                                         [SVProgressHUD showErrorWithStatus:error.userInfo[@"msg"]];\
                                    }else{\
                                       [SVProgressHUD showErrorWithStatus:@"数据请求发生错误"];\
                                    }\
                                }else{\
                                    [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];\
                                }
//**** 网络请求失败时候svd的代码

//**********列表页面请求成功时的自动处理 context默认是0
#define D_SuccessLoadingDeal(context,resultCode,block)  [SVProgressHUD dismiss];\
    NSArray * result = resultCode;\
    if ([result isKindOfClass:[NSArray class]]) {\
        if (self.page == 1) {\
            [self.dataArray removeAllObjects];\
        }\
        if (result.count == 0) { \
            if (self.page == 1) {\
                [SVProgressHUD showInfoWithStatus:@"无数据"];\
            }else{\
                self.page --;\
                [SVProgressHUD showInfoWithStatus:@"没有更多了"];\
            }\
        }else{ \
            !block?:block(result);\
        }\
        [self.tableView reloadData];\
        [self.tableView endRefreshing];\
    }
//***********列表页面请求成功时的自动处理

//**********列表页面请求失败时的自动处理context默认是0
#define D_FailLoadingDeal(context)   self.page = 1;\
    SVDCommonErrorDeal\
    [self.tableView endRefreshing]\
//**********列表页面请求失败时的自动处理


//***** Alert
#define D_CommonAlertShow(title,block)\
NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);\
NSString *otherButtonTitle = NSLocalizedString(@"确认", nil);\
UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];\
UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];\
UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {\
block();\
}];\
[vc addAction:action];\
[vc addAction:otherAction];\
[self presentViewController:vc animated:YES completion:nil];
//***** Alert
