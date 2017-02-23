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

@interface HomePageCommodityCell : UITableViewCell

@property (nonatomic,strong) HomePageSectionModel * model;

+ (instancetype)CommodityCellWithTableView:(UITableView *)tableView;

@end
