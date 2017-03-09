//
//  PhotosScrollView.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/8.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosScrollView : UIView

@property (nonatomic,strong) NSArray * imageUrlStrings;

@property (nonatomic,copy)void(^tapImageBlock)(NSUInteger curentIndex,NSArray * allImageUrlStrs);
@end


@interface PhotosCollectionCell : UICollectionViewCell

@property (nonatomic,weak) UIImageView * imageView;


@end
