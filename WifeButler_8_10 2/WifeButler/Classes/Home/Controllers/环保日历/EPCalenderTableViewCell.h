//
//  EPCalenderTableViewCell.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/6.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPCalendarModel.h"

@interface EPCalenderTableViewCell : UITableViewCell

+ (instancetype)calenderTableViewCellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) EPCalendarModel * model;

@end
