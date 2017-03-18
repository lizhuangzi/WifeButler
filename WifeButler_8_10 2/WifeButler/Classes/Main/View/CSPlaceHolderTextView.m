//
//  CSPlaceHolderTextView.m
//  docClient
//
//  Created by GDXL2012 on 15/6/30.
//  Copyright (c) 2015年 GDXL2012. All rights reserved.
//

#import "CSPlaceHolderTextView.h"
#import "Masonry.h"


@interface CSPlaceHolderTextView()<UITextViewDelegate>{
    UITextView *textView;
    UITextView *placeHolderTextView;
    float contentHeight;  // 内容高度
    BOOL needRecovery;
    CGRect keyBordRect; 
    UITextView *tempTextView;
    NSString *inputText;
}

@end

@implementation CSPlaceHolderTextView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

-(void) initView{
    needRecovery = NO;
    placeHolderTextView = [[UITextView alloc] init];
    placeHolderTextView.backgroundColor = [UIColor clearColor];
    placeHolderTextView.textColor = [UIColor lightGrayColor];
    placeHolderTextView.font = [UIFont systemFontOfSize:16.0f];
    placeHolderTextView.userInteractionEnabled = NO;
    placeHolderTextView.scrollEnabled = NO;
    placeHolderTextView.delegate = self;
    [self addSubview:placeHolderTextView];
    
    textView = [[UITextView alloc] init];
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.delegate = self;
    textView.scrollEnabled = NO;
    textView.returnKeyType = UIReturnKeyDone;
    textView.layoutManager.allowsNonContiguousLayout = NO;

    [self addSubview:textView];
    
    tempTextView = [[UITextView alloc] init];
    tempTextView.font = [UIFont systemFontOfSize:16.0f];
    tempTextView.scrollEnabled = NO;
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [placeHolderTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)registerNotification{
//    [NotificationUtil registerNotification:UIKeyboardDidShowNotification observer:self selector:@selector(keyboardWasShown:)];
//    [NotificationUtil registerNotification:UIKeyboardDidHideNotification observer:self selector:@selector(keyboardWasHidden:)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)unRegisterNotification{
//    [NotificationUtil unRegisterNotification:UIKeyboardDidShowNotification observer:self];
//    [NotificationUtil unRegisterNotification:UIKeyboardDidHideNotification observer:self];
}

#pragma mark - 键盘相关处理
-(void)keyboardWasShown:(NSNotification *) notification{
    if ([textView isFirstResponder]) {
        NSDictionary* info = [notification userInfo];
        CGRect kbFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];//键盘位置的高度
        if (kbFrame.size.height > 0) {
            keyBordRect = kbFrame;

            NSString *rect = NSStringFromCGRect(kbFrame);
            [[NSUserDefaults standardUserDefaults] setObject:rect forKey:@"keyBordRect"];
            [self textViewWasCover:kbFrame];
        }
    }
}

-(void)textViewWasCover:(CGRect)kbFrame
{
    CGRect rect = [self convertRect:textView.frame toView:[[[UIApplication sharedApplication] delegate] window]];
    float cellBottomLine = rect.origin.y + rect.size.height;
    float keyBordOriginY = kbFrame.origin.y;
    float datHeight = cellBottomLine - keyBordOriginY;
    if (datHeight > 0) { // cell 被遮挡
        needRecovery = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(textViewWasCover:withHeight:)]) {
            [self.delegate textViewWasCover:self withHeight:datHeight];
        }
    }
}

-(void)keyboardWasHidden:(NSNotification *) notification{
    if (needRecovery) {
        needRecovery = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(textViewWasRecovery:)]) {
            [self.delegate textViewWasRecovery:self];
        }
    }
}

-(void)setKeyboardType:(enum UIKeyboardType)keyboardType{
    textView.keyboardType = keyboardType;
}

-(void)setEditable:(BOOL)editable{
    textView.editable = editable;
    textView.userInteractionEnabled = editable;
}

-(void)setScrollEnabled:(BOOL)scrollEnabled
{
    textView.scrollEnabled = scrollEnabled;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self registerNotification];
    if (keyBordRect.size.height) {
        [self textViewWasCover:keyBordRect];
    }else{
        keyBordRect = CGRectFromString([[NSUserDefaults standardUserDefaults] objectForKey:@"keyBordRect"]);
        if (keyBordRect.size.height) {
            [self textViewWasCover:keyBordRect];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.delegate textViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self unRegisterNotification];
    if (needRecovery) {
        needRecovery = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(textViewWasRecovery:)]) {
            [self.delegate textViewWasRecovery:self];
        }
    }
}

- (void)textViewDidChange:(UITextView *)tv{
    if (tv == textView ) {
        if (tv.text.length > 0) {
            if (self.maxInputLength && tv.text.length > self.maxInputLength) {
                tv.text = inputText;
//                DocBaseViewController *topVC = (DocBaseViewController *)[CommonUtils topViewController];
//                [topVC showNotifitationString:[NSString stringWithFormat:@"最多输入%ld个字",(long)self.maxInputLength]];
                return;
            }
            placeHolderTextView.hidden = YES;
        } else {
            placeHolderTextView.hidden = NO;
        }
    }
    CGFloat textHig = [self getMinHeightForView];
    textView.scrollEnabled = self.scrollEnabled;
    if (self.maxHig > 0 && textHig > self.maxHig) {
        textView.scrollEnabled = YES;
    }
    if (keyBordRect.size.height > 0) {
        [self textViewWasCover:keyBordRect];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
    inputText = tv.text;
}

- (BOOL)textView:(UITextView *)tv shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate textView:self shouldChangeTextInRange:range replacementText:text];
    }
    if([@"\n" isEqualToString:text]){
        [tv resignFirstResponder];
        return NO;
    }
    return YES;
}

+(float)getTextViewFitHeight:(NSString *)string fitSize:(CGSize)size withFont:(UIFont *)font{
    UITextView *textView = [[UITextView alloc] init];
    textView.font = font;
    textView.text = string;
    CGSize fitSize = [textView sizeThatFits:size];
    return fitSize.height;
}

/**
 * 获取text能全部显示的最小高度
 * 注：该方法需在view显示后调用，否者可能不能返回正确的高度
 */
-(float)getMinHeightForView{
    NSString *inputString = textView.text;
    if (inputString.length == 0) {
        return 0;
    } else {
        tempTextView.text = inputString;
        CGSize size = [tempTextView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
        return size.height + 1;
    }
}

-(void)setPlaceHolder:(NSString *)placeHolder{
    placeHolderTextView.text = placeHolder;
}

-(void)setPlaceHolderColor:(UIColor *)placeHolderColor{
    placeHolderTextView.textColor = placeHolderColor;
}

-(void)setText:(NSString *)text{
    if (text.length == 0) {
        textView.text = @"";
        placeHolderTextView.hidden = NO;
    } else {
        textView.text = text;
        placeHolderTextView.hidden = YES;
    }
}

-(NSString *)text{
    return textView.text;
}

-(void)setTextColor:(UIColor *)textColor{
    textView.textColor = textColor;
}

-(UIColor *)textColor{
    return textView.textColor;
}

-(void)setTextFont:(UIFont *)textFont{
    placeHolderTextView.font = textFont;
    textView.font = textFont;
    tempTextView.font = textFont;
}

-(UIFont *)textFont{
    return textView.font;
}

-(void)textViewResignFirstResponder
{
    [textView resignFirstResponder];
}

@end
