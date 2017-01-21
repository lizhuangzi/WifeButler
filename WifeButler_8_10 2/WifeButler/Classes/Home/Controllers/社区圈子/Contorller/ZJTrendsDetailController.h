//
//  ZJTrendsDetailController.h
//  WifeButler
//
//  Created by 陈振奎 on 16/6/13.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^commendBlock)(BOOL commend);

typedef void (^commentBlock)(NSArray *comments);

@interface ZJTrendsDetailController : UIViewController

@property (nonatomic, copy) NSString *did;//动态 id即可
@property (nonatomic, copy) commendBlock block;
@property (nonatomic, copy) commentBlock commentBlock;

-(void)commendFinished:(commendBlock)action;

-(void)commentFinished:(commentBlock)action;

@property (nonatomic, copy) void (^shuaiXinBlack)(void);


@end
