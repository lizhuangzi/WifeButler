//
//  ZTSheQuFuWuCollectionViewCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/9.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "ZTSheQuFuWuCollectionViewCell.h"
#import "ZTSheQuFuWuCollectionViewCellModel.h"
#import "WifeButlerDefine2.h"
@interface ZTSheQuFuWuCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation ZTSheQuFuWuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ZTSheQuFuWuCollectionViewCellModel *)model
{
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_model.imageURLStr] placeholderImage:PlaceHolderImage_Other];
    self.nameLabel.text = _model.name;
}

@end
