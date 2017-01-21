//
//  ZJThrendsDetailReplyView.m
//  weiCity
//
//  Created by 陈振奎 on 16/4/12.
//  Copyright © 2016年 Mr.chen. All rights reserved.
//

#import "ZJTrendsDetailReplyView.h"


@interface ZJTrendsDetailReplyView ()<TYAttributedLabelDelegate>

@end

@implementation ZJTrendsDetailReplyView

-(void)setFrameModel:(ZJTrendsCommentViewFrameModel *)frameModel{
    _frameModel = frameModel;
   
    [self createTextView];

    [self createRevertViews];
    
       
    [self settingData];
    [self settingFrame];
    
 
}


-(void)createTextView{
    
    TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
    label.textContainer = [self createTextContainer];
    label.delegate = self;
    
    [label setFrameWithOrign:self.frameModel.textViewF.origin Width:self.frameModel.textViewF.size.width];
    
    [label sizeToFit];
    
    [self addSubview:label];
    
    self.textView = label;
}




-(void)createRevertViews{
    
    for (int i = 0; i < self.frameModel.model.child.count; ++i) {
   
        CGRect revertViewF = CGRectFromString(self.frameModel.revertFs[i]);
   
        TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
        label.textContainer = [self createTextContainerWithIndex:i];
       
        label.delegate = self;
        
        [label setFrameWithOrign:revertViewF.origin Width:revertViewF.size.width];
        
        [label sizeToFit];
        
        [self addSubview:label];
       
    }
}


