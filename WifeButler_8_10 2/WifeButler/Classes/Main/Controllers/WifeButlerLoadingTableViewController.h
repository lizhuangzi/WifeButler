//
//  WifeButlerLoadingTableViewController.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/25.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WifeButlerLoadingTableView.h"


@interface WifeButlerLoadingTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,WifeButlerloadingTableViewDelegate>

@property (nonatomic,weak) WifeButlerLoadingTableView * tableView;

@end