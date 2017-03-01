//
//  WifeButlerLoadingTableView.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/25.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@class WifeButlerLoadingTableView;

@protocol WifeButlerloadingTableViewDelegate <NSObject>

@optional
- (void)WifeButlerLoadingTableViewDidRefresh:(WifeButlerLoadingTableView *)tableView;

- (void)WifeButlerLoadingTableViewDidLoadingMore:(WifeButlerLoadingTableView *)tableView;
@end

@interface WifeButlerLoadingTableView : UITableView

@property (nonatomic,assign) BOOL headerRefreshEnable;

@property (nonatomic,assign) BOOL footerRefreshEnable;

@property (nonatomic,assign) id<WifeButlerloadingTableViewDelegate> loadingDelegate;

- (void)endRefreshing;

@end