-(void)settingData{
   
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[KImageUrl stringByAppendingString:self.frameModel.model.avatar]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    
    [self.name setTitle:self.frameModel.model.nickname forState:UIControlStateNormal];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    formatter.dateFormat = @"MM-dd HH:mm";
    
    NSTimeInterval timeInterval = [self.frameModel.model.time doubleValue];
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSString *startTime = [formatter stringFromDate:startDate];
    
    self.time.text = startTime;
    
    [self.replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    
}


-(void)settingFrame{
    
    self.icon.frame = self.frameModel.iconF;
    
    self.icon.layer.cornerRadius = self.icon.height * 0.5;
    self.icon.layer.masksToBounds = YES;
    
    self.name.frame = self.frameModel.nameF;
    
    self.time.frame = self.frameModel.timeF;
    
    self.replyBtn.frame = self.frameModel.replyBtnF;
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UIImageView *icon = [[UIImageView alloc]init];
        icon.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(icon_clicked:)];
        [icon addGestureRecognizer:tap];
        
        [self addSubview:icon];
        self.icon = icon;

        UIButton *name = [[UIButton alloc]init];
       
        [name setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        name.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:name];
        
        self.name = name;
        
        [name addTarget:self action:@selector(nameBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
       
        UILabel *time = [[UILabel alloc]init];
        time.font = [UIFont systemFontOfSize:13];
        time.textColor = [UIColor grayColor];
        [self addSubview:time];
        
        self.time = time;
        
        
        UIButton *replyBtn = [[UIButton alloc]init];
       
        [replyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        replyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:replyBtn];
        
        self.replyBtn = replyBtn;
  
        [replyBtn addTarget:self action:@selector(replyBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    return self;
}


//主评论容器
-(TYTextContainer *)createTextContainer{
    
    NSString *contentStr = self.frameModel.model.content;
    
    //属性文本容器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = contentStr;
    
    textContainer.font = [UIFont systemFontOfSize:15];
    // 文字间隙
    textContainer.characterSpacing = 1;
    // 文本行间隙
    textContainer.linesSpacing = 2;
    
    [textContainer addLinkWithLinkData:[NSString stringWithFormat:@"%@,%@,%@",self.frameModel.model.id,self.frameModel.model.uid,self.frameModel.model.nickname] linkColor:[UIColor blackColor] underLineStyle:kCTUnderlineStyleNone range:[self.frameModel.model.content rangeOfString:self.frameModel.model.content]];
    
    
    // 生成 textContainer 文本容器
    [textContainer createTextContainerWithTextWidth:self.frameModel.textViewF.size.width];
    
    return textContainer;
    
}



//副评论容器
-(TYTextContainer *)createTextContainerWithIndex:(int)index{
    
    
    ZJCommentModel *detailModel = self.frameModel.model.child[index];
    
    CGRect revertViewF = CGRectFromString(self.frameModel.revertFs[index]);
    
    NSString *str = [NSString stringWithFormat:@"%@回复%@:%@",detailModel.nickname,detailModel.argued_name,detailModel.content];
    
    //属性文本容器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = str;
    
    textContainer.font = [UIFont systemFontOfSize:14];
    // 文字间隙
    textContainer.characterSpacing = 1;
    // 文本行间隙
    textContainer.linesSpacing = 2;
    
    [textContainer addLinkWithLinkData:[NSString stringWithFormat:@"%@,%@,%@",detailModel.id,detailModel.uid,detailModel.nickname] linkColor:[UIColor blackColor] underLineStyle:kCTUnderlineStyleNone range:[str rangeOfString:detailModel.content]];
     [textContainer addLinkWithLinkData:[NSString stringWithFormat:@"%@,%@,%@",detailModel.id,detailModel.uid,detailModel.nickname]  linkColor:[UIColor blackColor] underLineStyle:kCTUnderlineStyleNone range:[str rangeOfString:@"回复"]];
    [textContainer addLinkWithLinkData:@[detailModel.uid,detailModel.nickname] linkColor:[UIColor blueColor] underLineStyle:kCTUnderlineStyleNone range:[str rangeOfString:detailModel.nickname]];
    
    [textContainer addLinkWithLinkData:@[detailModel.upid,detailModel.argued_name] linkColor:[UIColor blueColor] underLineStyle:kCTUnderlineStyleNone range:[str rangeOfString:detailModel.argued_name]];
    
    // 生成 textContainer 文本容器
    [textContainer createTextContainerWithTextWidth:revertViewF.size.width];
    
    return textContainer;
    
}


-(void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point{
    
    
    if ([textStorage isKindOfClass:[TYLinkTextStorage class]]) {
        
        id linkData = ((TYLinkTextStorage*)textStorage).linkData;
       
        if ([self.delegate respondsToSelector:@selector(threndsDetailReplyView:textViewClickedWithData:)]) {
            [self.delegate threndsDetailReplyView:self textViewClickedWithData:linkData];
        }
        
        
       
    }else if ([textStorage isKindOfClass:[TYImageStorage class]]) {
        
        TYImageStorage *imageStorage = (TYImageStorage *)textStorage;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"点击提示" message:[NSString stringWithFormat:@"你点击了%@图片",imageStorage.imageName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        
    }else if([textStorage isKindOfClass:[TYViewStorage class]]){
        
        //TYViewStorage 无单击事件
        
        //        FirstViewController *ctrl = [[FirstViewController alloc]init];
        //
        //        [self presentViewController:ctrl animated:YES completion:nil];
        
    }
    
    
    
}


//评论头像点击
-(void)icon_clicked:(UITapGestureRecognizer *)tap{
    
    NSLog(@"%@",self.frameModel.model.nickname);
    
    self.buttonType = ZJThrendsDetailReplyViewButtonTypeIcon;
    
    if ([self.delegate respondsToSelector:@selector(threndsDetailReplyView:subButtonClickedWithType:)]) {
        [self.delegate threndsDetailReplyView:self subButtonClickedWithType:self.buttonType];
    }
    

}



//昵称点击
-(void)nameBtn_clicked:(UIButton *)sender{

    NSLog(@"%@",self.frameModel.model.nickname);
    
    self.buttonType = ZJThrendsDetailReplyViewButtonTypeName;
    
    if ([self.delegate respondsToSelector:@selector(threndsDetailReplyView:subButtonClickedWithType:)]) {
        [self.delegate threndsDetailReplyView:self subButtonClickedWithType:self.buttonType];
    }

    
}



//回复按钮
-(void)replyBtn_clicked:(UIButton *)sender{
    
    NSLog(@"%@",self.frameModel.model.nickname);
    
    self.buttonType = ZJThrendsDetailReplyViewButtonTypeReply;
    
    if ([self.delegate respondsToSelector:@selector(threndsDetailReplyView:subButtonClickedWithType:)]) {
        [self.delegate threndsDetailReplyView:self subButtonClickedWithType:self.buttonType];
    }

}


@end
