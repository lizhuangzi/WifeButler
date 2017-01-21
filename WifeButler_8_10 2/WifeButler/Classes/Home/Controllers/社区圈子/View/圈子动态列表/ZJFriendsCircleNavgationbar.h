//
//  ZJFriendsCircleNavgationbar.h
//  weiCity
//
//  Created by 陈振奎 on 16/3/22.
//  Copyright © 2016年 Mr.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJFriendsCircleNavgationbar;
@protocol ZJFriendsCircleNavgationbarDelegate <NSObject>

-(void)friendsCircleNavgationbar:(ZJFriendsCircleNavgationbar *)navigationBar btnClicked:(NSInteger)btnTag;

@end
@interface ZJFriendsCircleNavgationbar : UIView
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (nonatomic, weak) id<ZJFriendsCircleNavgationbarDelegate> delegate;
@end
