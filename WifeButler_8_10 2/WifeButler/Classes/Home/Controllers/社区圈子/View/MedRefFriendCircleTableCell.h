//
//  MedRefFriendCircleTableCell.h
//  PatientClient
//
//  Created by GDXL2012 on 15/11/24.
//  Copyright © 2015年 ikuki. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DocFriendReviewModel,DocFriendModel;
@interface MedRefFriendCircleTableCell : UITableViewCell

// 点击人名称
@property (nonatomic, copy) void (^didNameClick)(NSString *partyId);

// 点击评论
@property (nonatomic, copy) void (^didCommentClick)();

// 删除
@property (nonatomic, copy) void (^didDeleteItemClick)();

// 收藏
@property (nonatomic, copy) void (^didCollectionItemClick)(DocFriendReviewModel * model);

// 投诉
@property (nonatomic, copy) void (^didReportItemClick)(DocFriendReviewModel * model);

/**
 * 初始化一个空的cell
 */
-(id) initEmptyCellView:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
/**
 * 获取回复内容view高度
 */
+(NSInteger) getHeadSectionRowHeightWithModel:(DocFriendReviewModel *) personInfoModel atIndexPath:(NSIndexPath *)indexPath;

/**
 *  获取点赞内容view高度
 */
+(NSInteger)getHeadSectionRowHeightWithPraiseArray:(DocFriendModel *)model;

/**
 * 设置分割线隐藏
 */
-(void) setSeparatorLineViewHidden:(BOOL)hidden;

/**
 * 设置点赞列表
 */
-(void) setPraiseArray:(DocFriendModel *)model atIndexPath:(NSIndexPath *)indexPath;

/**
 * 设置回复消息
 */
-(void) setReviseModel:(DocFriendReviewModel *) personInfoModel atIndexPath:(NSIndexPath *)indexPath;


@end
