//
//  ZJTrendsModel.h
//  WifeButler
//
//  Created by 陈振奎 on 16/6/13.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJTrendsModel : NSObject
//             "id":"1", // 动态id
//            "topic_id":"0",
//            "uid":"4", 会员id
//            "content":"sadasda", 内容
//            "gallery":"", 图片以逗号分割的
//            "time":"1464762852", 时间
//            "support_id":"",
//            "support_name":"",
//            "upid":"0",
//            "nickname":"111", 昵称
//            "avatar":"/public/images/avatar_default.png" 头像
// "argued_name":"",
//            "level":"0",
//            "argued_id":"0"
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *topic_id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *gallery;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *support_id;
@property (nonatomic, copy) NSString *support_name;
@property (nonatomic, copy) NSString *upid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *argued_name;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *argued_id;
@end
