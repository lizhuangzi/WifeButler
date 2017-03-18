//
//  ConfirmImageCollectionViewCell.h
//  docClient
//
//  Created by yms on 16/1/27.
//  Copyright © 2016年 luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConfirmImageCollectionViewCell;

@protocol ConfirmImageCollectionViewCellImageClickDelegate <NSObject>

@optional
/**点击图片放大*/
- (void)ConfirmImageCollectionViewCell:(ConfirmImageCollectionViewCell *)cell didClick:(UIImageView *)currentImage;
/**点击加号按钮*/
- (void)ConfirmImageCollectionViewCelldidClickPlusBtn:(ConfirmImageCollectionViewCell *)cell;
@end

/**自定义collectioncell*/
@interface ConfirmImageCollectionViewCell : UICollectionViewCell

@property (nonatomic,weak,readonly)UIImageView *imageView;

@property (nonatomic,assign)id <ConfirmImageCollectionViewCellImageClickDelegate> delegate;

@property (nonatomic,copy)NSString * imageURL;
@property (nonatomic,strong)UIImage * image;


@property (nonatomic,strong)NSIndexPath * indexPath;

UIKIT_EXTERN NSString * const ConfirmImageCollectionViewCellDeleteNotication;

@end

