//
//  ConfirmImageCollectionViewCell.m
//  docClient
//
//  Created by yms on 16/1/27.
//  Copyright © 2016年 luo. All rights reserved.
//

#import "ConfirmImageCollectionViewCell.h"

@interface ConfirmImageCollectionViewCell ()



@end

@implementation ConfirmImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        _imageView = imageView;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick)];
        
        UILongPressGestureRecognizer * pre = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressImage:)];
        pre.minimumPressDuration = 1.0;

        [imageView addGestureRecognizer:tap];
        [imageView addGestureRecognizer:pre];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

- (void)setImageURL:(NSString *)imageURL
{
    _imageURL = imageURL;
    NSString *encodeurl=[imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:encodeurl] placeholderImage:[UIImage imageNamed:@"talk_subject_picture"]];
    
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    if ([image isKindOfClass:[NSString class]])
    {
       self.imageView.image = [UIImage imageNamed:@"common_no_photo"];
    }else{
        self.imageView.image = image;
    }
}

- (void)imageClick
{
    //如果点击的是加号按钮
    if ([_image isKindOfClass:[NSString class]]) {
        
        if ([self.delegate respondsToSelector:@selector(ConfirmImageCollectionViewCelldidClickPlusBtn:)]) {
            [self.delegate ConfirmImageCollectionViewCelldidClickPlusBtn:self];
        }
    }else{//如果点击的是普通图片
    
    if ([self.delegate respondsToSelector:@selector(ConfirmImageCollectionViewCell:didClick:)]) {
        [self.delegate ConfirmImageCollectionViewCell:self didClick:self.imageView];
      }
    }
}

NSString * const ConfirmImageCollectionViewCellDeleteNotication = @"ConfirmImageCollectionViewCellDeleteNoti";

- (void)pressImage:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan){
    if (![_image isKindOfClass:[NSString class]]){
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ConfirmImageCollectionViewCellDeleteNoti" object:nil userInfo:@{@"deleteIndex":@(self.indexPath.item)}];
    }
    }
}

@end
