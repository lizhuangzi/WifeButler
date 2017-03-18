//
//  JieSuanTableSectionHeader.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/17.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "JieSuanTableSectionHeader.h"

@implementation JieSuanTableSectionHeader

+ (instancetype)HeaderViewWithTableView:(UITableView *)tableView{
    
    NSString * const ID = @"JieSuanTableSectionHeader";
    JieSuanTableSectionHeader * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!view) {
        view = [[NSBundle mainBundle]loadNibNamed:@"JieSuanTableSectionHeader" owner:nil options:nil].lastObject;
    }
    return view;
}


@end
