//
//  ZTLaJiJieShuanTableViewController.h
//  WifeButler
//
//  Created by ZT on 16/5/26.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTYouHuiJuanModel.h"

@interface ZTLaJiJieShuanTableViewController : UITableViewController

/**
 *  价格
 */
@property (nonatomic, assign) float price;
/**
 *  数量
 */
@property (nonatomic, copy) NSString * num;
/**
 *  id
 */
@property (nonatomic, copy) NSString * tempId;

/**
 *  运费
 */
@property (nonatomic, copy) NSString * yunFei;

/**
 *  颜色
 */
@property (nonatomic, copy) NSString * colorShop;

@end
