//
//  DocFriendModel.h
//  docClient
//
//  Created by paopao on 16/8/11.
//  Copyright © 2016年 luo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DocFriendHeaderModel.h"

@interface DocFriendModel : NSObject<NSCoding>
// 头部数据
@property (nonatomic, strong) DocFriendHeaderModel *headerModel;
// 点赞列表
@property (nonatomic, strong) NSMutableArray *praiseArray;
// 点赞attributed
@property (nonatomic, copy) NSMutableAttributedString *praiseAttributed;
// 点赞rangeArray
@property (nonatomic, strong) NSMutableArray *praiseRangeArray;
// 评论列表
@property (nonatomic, strong) NSMutableArray *reviewArray;
// cell个数
@property (nonatomic, assign) NSInteger cellCount;

+(DocFriendModel*)friendModelWithDict:(NSDictionary *)dict;

@end
