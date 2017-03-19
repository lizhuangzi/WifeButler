//
//  MyDonateTableViewCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "MyDonateTableViewCell.h"
#import "MyDonateUserlistModel.h"

@interface MyDonateTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *DimageView;
@property (weak, nonatomic) IBOutlet UILabel *Dtitle;
@property (weak, nonatomic) IBOutlet UILabel *DhaveDonated;
@property (weak, nonatomic) IBOutlet UILabel *DloveHeart;
@property (weak, nonatomic) IBOutlet UILabel *DAllLoveHeart;

@end

@implementation MyDonateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MyDonateUserlistModel *)model
{
    _model = model;
    [self.DimageView sd_setImageWithURL:_model.imageURL placeholderImage:PlaceHolderImage_Other];
    self.Dtitle.text = _model.title;
    self.DhaveDonated.text = [NSString stringWithFormat:@"已捐款金额%@元",@"0.01"];
    self.DloveHeart.text = [NSString stringWithFormat:@"已奉献%@份爱心",_model.count];
    self.DAllLoveHeart.text = [NSString stringWithFormat:@"共%@份爱心",@"3"];
}

- (IBAction)juankuan:(id)sender {
    
    if (self.juankuanblock) {
        self.juankuanblock(self.model);
    }
    
}
@end
