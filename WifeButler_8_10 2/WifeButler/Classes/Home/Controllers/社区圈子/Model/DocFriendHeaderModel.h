//
//  DocFriendHeaderModel.h
//  docClient
//
//  Created by paopao on 16/8/11.
//  Copyright © 2016年 luo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocFriendHeaderModel : NSObject<NSCoding>


// 发表说说人名称
@property (nonatomic, copy) NSString *caseHisTopName;
// 发表说说人头像
@property (nonatomic, copy) NSString *caseHisTopHeadurl;
// 发表说说人Id
@property (nonatomic, copy) NSString *partyId;
// 关注类型：bothWayConcern, 单向关注：oneWayConcern，好友：friend
@property (nonatomic, copy) NSString *relation;
// 转发对象id
@property (nonatomic, copy) NSString *forwardPartyId;
// 转发对象名称
@property (nonatomic, copy) NSString *forwardPartyName;

@property (nonatomic, copy) NSString *chtTypeEnum;
//发表类型
@property (nonatomic, copy) NSString *chtTypeEnumFK;
// 描述
@property (nonatomic, copy) NSString *content;
// 是否显示全文
@property (assign ,nonatomic) BOOL isShowAll;
// 全文按钮是否显示
@property (assign ,nonatomic) BOOL showAllBtnHidden;
// 图片地址
@property (nonatomic, copy) NSString *imagesPath;
// 文章名字
@property (nonatomic, copy) NSString *articleTitle;
// 文章原作者头像url
@property (nonatomic, copy) NSString *articleAuthorIcon;
// 文章等作者id
@property (nonatomic, copy) NSString *articleAuthorId;
// 时间
@property (nonatomic, copy) NSString *createdStamp;
// 患者Id
@property (nonatomic, copy) NSString *patientId;
// 话题Id
@property (nonatomic, copy) NSString *caseHisTopId;


@end
