//
//  ZJTrendsListModel.h
//  WifeButler
//
//  Created by 陈振奎 on 16/6/13.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJTrendsListModel : NSObject
//"id":"1", 动态id
//                "topic_id":"0",
//                "uid":"4", 会员id
//                "content":"sadasda",内容
//                "gallery":"",
//                "time":"1464762852", 时间
//                "support_id":"",
//                "support_name":"",
//                "upid":"0",
//                "nickname":"111", 昵称
//                "avatar":"/public/images/avatar_default.png", 头像
//                "count":"0", 支持的人数
//                "some": "" xx，xxxxx等12人

//
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
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *some;
@property (nonatomic, copy) NSString *myup;


@end
