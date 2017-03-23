//
//  HomePageCommodityView.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/23.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "HomePageCommodityView.h"
#import "UIColor+HexColor.h"
#import "UIImage+ColorExistion.h"
#import "fanliView.h"
#import "Masonry.h"

@interface HomePageCommodityView ()

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet fanliView *fanliView;
@end

@implementation HomePageCommodityView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.priceLabel.textColor = HexCOLOR(@"#df3031");
    self.nameLabel.textColor = HexCOLOR(@"#5a5a5a");
    
    fanliView * view = [[NSBundle mainBundle]loadNibNamed:@"fanliView" owner:nil options:nil].firstObject;
     [self addSubview:view];
     self.fanliView = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(0);
    }];
   
    self.fanliView.hidden = YES;
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
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:cellModel.imageURLstr] placeholderImage:[UIImage imageWithColor:WifeButlerSeparateLineColor]];
    if (cellModel.danwei.length == 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",cellModel.money];
    }else
        self.priceLabel.text = [NSString stringWithFormat:@"%@元一%@",cellModel.money,cellModel.danwei];
    
    if ([_cellModel.ispayoff integerValue] == 1) { //返利
        self.fanliView.hidden = NO;
         NSInteger i = _cellModel.payoffper.doubleValue/0.01;
        self.fanliView.numLabel.text =[NSString stringWithFormat:@"%zd%%",i];
    }else{
        self.fanliView.hidden = YES;
        self.fanliView.numLabel.text = @"0%";
    }
}

@end
