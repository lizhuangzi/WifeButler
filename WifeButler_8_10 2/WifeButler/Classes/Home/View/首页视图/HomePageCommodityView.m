//
//  HomePageCommodityView.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/23.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "HomePageCommodityView.h"
#import "UIColor+HexColor.h"
@interface HomePageCommodityView ()

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation HomePageCommodityView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.priceLabel.textColor = HexCOLOR(@"#df3031");
    self.nameLabel.textColor = HexCOLOR(@"#5a5a5a");
}

+ (instancetype)HomePageCommodityView
{
    HomePageCommodityView * view = [[NSBundle mainBundle]loadNibNamed:@"HomePageCommodityView" owner:nil options:nil].lastObject;
    return view;
}

- (void)setCellModel:(HomePageCellModel *)cellModel
{
    _cellModel = cellModel;
    self.nameLabel.text = cellModel.title;
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:cellModel.imageURLstr] placeholderImage:nil];
    if (cellModel.danwei.length == 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",cellModel.money];
    }else
        self.priceLabel.text = [NSString stringWithFormat:@"%@元一%@",cellModel.money,cellModel.danwei];
}

@end
