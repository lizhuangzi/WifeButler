//
//  CommentView.m
//  Test
//
//  Created by common on 15/4/5.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "CommentView.h"
#import "Masonry.h"
#import "CommonEmojiKeyBoardView.h"
#import "WifeButlerDefine.h"

@interface CommentView () <UITextViewDelegate> {
    
}

@property (strong, nonatomic) UIView *bottomView;
@property (copy, nonatomic) SendCommentBlock sendCommentBlock;
@property (strong, nonatomic) UITextView *inputTextView;
@property (strong, nonatomic) UITextView *placeHolderTextView;
@property (strong, nonatomic) CommonEmojiKeyBoardView *keyBoardView;
@property (strong, nonatomic) UIButton *sendButton;

// 正在输入的内容
@property (nonatomic, copy) NSString *inputContent;
@property (assign, nonatomic) CGFloat keyBoardHig;

@end

@implementation CommentView

static CGFloat inputFont = 15.0;

static CGFloat maxHeight = 108.0f;

static CGFloat defaultHig = 45;

static CGFloat textViewHig = 30;

+(instancetype)showView
{
    CommentView *view = [[CommentView alloc] init];
    return view;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initContentView];
        [self registerNotifications];
    }
    return  self;
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [self unRegisterNotifications];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
}

- (void)initContentView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, iphoneWidth - defaultHig, iphoneWidth, defaultHig)];
    [self addSubview:self.bottomView];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setBackgroundColor:[UIColor clearColor]];
    [self.sendButton addTarget:self action:@selector(clickSendCommentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"chatBar_face1"] forState:UIControlStateNormal];
    [self.bottomView addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right).offset(-15);
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.width.offset(textViewHig);
        make.height.offset(textViewHig);
    }];
    
    // 添加回复输入框
    self.inputTextView = [[UITextView alloc] init];
    self.inputTextView.showsHorizontalScrollIndicator = NO;
    self.inputTextView.scrollEnabled = NO;
    self.inputTextView.returnKeyType = UIReturnKeySend; //just as an example
    self.inputTextView.delegate = self;
    self.inputTextView.backgroundColor = [UIColor whiteColor];
    self.inputTextView.font = [UIFont systemFontOfSize:systembigfont];
    self.inputTextView.layer.borderWidth = 0.5;
    self.inputTextView.layer.borderColor = WifeButlerSeparateLineColor.CGColor;
    self.inputTextView.layer.cornerRadius = 5;
    self.inputTextView.layer.masksToBounds = YES;
    [self.bottomView addSubview:self.inputTextView];
    
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomView.mas_left).offset(tableViewEdgeInsetsLeft);
        make.right.mas_equalTo(self.sendButton.mas_left).offset(-12.0f);
        make.top.mas_equalTo(self.bottomView.mas_top).offset(7.5);
        make.bottom.mas_equalTo(self.bottomView.mas_bottom).offset(-7.5);
    }];
    
    self.placeHolderTextView = [[UITextView alloc] init];
    self.placeHolderTextView.userInteractionEnabled = NO;
    self.placeHolderTextView.editable = NO;
    self.placeHolderTextView.selectable = NO;
    self.placeHolderTextView.textColor = WifeButlerGaryTextColor1;
    self.placeHolderTextView.text = @"请输入内容...";
    self.placeHolderTextView.font = [UIFont systemFontOfSize:inputFont];
    self.placeHolderTextView.backgroundColor = [UIColor clearColor];
    [self.bottomView addSubview:self.placeHolderTextView];
    [self.placeHolderTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.inputTextView);
    }];
}
// 表情键盘
-(CommonEmojiKeyBoardView *)keyBoardView
{
    if (_keyBoardView == nil) {
        _keyBoardView = [[CommonEmojiKeyBoardView alloc] initWithFrame:CGRectMake(0, 0, iphoneWidth, 225)];
        [self keyBoardViewBlocks];
    }
    return _keyBoardView;
}
// 表情键盘和系统键盘切换
-(void)clickSendCommentButtonClick:(UIButton *)button{
    if (button.selected) {
        self.inputTextView.inputView = nil;
        [button setBackgroundImage:[UIImage imageNamed:@"chatBar_face1"] forState:UIControlStateNormal];
    }else{
        self.inputTextView.inputView = self.keyBoardView;
        [button setBackgroundImage:[UIImage imageNamed:@"chatBar_keyboard1"] forState:UIControlStateNormal];
    }
    [self.inputTextView reloadInputViews];
    button.selected = !button.selected;
}
// 表情键盘回调事件
-(void)keyBoardViewBlocks
{
    WEAKSELF
    // 点击删除
    [self.keyBoardView setDidDeleteClick:^{
        [weakSelf.inputTextView deleteBackward];
    }];
    // 点击表情
    [self.keyBoardView setDidEmojiClick:^(NSString *emojiStr) {
        [weakSelf.inputTextView insertText:emojiStr];
    }];
    // 点击发送
    [self.keyBoardView setDidSendClick:^{
        [weakSelf sendClick];
    }];
}


