//
//  WifeButlerHomeTableHeaderView.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/22.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WifeButlerHomeTableHeaderView : UIView

+ (instancetype)WifeButlerHomeTableHeaderViewWithimageArray:(NSArray *)imageArray;

@property (nonatomic,strong) NSArray * bannerImageURLStrings;
@end


@interface WifeButlerHomeCircleButton : UIControl

- (instancetype)initWithImageName:(NSString *)imageName andtitle:(NSString *)title;

@end
