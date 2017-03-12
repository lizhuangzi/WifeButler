//
//  CardPocketTableViewCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/11.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CardPocketTableViewCell.h"
#import "CardPocklistModel.h"

@interface CardPocketTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *cardBankName;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;
@property (weak, nonatomic) IBOutlet UIView *colorfulBackGroundView;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@end

@implementation CardPocketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    int x = arc4random() % 4;
    self.backImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"cardPocket%d",x]];
}

- (void)setModel:(CardPocklistModel *)model
{
    _model  = model;
    self.cardTypeLabel.text = _model.type;
    self.cardBankName.text = _model.bankname;
    self.cardNumLabel.text = _model.cardNum;
    
   
}
@end
