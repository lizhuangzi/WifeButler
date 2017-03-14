//
//  LoveDonateListTableViewCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/14.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "LoveDonateListTableViewCell.h"
#import "LoveDonateListModel.h"

@interface LoveDonateListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *LImageView;

@property (weak, nonatomic) IBOutlet UILabel *LTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *LDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *LCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *LTargetLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *processView;
@property (weak, nonatomic) IBOutlet UILabel *processNumLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countLabelTopCos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelToImageTopCos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopCos;

@end

@implementation LoveDonateListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.LDetailLabel.preferredMaxLayoutWidth = iphoneWidth - 108 - 15;
}

- (void)setModel:(LoveDonateListModel *)model
{
    _model = model;
    [self.LImageView sd_setImageWithURL:_model.imageURL placeholderImage:PlaceHolderImage_Other];
    self.LTitleLabel.text = _model.title;
    self.LDetailLabel.text = _model.brief;
    self.LCountLabel.text = [NSString stringWithFormat:@"共%@份爱心",_model.count];
//    self.LTargetLabel.text = [NSString stringWithFormat:@"目标%@元",]
    if ([_model.percent isEqualToString:@"无上限"]) {
        
        _processView.hidden = YES;
        _processNumLabel.hidden = YES;
        self.LTargetLabel.hidden = YES;
        self.countLabelTopCos.constant = 10;
        self.titleLabelToImageTopCos.constant = 0;
        self.imageTopCos.constant = 10;
        [self layoutIfNeeded];
        _model.cellH = CGRectGetMaxY(_LCountLabel.frame)+ 20;
    }else{
       _processView.hidden = NO;
       _processNumLabel.hidden = NO;
        self.LTargetLabel.hidden = NO;
        
       [_processView setProgress:_model.percent.floatValue/100];
       _processNumLabel.text = [NSString stringWithFormat:@"%@%%",_model.percent];
        
        self.countLabelTopCos.constant = 24;
        self.titleLabelToImageTopCos.constant = -10;
        self.imageTopCos.constant = 20;
        [self layoutIfNeeded];
        _model.cellH = CGRectGetMaxY(_LCountLabel.frame) + 10;
    }
    
  
    
   
}
@end