- (void)setInputText:(NSString *)text {
    self.inputTextView.text = text;
    if (text.length == 0) {
        self.placeHolderTextView.hidden = NO;
    } else {
        self.placeHolderTextView.hidden = YES;
    }
}

-(void)setPlaceHolder:(NSString *)placeHolder{
    self.placeHolderTextView.text = placeHolder;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([@"\n" isEqualToString:text]) {
        [self sendClick];
        return NO;
    } else {
        return YES;
    }
}
// 发送
-(void)sendClick
{
    NSString *content = self.inputTextView.text;
    if (content.length>0 || self.receiveEmpty) {
        if (self.sendCommentBlock) {
            self.sendCommentBlock(content);
        }
        [self dismiss];
    }

}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0 ) {
        if (self.maxLength && textView.text.length > self.maxLength) { // 超出字数限制
            textView.text = self.inputContent;
//            [DOCutils showNotifitationInWindow:[NSString stringWithFormat:@"最多输入%ld个字!",(long)self.maxLength]];
        }
    }
    self.placeHolderTextView.hidden = textView.text.length;
    self.inputContent = textView.text;
    float datHeight = 0;
    float textViewHeight = textView.frame.size.height;
    float textViewFitHeight = ceilf([textView sizeThatFits:textView.frame.size].height);
    if (textViewFitHeight < textViewHig) {
        textViewFitHeight = textViewHig;
    }
    if(textViewFitHeight > maxHeight){
        textViewFitHeight = maxHeight;
        self.inputTextView.scrollEnabled = YES;
    } else {
        self.inputTextView.scrollEnabled = NO;
    }
    datHeight = textViewFitHeight - textViewHeight;

    if (fabsf(datHeight) > 0.01) {
        CGFloat constaint = textViewFitHeight + (defaultHig - textViewHig);
        if (self.keyBoardHig > 0) {
            self.bottomView.frame = CGRectMake(0, iphoneWidth - self.keyBoardHig - constaint, iphoneWidth, constaint);
            [textView setNeedsLayout];
            [textView layoutIfNeeded];
        }
    }
    
    CGPoint offset = CGPointMake(0.0f, (self.inputTextView.contentSize.height - self.inputTextView.frame.size.height));
    [self.inputTextView setContentOffset:offset animated:YES];

}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
}

-(void)showWithSendCommentBlock:(SendCommentBlock)block{
    NSLog(@"showWithSendCommentBlock start");
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.sendCommentBlock = block;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(window);
    }];
    [self.inputTextView becomeFirstResponder];
    NSLog(@"showWithSendCommentBlock end");
}

- (void)dismiss {
    [self.inputTextView resignFirstResponder];
    [self removeFromSuperview];
}

#pragma mark - 通知

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unRegisterNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 输入键盘相关

//Code from Brett Schumann
- (void)keyboardWillShow:(NSNotification *)note{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];

    
    self.keyBoardHig = keyboardBounds.size.height;
    float textViewFitHeight = ceilf([self.inputTextView sizeThatFits:self.inputTextView.frame.size].height);
    if (textViewFitHeight < textViewHig) {
        textViewFitHeight = textViewHig;
    }
    if (textViewFitHeight > maxHeight) {
        textViewFitHeight = maxHeight;
    }
    
    CGFloat constaint = textViewFitHeight + (defaultHig - textViewHig);
    
    self.bottomView.frame = CGRectMake(0, iphoneHeight - constaint - self.keyBoardHig, iphoneWidth, constaint);
//    [NotificationUtil postNotificationName:Notification_DOCFriend_DidComment object:self.bottomView];
    // commit animations
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    //    CGRect containerFrame = containerView.frame;
    //    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    //    containerView.frame = containerFrame;
    self.bottomView.frame = CGRectMake(0, iphoneHeight - defaultHig, iphoneWidth, defaultHig);
    // commit animations
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}


@end
