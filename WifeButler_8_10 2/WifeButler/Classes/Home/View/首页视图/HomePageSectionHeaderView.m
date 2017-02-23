//
//  HomePageSectionHeaderView.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/23.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "HomePageSectionHeaderView.h"

@interface HomePageSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView * picture;

@end

@implementation HomePageSectionHeaderView

- (void)setSectionModel:(HomePageSectionModel *)sectionModel
{
    _sectionModel = sectionModel;
    
    NSString * imageStr = [KImageUrl stringByAppendingString:sectionModel.banner];
    [self.picture sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil];
}

+ (instancetype)HeaderViewWithTableView:(UITableView *)tableView{
    
    NSString * const ID = @"HomePageSectionHeaderView";
    HomePageSectionHeaderView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!view) {
        view = [[NSBundle mainBundle]loadNibNamed:@"HomePageSectionHeaderView" owner:nil options:nil].lastObject;
    }
    return view;
}

@end
