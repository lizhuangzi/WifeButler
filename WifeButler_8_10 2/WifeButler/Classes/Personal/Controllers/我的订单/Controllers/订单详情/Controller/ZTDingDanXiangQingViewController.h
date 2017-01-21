//
//  ZTDingDanXiangQingViewController.h
//  WifeButler
//
//  Created by ZT on 16/5/29.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTDingDanXiangQingViewController : UIViewController

@property (nonatomic, copy) NSString * order_id;

@property (nonatomic, copy) NSString * statai_temp;

/**
 *   支付方式
 */
@property (nonatomic, copy) NSString * pay_way;

@property (nonatomic, copy) void (^ShuaiXinBlack)(void);

@end
