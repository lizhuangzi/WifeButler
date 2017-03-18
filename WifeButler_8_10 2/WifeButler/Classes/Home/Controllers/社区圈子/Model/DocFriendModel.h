//
//  DocFriendModel.h
//  docClient
//
//  Created by paopao on 16/8/11.
//  Copyright © 2016年 luo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DocFriendModel : NSObject<NSCoding>

@property (nonatomic,copy)NSString * avatar;
@property (nonatomic,strong)NSURL * iconFullPath;
@property (nonatomic,copy)NSString * id;
@property (nonatomic,copy)NSString * uid;
@property (nonatomic,copy)NSString * nickname;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,strong) NSArray * gallery;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * topic_id;
// 点赞列表
@property (nonatomic, strong) NSMutableArray *some;
// 评论列表 ->接收
@property (nonatomic, strong) NSMutableArray *discuss;
// 评论列表 ->使用
@property (nonatomic,strong) NSMutableArray * reviewArray;
// 点赞attributed
@property (nonatomic, copy) NSMutableAttributedString *praiseAttributed;

@property (nonatomic,copy)NSString * forwardPartyId;
@property (nonatomic,assign) BOOL isShowAll;
@property (nonatomic,assign) BOOL showAllBtnHidden;


// 点赞rangeArray
@property (nonatomic, strong) NSMutableArray *praiseRangeArray;

// cell个数
@property (nonatomic, assign) NSInteger cellCount;

+(DocFriendModel*)friendModelWithDict:(NSDictionary *)dict;

@end
