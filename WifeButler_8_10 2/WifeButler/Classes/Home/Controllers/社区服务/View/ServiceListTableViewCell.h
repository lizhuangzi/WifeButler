//
//  ServiceListTableViewCell.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/9.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServiceListModel;
@interface ServiceListTableViewCell : UITableViewCell

@property (nonatomic,strong) ServiceListModel * model;

+ (instancetype)serviceListTableViewCellWithTableView:(UITableView *)tableView;

@end
