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

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{ @"child":@"DocFriendReviewModel"
              };
}

-(BOOL)isReviewOther
{
    if (_argued_id) {
        return YES;
    }else{
        return NO;
    }
}

-(NSMutableAttributedString *)contentAttributed
{
    
    NSString *str = _content;
    if (_argued_id.integerValue != 0) { // 有被回复人
        str = [NSString stringWithFormat:@"%@回复%@: %@",_nickname,_argued_name,_content];
    }else{
        str = [NSString stringWithFormat:@"%@: %@ ",_nickname,_content];
    }
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(_nickname.length, _content.length+2)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:WifeButlerNavyBlueColor range:NSMakeRange(0,_nickname.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:14] range:NSMakeRange(0,_nickname.length)];
    
       if (_argued_id.integerValue != 0) {
        [attributedStr addAttribute:NSForegroundColorAttributeName value:WifeButlerNavyBlueColor range:NSMakeRange(_nickname.length + 2,_nickname.length)];
        [attributedStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:14]} range:NSMakeRange(_nickname.length + 2,_argued_name.length)];
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
    NSRange partyNameRange = NSMakeRange(0, _nickname.length);
    [_rangeArray addObject:NSStringFromRange(partyNameRange)];
    if (_argued_id) {
        NSRange repluNameRange = NSMakeRange(_nickname.length + 2, _argued_name.length + _nickname.length + 2);
        [_rangeArray addObject:NSStringFromRange(repluNameRange)];
    }
    return _rangeArray;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
