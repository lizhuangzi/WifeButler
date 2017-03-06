//
//  CustomCalendarViewController.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/24.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCalendarViewController : UIViewController
/**滑动回调*/
@property (nonatomic,copy)void((^swipCalenderBlock)(NSDate * currentDate));
/**选择日期回调*/
@property (nonatomic,copy)void((^selectDayblock)(NSDate * currentDate,NSInteger day));
/**显示红点的日期*/
@property (nonatomic,assign) NSUInteger currentRedday;

@end


@interface CustomredPointButton : UIButton

@property (nonatomic,assign) BOOL showRedPoint;

@property (nonatomic,assign) NSUInteger day;
@end
