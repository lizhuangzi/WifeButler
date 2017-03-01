//
//  RightBarMorePopView.h
//  docClient
//
//  Created by GDXL2012 on 15/11/18.
//  Copyright © 2015年 luo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum MenuPopViewImgType{
    kMenuPopViewImgBlack,   // 黑色背景
    kMenuPopViewImgWhite,   // 白色背景
    kMenuPopViewImgCustom   // 自定义背景
}MenuPopViewImgType;

@class RightBarMorePopView;
@protocol RightBarMorePopViewDelegate <NSObject>
@optional
/**
 * 用户点击项下标
 */
-(void)morePopView:(RightBarMorePopView *)popView clickAtIndex:(NSInteger)index;

@end

/**
 * 右侧更多按钮点击弹出菜单列表view
 */
@interface RightBarMorePopView : UIView
@property (nonatomic, assign) id<RightBarMorePopViewDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isPopViewShow;

+(instancetype)morePopViewWithType:(MenuPopViewImgType)type titleArray:(NSArray*)titls imgArray:(NSArray *)imgs;

+(instancetype)morePopViewWithType:(MenuPopViewImgType)type titleArray:(NSArray*)titls imgArray:(NSArray *)imgs width:(CGFloat)width;

-(void)show;
-(void)dismissVeiw;



/**
 * 设置菜单选项背景及内容偏移值
 */
-(void)setBgImage:(UIImage *)imge withContenOffSet:(UIEdgeInsets)insets;
/**
 * 设置文本颜色
 */
-(void)setTitleColor:(UIColor *)color;
@end

@interface SingleTitlePopCell : UITableViewCell

@property (nonatomic, strong) UILabel *singleLabel;

@end

@interface ImageTitlePopCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *leftImageView;
@end

@interface RightBarMorePopView (RedView)

- (void)showRediViewAtIndex:(NSUInteger)index;

- (void)hideRedViewAtIndex:(NSUInteger)index;

@end
