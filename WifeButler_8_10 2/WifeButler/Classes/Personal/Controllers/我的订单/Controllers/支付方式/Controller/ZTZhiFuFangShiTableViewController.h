//
//  ZTZhiFuFangShiTableViewController.h
//  WifeButler
//
//  Created by ZT on 16/5/29.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTZhiFuFangShiTableViewController : UITableViewController

@property (nonatomic, copy) NSString * order_id;

@property (nonatomic, copy) void (^shuaiXinBlack)(void);

@end
