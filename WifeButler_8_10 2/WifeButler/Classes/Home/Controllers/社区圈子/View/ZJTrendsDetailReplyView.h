//
//  ZJThrendsDetailReplyView.h
//  weiCity
//
//  Created by 陈振奎 on 16/4/12.
//  Copyright © 2016年 Mr.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJTrendsCommentViewFrameModel.h"
#import "TYAttributedLabel.h"
typedef NS_ENUM(NSInteger,ZJThrendsDetailReplyViewButtonType){
    
    ZJThrendsDetailReplyViewButtonTypeIcon,
    ZJThrendsDetailReplyViewButtonTypeName,
    ZJThrendsDetailReplyViewButtonTypeReply
    
};


@class ZJTrendsDetailReplyView;

@protocol ZJThrendsDetailReplyViewDelegate <NSObject>

-(void)threndsDetailReplyView:(ZJTrendsDetailReplyView *)view subButtonClickedWithType:(ZJThrendsDetailReplyViewButtonType)buttonType;

//属性字符串点击代理
-(void)threndsDetailReplyView:(ZJTrendsDetailReplyView *)view textViewClickedWithData:(id)data;
@end



@interface ZJTrendsDetailReplyView : UIView


@property (nonatomic, strong) ZJTrendsCommentViewFrameModel *frameModel;

@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UIButton *name;
@property (nonatomic, weak) UILabel *time;
@property (nonatomic, weak) UIButton *replyBtn;
@property (nonatomic, weak) TYAttributedLabel *textView;

@property (nonatomic, weak) id<ZJThrendsDetailReplyViewDelegate> delegate;
@property (nonatomic, assign) ZJThrendsDetailReplyViewButtonType buttonType;
@end
