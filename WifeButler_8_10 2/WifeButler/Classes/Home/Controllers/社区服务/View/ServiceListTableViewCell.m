//
//  ServiceListTableViewCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/9.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "ServiceListTableViewCell.h"
#import "ServiceListModel.h"

@interface ServiceListTableViewCell ()
/**名字*/
@property (weak, nonatomic) IBOutlet UILabel *nameView;
/**现价*/
@property (weak, nonatomic) IBOutlet UILabel *nowPrice;
/**原价*/
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
/**几人付款*/
@property (weak, nonatomic) IBOutlet UILabel *paidPeopleCount;
/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@end


@implementation ServiceListTableViewCell

+ (instancetype)serviceListTableViewCellWithTableView:(UITableView *)tableView
{
    return [[NSBundle mainBundle]loadNibNamed:@"ServiceListTableViewCell" owner:nil options:nil].lastObject;
}

- (void)setModel:(ServiceListModel *)model
{
    _model = model;
    self.nameView.text = [NSString stringWithFormat:@"%@/%@",_model.title,_model.unit];
    [self.iconView sd_setImageWithURL:_model.imageURL placeholderImage:PlaceHolderImage_Other];
    self.oldPrice.text = [NSString stringWithFormat:@"原价¥%@",_model.oldprice];
    self.nowPrice.text = [NSString stringWithFormat:@"¥%@",_model.money];
    self.paidPeopleCount.text = [NSString stringWithFormat:@"%@人已付款",_model.sales];
}
@end
