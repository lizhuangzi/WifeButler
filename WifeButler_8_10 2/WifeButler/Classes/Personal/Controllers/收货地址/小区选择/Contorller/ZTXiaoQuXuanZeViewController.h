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

@end
