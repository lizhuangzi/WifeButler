//
//  CommunityShopMainViewCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/2.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CommunityShopMainViewCell.h"
#import "fanliView.h"
#import "Masonry.h"

@interface CommunityShopMainViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;

@property (weak, nonatomic) IBOutlet UILabel *nowPriceView;
@property (weak, nonatomic) IBOutlet UILabel *orginPriceView;

@property (weak, nonatomic) IBOutlet UILabel *cellCountAndInventoryView;

@property (nonatomic,weak) fanliView * fanliView;

@end

@implementation CommunityShopMainViewCell

+ (instancetype)cellWithTalbeView:(UITableView *)tableView
{
    static NSString * ID = @"CommunityShopMainViewCell";
    
    CommunityShopMainViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CommunityShopMainViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    fanliView * view = [[NSBundle mainBundle]loadNibNamed:@"fanliView" owner:nil options:nil].firstObject;
//    [self addSubview:view];
//    self.fanliView = view;
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
//        make.width.mas_equalTo(30);
//        make.height.mas_equalTo(30);
//        make.right.mas_equalTo(-10);
//    }];
//    view.layer.cornerRadius = 15;
//    view.clipsToBounds = YES;
}

- (void)setModel:(CommunityShopMainModel *)model
{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.files] placeholderImage:nil];
    NSString * title = _model.title;
    if (_model.unit.length>0) {
        title = [NSString stringWithFormat:@"%@/%@",title,_model.unit];
    }
    self.titleView.text = title;
    self.nowPriceView.text = [NSString stringWithFormat:@"¥%@",model.money];
    self.orginPriceView.text = [NSString stringWithFormat:@"¥%@",_model.oldprice];
    self.cellCountAndInventoryView.text = [NSString stringWithFormat:@"销量:%@库存:%@",_model.sales,_model.store];
}

- (IBAction)shopButtonClick:(UIButton *)sender {
    
}

@end
