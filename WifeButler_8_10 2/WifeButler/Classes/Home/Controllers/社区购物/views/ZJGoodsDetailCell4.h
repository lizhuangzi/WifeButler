//
//  ZJGoodsDetailCell4.h
//  WifeButler
//
//  Created by .... on 16/5/30.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"

@interface ZJGoodsDetailCell4 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pingLunLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,weak) IBOutlet XHStarRateView * startView;

@end
