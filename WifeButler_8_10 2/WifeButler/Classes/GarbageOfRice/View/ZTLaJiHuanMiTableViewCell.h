//
//  ZTLaJiHuanMiTableViewCell.h
//  WifeButler
//
//  Created by ZT on 16/5/18.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZTLaJiHuanMiModel;
@interface ZTLaJiHuanMiTableViewCell : UITableViewCell

@property (nonatomic,strong) ZTLaJiHuanMiModel * model;

+ (instancetype)LaJiHuanMiTableViewCellWithTableView:(UITableView *)tableView;

@end
