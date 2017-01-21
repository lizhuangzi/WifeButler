//
//  ZJGuangLiShouHuoDiZhiViewController.h
//  YouHu
//
//  Created by zjtd on 16/4/18.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTShouHuoAddressModel.h"

@interface ZJGuangLiShouHuoDiZhiViewController : UIViewController

/**
 *  是否返回
 */
@property (nonatomic, assign) BOOL isBack;

// 返回地址
@property (nonatomic, copy) void (^addressBlack)(ZTShouHuoAddressModel *model);

@property (nonatomic,copy) void(^returnBackBlock)();

@end
