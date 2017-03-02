//
//  CommunityShopMainViewCell.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/2.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityShopMainModel.h"

@interface CommunityShopMainViewCell : UITableViewCell

@property (nonatomic,strong) CommunityShopMainModel * model;

+ (instancetype)cellWithTalbeView:(UITableView *)tableView;
@end
