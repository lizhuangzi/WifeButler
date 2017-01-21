//
//  UIImageView+Del.h
//  ConstructionSite
//
//  Created by zjtdmac2 on 15/7/29.
//  Copyright (c) 2015年 zjtdmac2. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UIImageViewDelDelegate <NSObject>
-(void)imageViewDel:(UIImageView *)imageView;
@end

@interface UIImageView (Del)

@property(nonatomic,weak)id<UIImageViewDelDelegate>delDelegate;

-(instancetype)initDelWithFrame:(CGRect)frame;

@end
