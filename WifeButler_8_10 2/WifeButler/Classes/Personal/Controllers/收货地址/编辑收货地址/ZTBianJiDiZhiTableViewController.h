//
//  ZTBianJiDiZhiTableViewController.h
//  YouHu
//
//  Created by zjtd on 16/4/18.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTBianJiDiZhiTableViewController : UITableViewController

/**
 *  是否是添加地址界面   YES:添加知道   NO:编辑知道
 */
@property (nonatomic, assign) BOOL isAddAddress;

@property (nonatomic,copy)NSString * address_id;




@property (nonatomic, copy) void (^relshBlack)(void);


@end
