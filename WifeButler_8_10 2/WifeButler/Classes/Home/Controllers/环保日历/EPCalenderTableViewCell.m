//
//  EPCalenderTableViewCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/6.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "EPCalenderTableViewCell.h"

@interface EPCalenderTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scroeLabel;
@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@end

@implementation EPCalenderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)detailClick:(UIButton *)sender {
}

@end
