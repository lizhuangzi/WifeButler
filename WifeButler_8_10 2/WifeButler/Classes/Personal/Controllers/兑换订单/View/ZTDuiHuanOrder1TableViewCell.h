//
//  ZTDuiHuanOrder1TableViewCell.h
//  WifeButler
//
//  Created by ZT on 16/8/5.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTDuiHuanOederModel.h"

@interface ZTDuiHuanOrder1TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@property (weak, nonatomic) IBOutlet UIButton *queRenBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, copy) void (^queRenBlock)(void);

- (void)setDataSourceModel:(ZTDuiHuanOederModel *)model;

@end
