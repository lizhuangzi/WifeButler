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


/**返利相关*/
@property (weak, nonatomic) IBOutlet UIView *fanliView;

@property (weak, nonatomic) IBOutlet UILabel *fanliPercent;

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
    
    if ([_model.ispayoff integerValue] == 1) { //返利
        self.fanliView.hidden = NO;
        NSInteger i = _model.payoffper.doubleValue/0.01;
        self.fanliPercent.text =[NSString stringWithFormat:@"%zd%%",i];
    }else{
        self.fanliView.hidden = YES;
        self.fanliPercent.text = @"0%";
    }

}

- (IBAction)shopButtonClick:(UIButton *)sender {
    
}

@end
