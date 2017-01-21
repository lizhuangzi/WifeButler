//
//  ZJGoodsDetailVC.h
//  WifeButler
//
//  Created by .... on 16/5/30.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJGoodsDetailVC : UIViewController
@property (nonatomic,copy)NSString*goodId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addToBuyBus:(id)sender;
@end
