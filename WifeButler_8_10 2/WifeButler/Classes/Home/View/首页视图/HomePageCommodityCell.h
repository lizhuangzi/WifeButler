//
//  HomePageCommodityCell.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/23.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageSectionModel.h"
#import "HomePageCommodityView.h"

@class HomePageCommodityCell;
@protocol HomePageCommodityCellDelegate <NSObject>

- (void)HomePageCommodityCell:(HomePageCommodityCell *)cell didClickFindMore:(HomePageSectionModel *)model;

- (void)HomePageCommodityCell:(HomePageCommodityCell *)cell didClickOneCommdity:(HomePageCellModel *)model;
@end

@interface HomePageCommodityCell : UITableViewCell

@property (nonatomic,strong) HomePageSectionModel * model;

+ (instancetype)CommodityCellWithTableView:(UITableView *)tableView;

@property (nonatomic,assign) id<HomePageCommodityCellDelegate> delegate;

@end
