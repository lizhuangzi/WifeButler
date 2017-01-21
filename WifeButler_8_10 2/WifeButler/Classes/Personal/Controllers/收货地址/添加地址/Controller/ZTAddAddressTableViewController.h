//
//  ZTAddAddressTableViewController.h
//  WifeButler
//
//  Created by ZT on 16/6/1.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTAddAddressTableViewController : UITableViewController

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

/**
 *  地址
 */
@property (nonatomic, copy) NSString * address_id;


@property (nonatomic, copy) void (^relshBlack)(void);


@end
