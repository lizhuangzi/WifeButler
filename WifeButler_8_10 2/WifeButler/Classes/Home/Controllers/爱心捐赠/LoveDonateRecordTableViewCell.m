//
//  LoveDonateRecordTableViewCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "LoveDonateRecordTableViewCell.h"
#import "LoaveDonateRecorelistModel.h"

@interface LoveDonateRecordTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *timeView;
@property (weak, nonatomic) IBOutlet UILabel *moneyView;
@property (weak, nonatomic) IBOutlet UILabel *donateSuccessView;

@end

@implementation LoveDonateRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.donateSuccessView.layer.cornerRadius = 4;
    self.donateSuccessView.clipsToBounds = YES;
    self.moneyView.textColor = WifeButlerCommonRedColor;
}

- (void)setModel:(LoaveDonateRecorelistModel *)model
{
    _model = model;
    self.titleView.text = _model.name;
    self.timeView.text = _model.ctime;
    self.moneyView.text = [NSString stringWithFormat:@"%@元",_model.money];
    
    if ([_model.ispay intValue] == 2) {
        self.donateSuccessView.hidden = NO;
    }else{
        self.donateSuccessView.hidden = YES;
    }
}
@end
