//
//  WifeButlerHomeTableHeaderView.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/22.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTLunBoToModel.h"

@interface WifeButlerHomeTableHeaderView : UIView

+ (instancetype)WifeButlerHomeTableHeaderViewWithimageArray:(NSArray *)imageArray;

/**回调index*/
@property (nonatomic,copy)void(^returnBlock)(NSInteger index);

@property (nonatomic,copy)void(^topScrollViewClick)(ZTLunBoToModel * model);
/**URLStr数组*/
@property (nonatomic,strong) NSArray * bannerImageURLStrings;

@property (nonatomic,strong) NSArray * lunboModelArr;
@end


@interface WifeButlerHomeCircleButton : UIControl

- (instancetype)initWithImageName:(NSString *)imageName andtitle:(NSString *)title;

@end
