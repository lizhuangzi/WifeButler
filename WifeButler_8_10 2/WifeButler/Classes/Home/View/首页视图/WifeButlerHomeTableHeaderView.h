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

/**回调index*/
@property (nonatomic,copy)void(^returnBlock)(NSInteger index);
/**URLStr数组*/
@property (nonatomic,strong) NSArray * bannerImageURLStrings;
@end


@interface WifeButlerHomeCircleButton : UIControl

- (instancetype)initWithImageName:(NSString *)imageName andtitle:(NSString *)title;

@end
