//
//  LoveDonateListModel.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/14.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerCommonBaseModel.h"

@interface LoveDonateListModel : WifeButlerCommonBaseModel
/**图片*/
@property (nonatomic,copy)NSString * banner;

/**标题*/
@property (nonatomic,copy)NSString * title;
/**简介*/
@property (nonatomic,copy)NSString * brief;
/**捐款人数*/
@property (nonatomic,copy)NSString * count;
/**捐款进度*/
@property (nonatomic,copy)NSString * percent;

@property (nonatomic,assign) CGFloat cellH;
@end
