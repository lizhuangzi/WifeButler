//
//  DocFriendReviewModel.h
//  docClient
//
//  Created by paopao on 16/8/11.
//  Copyright © 2016年 luo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocFriendReviewModel : NSObject<NSCoding>
// 评论人名称
@property (nonatomic, copy) NSString *nickname;
// 评论Id
@property (nonatomic, copy) NSString *id;

/**评论人id*/
@property (nonatomic,copy)NSString * uid;

@property (nonatomic,copy)NSString * topic_id;
@property (nonatomic,copy)NSString * avatar;
@property (nonatomic,copy)NSString * level;
@property (nonatomic,strong) NSArray * child;

// 评论内容
@property (nonatomic, copy) NSString *content;
// 是否是回复别人
@property (nonatomic, assign) BOOL isReviewOther;
// 被回复人名称
@property (nonatomic, copy) NSString *argued_name;

// 被回复人Id
@property (nonatomic, copy) NSString *argued_id;

// 时间
@property (nonatomic, copy) NSString *createdStamp;
// attributed
@property (nonatomic, copy) NSMutableAttributedString *contentAttributed;
// 名称range
@property (nonatomic, strong) NSMutableArray *rangeArray;


+(DocFriendReviewModel *)reviewModelWithDic:(NSDictionary *)dict;

@end
