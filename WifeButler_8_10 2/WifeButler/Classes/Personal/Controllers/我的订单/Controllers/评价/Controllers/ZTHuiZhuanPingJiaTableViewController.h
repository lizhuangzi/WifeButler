//
//  ZTHuiZhuanPingJiaTableViewController.h
//  YouHu
//
//  Created by ZT on 16/5/3.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTHuiZhuanPingJiaTableViewController : UITableViewController

@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, copy) NSString * order_id;
@property (nonatomic, copy) NSString * shop_id;

@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * titleTemp;

@property (nonatomic, copy) void (^shuaiXinBlack)(void);

@end
