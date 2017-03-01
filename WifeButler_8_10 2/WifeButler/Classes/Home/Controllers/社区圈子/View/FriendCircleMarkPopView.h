//
//  FriendCircleMarkPopView.h
//  PatientClient
//
//  Created by GDXL2012 on 15/11/24.
//  Copyright © 2015年 ikuki. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 显示markView的方位：上,下,左,右
 */
typedef enum ShowMarkViewPosition{
    kShowMarkViewLeft,
    kShowMarkViewRight,
    kShowMarkViewBottom,
    kShowMarkViewTop
}ShowMarkViewPosition;

@class FriendCircleMarkPopView;
@protocol FriendCircleMarkPopViewDelegate <NSObject>

/**
 * 点击事件
 */
-(void)markPopView:(FriendCircleMarkPopView *)markView clickAtIndex:(NSInteger)index;

@end

@interface FriendCircleMarkPopView : UIView

@property(nonatomic, assign) id<FriendCircleMarkPopViewDelegate> delegate;

-(void)showMarkViewWithReference:(UIView *)view withPosition:(ShowMarkViewPosition)positionType offset:(CGFloat)offset;

/**
 * 只有标题，功能暂未实现
 */
-(void)setItemTitles:(NSArray *)titleArray;

/**
 * titleArray、icoArray均不能为空，切个数相等
 */
-(void)setItemTitles:(NSArray *)titleArray withIcos:(NSArray *)icoArray;

@end
