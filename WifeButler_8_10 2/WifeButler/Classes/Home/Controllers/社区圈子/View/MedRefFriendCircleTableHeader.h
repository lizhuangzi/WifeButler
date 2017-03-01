//
//  HealthCircleTableHeaderView.h
//  PatientClient
//
//  Created by GDXL2012 on 15/11/23.
//  Copyright © 2015年 ikuki. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MedRefFriendCircleTableHeaderIdentifier @"MedRefFriendCircleTableHeaderIdentifier"

typedef enum HeaderClickType{
    kHeaderClick,
    kHeaderClickAuthor,
    kHeaderClickForwardId
}HeaderClickType;

@class MedRefFriendCircleTableHeader, DocFriendHeaderModel;
@protocol MedRefFriendCircleTableHeaderDelegate <NSObject>
@optional

// 作者头像点击
-(void)tableHeaderView:(MedRefFriendCircleTableHeader *)headerView authorClickAtSection:(NSInteger)section;

// 转发对象名称点击
-(void)tableHeaderView:(MedRefFriendCircleTableHeader *)headerView forwardNameClickAtSection:(NSInteger)section;

// 文章、项目、会议，课件详情点击
-(void)tableHeaderView:(MedRefFriendCircleTableHeader *)headerView itemClickAtSection:(NSInteger)section;

// 点赞按钮点击，view：点击触发view
-(void)tableHeaderView:(MedRefFriendCircleTableHeader *)headerView markClickAtSection:(NSInteger)section withClickView:(UIView *)view;

// 删除按钮点击
-(void)tableHeaderView:(MedRefFriendCircleTableHeader *)headerView delectClickAtSection:(NSInteger)section;

// 全文按钮点击
-(void)tableHeaderView:(MedRefFriendCircleTableHeader *)headerView showAllClickAtSection:(NSInteger)section;

// 进入个人相册页面事件
-(void)tableHeaderView:(MedRefFriendCircleTableHeader *)headerView pushPhotoAlbumWithPartyId:(NSString *)partyId;

@end

@interface MedRefFriendCircleTableHeader : UITableViewHeaderFooterView

@property (nonatomic, assign) id<MedRefFriendCircleTableHeaderDelegate> delegate;
@property (nonatomic, assign) NSInteger currentSection;
// 点击全文
@property (nonatomic, copy) void (^showAllBtnClick)();
// 收藏
@property (nonatomic, copy) void (^didCollectionItemClick)(NSString *collectionType,NSString *collectionImgUrl,DocFriendHeaderModel *model);
// 投诉
@property (nonatomic, copy) void (^didReportItemClick)(DocFriendHeaderModel *model);
// 转发
@property (nonatomic, copy) void (^didForwardItemClick)(NSString *forwordType,DocFriendHeaderModel *model);


/**
 * 获取view高度
 */
+(CGFloat) getHeadSectionHeadHeight:(DocFriendHeaderModel *) model;

/**
 * 设置显示数据
 *  @param model
 */
-(void) setWorkmodel:(DocFriendHeaderModel *) model atSection:(NSInteger) section;

@end
