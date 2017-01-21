//
//  ZJCommentModel.h
//  WifeButler
//
//  Created by 陈振奎 on 16/6/13.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJCommentModel : NSObject

//            "id":"3", // 评论id
//            "uid":"4", // 用户id
//            "topic_id":"1", // 原帖id
//            "content":"sadasda", // 内容
//            "time":"1464763279", // 时间
//            "upid":"1", // 被评论者id
//            "nickname":"user_170", // 昵称
//            "level":"1", // 评论等级
//            "avatar":"/public/images/avatar_default.png", //头像
//            "argued_name":"", // 被评论人名
//            "argued_id":"1", // 被评论的动态id
//            "child":[
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *topic_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *upid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *argued_name;
@property (nonatomic, copy) NSString *argued_id;

@property (nonatomic, strong) NSArray *child;

@end
