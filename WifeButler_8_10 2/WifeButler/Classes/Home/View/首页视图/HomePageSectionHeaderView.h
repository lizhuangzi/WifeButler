//
//  HomePageSectionHeaderView.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/23.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageSectionModel.h"

@interface HomePageSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong) HomePageSectionModel * sectionModel;

+ (instancetype)HeaderViewWithTableView:(UITableView *)tableView;

@end
