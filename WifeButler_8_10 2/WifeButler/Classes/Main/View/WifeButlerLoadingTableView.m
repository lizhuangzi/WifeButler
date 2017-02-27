//
//  WifeButlerLoadingTableView.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/25.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerLoadingTableView.h"
#import "MJRefresh.h"

@implementation WifeButlerLoadingTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.headerRefreshEnable = YES;
        self.footerRefreshEnable = YES;
    }
    return self;
}

- (void)setHeaderRefreshEnable:(BOOL)headerRefreshEnable
{
    __weak typeof(self) weakSelf = self;

    _headerRefreshEnable = headerRefreshEnable;
    
    if (!_headerRefreshEnable) {
        self.mj_header = nil;
    }else{
        self.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            if ([weakSelf.loadingDelegate respondsToSelector:@selector(WifeButlerLoadingTableViewDidRefresh:)]) {
                [weakSelf.loadingDelegate WifeButlerLoadingTableViewDidRefresh:weakSelf];
            }
        }];
    }
}

- (void)setFooterRefreshEnable:(BOOL)footerRefreshEnable
{
     __weak typeof(self) weakSelf = self;
    
    _footerRefreshEnable = footerRefreshEnable;
    
    if (!_footerRefreshEnable) {
        self.mj_footer = nil;
        
    }else{
        self.mj_footer =  [MJRefreshBackFooter footerWithRefreshingBlock:^{
            
            if ([weakSelf.loadingDelegate respondsToSelector:@selector(WifeButlerLoadingTableViewDidLoadingMore:)]) {
                [weakSelf.loadingDelegate WifeButlerLoadingTableViewDidLoadingMore:weakSelf];
            }
        }];
    }
}


- (void)endRefreshing
{
    [self.mj_footer endRefreshing];
    [self.mj_header endRefreshing];
}

@end
