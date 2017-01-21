//
//  ZJThrendsCommentViewFrameModel.h
//  WifeButler
//
//  Created by 陈振奎 on 16/6/14.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJCommentModel.h"
@interface ZJTrendsCommentViewFrameModel : NSObject
@property (nonatomic, strong) ZJCommentModel *model;

@property (nonatomic, assign,readonly) CGRect iconF;
@property (nonatomic, assign,readonly) CGRect nameF;
@property (nonatomic, assign,readonly) CGRect timeF;
@property (nonatomic, assign,readonly) CGRect replyBtnF;

@property (nonatomic, assign,readonly) CGRect textViewF;

@property (nonatomic, strong) NSMutableArray *revertFs;


@property (nonatomic, assign,readonly) CGFloat viewH;
@end
