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

/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextF;

/**
 *  手机号码
 */
@property (weak, nonatomic) IBOutlet UITextField *iphoneTextF;

/**
 *  邮编
 */
@property (weak, nonatomic) IBOutlet UITextField *youBianTextF;

/**
 *  地址1
 */
@property (weak, nonatomic) IBOutlet UITextField *address1TextF;

/**
 *  地址2
 */
@property (weak, nonatomic) IBOutlet UITextView *address2TextV;

/**
 *  默认地址
 */
@property (weak, nonatomic) IBOutlet UISwitch *isMoRenAddress;


@property (nonatomic, copy) void (^relshBlack)(void);


@end
