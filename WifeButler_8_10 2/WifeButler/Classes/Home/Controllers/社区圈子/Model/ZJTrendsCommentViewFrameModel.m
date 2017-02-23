//
//  ZJThrendsCommentViewFrameModel.m
//  WifeButler
//
//  Created by 陈振奎 on 16/6/14.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJTrendsCommentViewFrameModel.h"
#import "TYAttributedLabel.h"
#import "NSString+ZJMyString.h"
#import  "MJExtension.h"

#define MARGIN 8

@implementation ZJTrendsCommentViewFrameModel

-(void)setModel:(ZJCommentModel *)model{
    
    _model = model;
    
    _iconF = CGRectMake(MARGIN, MARGIN, 40, 40);
    
    
    UIButton *nameBtn = [[UIButton alloc]init];
    [nameBtn setTitle:model.nickname forState:UIControlStateNormal];
    nameBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [nameBtn sizeToFit];
    
    
    _nameF = CGRectMake(CGRectGetMaxX(_iconF) + MARGIN, MARGIN, nameBtn.width, 16);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    formatter.dateFormat = @"MM-dd HH:mm";
    
    NSTimeInterval timeInterval = [model.time doubleValue];
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSString *startTime = [formatter stringFromDate:startDate];

    CGSize timeSize = [startTime getMyStringSizeWithFont:[UIFont systemFontOfSize:13] andSize:CGSizeMake(iphoneWidth, MAXFLOAT)];
    
    _timeF = CGRectMake(CGRectGetMaxX(_iconF) + MARGIN, CGRectGetMaxY(_nameF) + MARGIN, timeSize.width, timeSize.height);
    
    
    UIButton *replyBtn = [[UIButton alloc] init];
    [replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    replyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [replyBtn sizeToFit];
    
    _replyBtnF = CGRectMake(iphoneWidth - MARGIN - replyBtn.width, MARGIN, replyBtn.width, replyBtn.height);
    
    
    TYAttributedLabel *textView = [[TYAttributedLabel alloc]init];
    textView.textContainer = [self createTextContainer];
    
    [textView setFrameWithOrign:CGPointMake(MARGIN, MARGIN + CGRectGetMaxY(_iconF)) Width:iphoneWidth - (MARGIN * 2)];
    
    [textView sizeToFit];
    
    _textViewF = textView.frame;
    
    model.child = [ZJCommentModel mj_objectArrayWithKeyValuesArray:model.child];
    
    CGFloat revertViewY = CGRectGetMaxY(_textViewF) + MARGIN;
    
    _revertFs = [NSMutableArray array];
    
    for (int i = 0; i < model.child.count; ++i) {
        
        
        TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
        
        label.textContainer = [self createTextContainerWithIndex:i];
        
        [label setFrameWithOrign:CGPointMake(MARGIN, revertViewY) Width:iphoneWidth - MARGIN *2];
        
        [label sizeToFit];
        
        
        CGRect revertViewF = label.frame;
        
        [_revertFs addObject:NSStringFromCGRect(revertViewF)];
        
        revertViewY += label.frame.size.height + MARGIN;
        
    }
    
    if (!model.child.count) {
        
        _viewH = revertViewY;
        
    }else{
        
        _viewH = CGRectGetMaxY(CGRectFromString(_revertFs.lastObject))+ MARGIN;
    }
}



//主评论容器
-(TYTextContainer *)createTextContainer{
    
    NSString *contentStr = self.model.content;
    
    //属性文本容器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = contentStr;
    
    textContainer.font = [UIFont systemFontOfSize:15];
    // 文字间隙
    textContainer.characterSpacing = 1;
    // 文本行间隙
    textContainer.linesSpacing = 2;
    
    [textContainer addLinkWithLinkData:self.model.id linkColor:[UIColor blackColor] underLineStyle:kCTUnderlineStyleNone range:[self.model.content rangeOfString:self.model.content]];
    
    
    // 生成 textContainer 文本容器
    [textContainer createTextContainerWithTextWidth:self.textViewF.size.width];
    
    return textContainer;
    
}

//副评论容器
-(TYTextContainer *)createTextContainerWithIndex:(int)index{
    
    ZJCommentModel *detailModel = self.model.child[index];
    
    NSString *str = [NSString stringWithFormat:@"%@回复%@:%@",detailModel.nickname,detailModel.argued_name,detailModel.content];
    
    
    //属性文本容器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = str;
    
    textContainer.font = [UIFont systemFontOfSize:14];
    // 文字间隙
    textContainer.characterSpacing = 1;
    // 文本行间隙
    textContainer.linesSpacing = 2;
    
    
    // 生成 textContainer 文本容器
    [textContainer createTextContainerWithTextWidth:iphoneWidth - MARGIN * 2];
    
    return textContainer;
    
}

@end
