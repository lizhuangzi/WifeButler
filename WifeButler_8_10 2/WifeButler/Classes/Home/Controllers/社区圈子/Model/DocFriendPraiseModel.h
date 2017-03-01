//
//  DocFriendPraiseModel.h
//  docClient
//
//  Created by paopao on 16/8/11.
//  Copyright © 2016年 luo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocFriendPraiseModel : NSObject<NSCoding>
// 点赞人头像
@property(nonatomic,copy)NSString * partyheadUrl;
// 点赞人名称
@property(nonatomic,copy)NSString * partyName;
// 点赞人Id
@property(nonatomic,copy)NSString * partyId;
// 点赞id
@property(nonatomic,copy)NSString *caseHisTopRevId;

@end
