//
//  BalanceRecordTableViewCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/11.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "BalanceRecordTableViewCell.h"
#import "BalanceRecordListModel.h"

@interface BalanceRecordTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@end

@implementation BalanceRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setModel:(BalanceRecordListModel *)model
{
    _model = model;
    if (_model.flag == 1) {
        self.numLabel.text = [NSString stringWithFormat:@"+%@",_model.money];
        self.numLabel.textColor = HexCOLOR(@"#328d3d");
    }else{
        self.numLabel.text = [NSString stringWithFormat:@"-%@",_model.money];
        self.numLabel.textColor = WifeButlerCommonRedColor;
    }
    self.timeLabel.text = _model.ctime;
    self.nameLabel.text = _model.name;
}

@end
