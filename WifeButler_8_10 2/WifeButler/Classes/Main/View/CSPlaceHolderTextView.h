//
//  CSPlaceHolderTextView.h
//  docClient
//
//  Created by GDXL2012 on 15/6/30.
//  Copyright (c) 2015年 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSPlaceHolderTextView;
@protocol CSPlaceHolderTextViewDelegate <NSObject>
@optional
- (void)textViewDidChange:(CSPlaceHolderTextView *)textView;

- (void)textViewDidBeginEditing:(CSPlaceHolderTextView *)textView;
/**
 * textView被键盘遮挡
 */
- (void)textViewWasCover:(CSPlaceHolderTextView *)textView withHeight:(float) height;

/**
 * 内容遮挡恢复 键盘隐藏
 */
- (void)textViewWasRecovery:(CSPlaceHolderTextView *)textView;

- (BOOL)textView:(CSPlaceHolderTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

@end

@interface CSPlaceHolderTextView : UIView

@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, strong) UIColor *placeHolderColor;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) UIColor *textColor;
@property (nonatomic, copy) UIFont *textFont;
@property (nonatomic, assign) NSInteger maxInputLength; // 最多输入字数 默认无限制
@property (nonatomic, assign) NSInteger maxHig; // 最大高度

@property (nonatomic, assign) enum UIKeyboardType keyboardType;

@property (nonatomic, assign) BOOL editable; // 设置是否可编辑

@property (nonatomic, assign) BOOL scrollEnabled; // 设置时候可以滚动

@property (nonatomic, weak) IBOutlet id<CSPlaceHolderTextViewDelegate> delegate;

+(float)getTextViewFitHeight:(NSString *)string fitSize:(CGSize)size withFont:(UIFont *)font;

/**
 * 获取text能全部显示的最小高度
 * 注：该方法需在view显示后调用，否者可能不能返回正确的高度
 */
-(float)getMinHeightForView;

// 回收键盘
-(void)textViewResignFirstResponder;

@end
