//
//  DocFriendReviewModel.m
//  docClient
//
//  Created by paopao on 16/8/11.
//  Copyright © 2016年 luo. All rights reserved.
//

#import "DocFriendReviewModel.h"
#import "MJExtension.h"
@implementation DocFriendReviewModel
MJCodingImplementation;

+(DocFriendReviewModel *)reviewModelWithDic:(NSDictionary *)dict
{
    DocFriendReviewModel *model = [[DocFriendReviewModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

-(BOOL)isReviewOther
{
    if (_replyTopRevId) {
        return YES;
    }else{
        return NO;
    }
}

-(NSMutableAttributedString *)contentAttributed
{
    
    NSString *str = _content;
    if (_replyTopRevId) { // 有被回复人
        str = [NSString stringWithFormat:@"%@回复%@: %@",_partyName,_replyName,_content];
    }else{
        str = [NSString stringWithFormat:@"%@: %@",_partyName,_content];
    }
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
//    [attributedStr addAttribute:NSForegroundColorAttributeName value:HexCOLOR(MedRefWordColorNavyBlue) range:NSMakeRange(0,_partyName.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, str.length)];
    [attributedStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:14]} range:NSMakeRange(0,_partyName.length)];
    if (_replyTopRevId) {
//        [attributedStr addAttribute:NSForegroundColorAttributeName value:HexCOLOR(MedRefWordColorNavyBlue) range:NSMakeRange(_partyName.length + 2,_replyName.length)];
        [attributedStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:14]} range:NSMakeRange(_partyName.length + 2,_replyName.length)];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:2];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
    return attributedStr;
}

-(NSMutableArray *)rangeArray
{
    if (_rangeArray == nil) {
        _rangeArray = [NSMutableArray array];
    }
    [_rangeArray removeAllObjects];
    NSRange partyNameRange = NSMakeRange(0, _partyName.length);
    [_rangeArray addObject:NSStringFromRange(partyNameRange)];
    if (_replyTopRevId) {
        NSRange repluNameRange = NSMakeRange(_partyName.length + 2, _replyName.length + _partyName.length + 2);
        [_rangeArray addObject:NSStringFromRange(repluNameRange)];
    }
    return _rangeArray;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
