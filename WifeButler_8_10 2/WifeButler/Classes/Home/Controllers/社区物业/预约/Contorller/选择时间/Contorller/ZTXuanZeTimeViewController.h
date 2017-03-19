//
//  ZTXuanZeTimeViewController.h
//  WifeButler
//
//  Created by ZT on 16/6/12.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTXuanZeTimeViewController : UIViewController

@property (nonatomic, copy) NSString * goods_id;

@property (nonatomic, copy) NSString * exchange;

// 返回时间
@property (nonatomic, copy) void (^BackTimeBlack)(NSString *time);

@property (nonatomic,copy) NSString *  requestURLStr;

@end
