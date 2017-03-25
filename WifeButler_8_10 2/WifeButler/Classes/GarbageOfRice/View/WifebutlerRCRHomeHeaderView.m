//
//  WifebutlerRCRHomeHeaderView.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/24.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifebutlerRCRHomeHeaderView.h"
#import "exchangeStationModel.h"
@interface WifebutlerRCRHomeHeaderView ()

/**当前定位的小区名*/
@property (weak, nonatomic) IBOutlet UIButton *houseEstateName;

/**背景图片*/
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/**站点名*/
@property (weak, nonatomic) IBOutlet UILabel *mainNameLabel;
/**站点电话*/
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
/**站点区域*/
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

/**今日公告*/
@property (weak, nonatomic) IBOutlet UILabel *todayNotice;
@property (weak, nonatomic) IBOutlet UIView *noticeBackView;

@end

@implementation WifebutlerRCRHomeHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.noticeBackView.layer.opacity = 0.5;
    self.iconView.layer.cornerRadius = 30;
    self.iconView.clipsToBounds = YES;
    
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backImageView.clipsToBounds = YES;
}

+ (instancetype)headerView
{
    return [[NSBundle mainBundle]loadNibNamed:@"WifebutlerRCRHomeHeaderView" owner:nil options:nil].lastObject;
}

- (void)setModel:(exchangeStationModel *)model
{
    _model = model;
    self.backImageView.image = [UIImage imageNamed:@"timg"];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.shop_pic] placeholderImage:nil];
    self.mainNameLabel.text = model.shop_name;
    self.todayNotice.text = [NSString stringWithFormat:@"今日公告:%@",_model.gonggao];
}

- (IBAction)QRClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(WifebutlerRCRHomeHeaderViewdidClickQR:)]) {
        [self.delegate WifebutlerRCRHomeHeaderViewdidClickQR:self];
    }
}

@end
