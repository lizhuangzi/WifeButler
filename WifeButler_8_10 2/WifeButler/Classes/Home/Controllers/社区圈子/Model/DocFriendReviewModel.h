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
@property (nonatomic, copy) NSString *partyName;
// 评论人Id
@property (nonatomic, copy) NSString *partyId;
// 评论人头像
@property (nonatomic,copy)  NSString * partyheadUrl;
// 这条评论的Id
@property (nonatomic, copy) NSString *caseHisTopRevId;
// 评论内容
@property (nonatomic, copy) NSString *content;
// 是否是回复别人
@property (nonatomic, assign) BOOL isReviewOther;
// 被回复人名称
@property (nonatomic, copy) NSString *replyName;
// 被回复人头像
@property (nonatomic, copy) NSString *replyHeadurl;
// 被回复人Id
@property (nonatomic, copy) NSString *replyId;
// 被回复的那条评论的Id  有被回复人就有此Id
@property (nonatomic, copy) NSString *replyTopRevId;
// 时间
@property (nonatomic, copy) NSString *createdStamp;
// attributed
@property (nonatomic, copy) NSMutableAttributedString *contentAttributed;
// 名称range
@property (nonatomic, strong) NSMutableArray *rangeArray;


+(DocFriendReviewModel *)reviewModelWithDic:(NSDictionary *)dict;

@end
