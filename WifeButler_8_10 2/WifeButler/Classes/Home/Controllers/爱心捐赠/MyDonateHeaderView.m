//
//  MyDonateHeaderView.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "MyDonateHeaderView.h"
#import "MyDonateUserModel.h"

@interface MyDonateHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;

@property (weak, nonatomic) IBOutlet UILabel *thanksView;
@end

@implementation MyDonateHeaderView

+ (instancetype)headerView{
    
    return [[NSBundle mainBundle]loadNibNamed:@"MyDonateHeaderView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.iconView.layer.cornerRadius = 25;
    self.iconView.clipsToBounds = YES;
}

- (void)setModel:(MyDonateUserModel *)model
{
    _model = model;
    
    [self.iconView sd_setImageWithURL:_model.iconFullPath placeholderImage:PlaceHolderImage_Person];
    self.nameView.text = _model.nickname;
    
    NSString * desc = [NSString stringWithFormat:@"感谢您累计捐的%@元善款，给他人带来了帮助",_model.sum];
    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:desc];
    
    [attstr addAttribute:NSForegroundColorAttributeName value:WifeButlerCommonRedColor range:NSMakeRange(7, _model.sum.length)];
    self.thanksView.attributedText = attstr;
    
}

- (IBAction)recordClick:(id)sender {
    
    !self.returnBlock?:self.returnBlock(self.model);
}


@end
