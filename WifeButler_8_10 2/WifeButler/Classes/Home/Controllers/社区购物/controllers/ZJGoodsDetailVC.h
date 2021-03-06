//
//  ZJGoodsDetailVC.h
//  WifeButler
//
//  Created by .... on 16/5/30.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodDetilBottomView.h"

@interface ZJGoodsDetailVC : UIViewController
@property (nonatomic,copy)NSString*goodId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic,copy)int(^settingBottomBlock)(GoodDetilBottomView * bottomView);
@property (nonatomic,copy)void(^usefulDataBlock)(NSDictionary * dataDict);

@end
