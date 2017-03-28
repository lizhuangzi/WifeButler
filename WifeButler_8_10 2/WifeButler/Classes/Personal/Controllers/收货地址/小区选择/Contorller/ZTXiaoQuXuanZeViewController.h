//
//  ZTXiaoQuXuanZeViewController.h
//  WifeButler
//
//  Created by ZT on 16/6/16.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTXiaoQuXuanZe.h"


@interface ZTXiaoQuXuanZeViewController : UIViewController

@property (nonatomic, copy) NSString * address_id;

@property (nonatomic, copy) void (^addressBlack)(ZTXiaoQuXuanZe *model);
/**0表示添加 1表示修改地址*/
@property (nonatomic,assign) NSInteger choseType;

@property (nonatomic,assign) double changeLongitude;
@property (nonatomic,assign) double changeLatitude;

@end
