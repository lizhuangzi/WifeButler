//
//  CommentView.h
//  Test
//
//  Created by common on 15/4/5.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^SendCommentBlock)(NSString *content);

@interface CommentView : UIView

@property (nonatomic, assign) BOOL receiveEmpty; // 是否接收空字符,默认为NO

@property (nonatomic, assign) NSInteger maxLength; // 最多输入字数  默认无限制

+(instancetype)showView;

-(void)setInputText:(NSString *)text;
-(void)setPlaceHolder:(NSString *)placeHolder;

-(void)showWithSendCommentBlock:(SendCommentBlock)block;

- (void)dismiss;

@end
