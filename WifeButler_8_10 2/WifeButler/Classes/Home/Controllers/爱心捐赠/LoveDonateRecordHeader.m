//
//  LoveDonateRecordHeader.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "LoveDonateRecordHeader.h"

@interface LoveDonateRecordHeader ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *detailView;

@end

@implementation LoveDonateRecordHeader

+ (instancetype)headerView{
    return [[NSBundle mainBundle]loadNibNamed:@"LoveDonateRecordHeader" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = WifeButlerCommonRedColor;
    self.iconView.layer.cornerRadius = 23.5;
    self.iconView.clipsToBounds = YES;
}

- (void)setUsermodel:(MyDonateUserModel *)usermodel
{
    _usermodel = usermodel;
    [self.iconView sd_setImageWithURL:_usermodel.iconFullPath placeholderImage:PlaceHolderImage_Person];
    self.nameView.text = _usermodel.nickname;
    
    NSString * desc = [NSString stringWithFormat:@"感谢您累计捐的%@元善款，给他人带来了帮助",_usermodel.sum];
   
    self.detailView.text = desc;

}
@end
