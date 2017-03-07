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

+ (instancetype)calenderTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"EPCalenderTableViewCell";
    EPCalenderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
       cell = [[NSBundle mainBundle]loadNibNamed:@"EPCalenderTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = WifeButlerTableBackGaryColor;
    self.roundView.layer.cornerRadius = 4;
    self.backGroundView.layer.cornerRadius = 4;
}


- (void)setModel:(EPCalendarModel *)model
{
    _model = model;
    self.titleView.text = _model.title;
    self.timeLabel.text = _model.ctime;
   
    if ([_model.flag isEqualToString:@"1"]) {
        self.scroeLabel.text = [NSString stringWithFormat:@"+%@分",model.num];
        self.scroeLabel.textColor = HexCOLOR(@"#328d3d");
        self.roundView.backgroundColor = HexCOLOR(@"#328d3d");
    }else{
        self.scroeLabel.text = [NSString stringWithFormat:@"-%@分",model.num];
        self.scroeLabel.textColor = WifeButlerCommonRedColor;
        self.roundView.backgroundColor = WifeButlerCommonRedColor;
    }
}

- (IBAction)detailClick:(UIButton *)sender {
    
}

@end
