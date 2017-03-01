//
//  DocFriendModel.m
//  docClient
//
//  Created by paopao on 16/8/11.
//  Copyright © 2016年 luo. All rights reserved.
//

#import "DocFriendModel.h"
#import "DocFriendHeaderModel.h"
#import "DocFriendPraiseModel.h"
#import "DocFriendReviewModel.h"
#import "MJExtension.h"

@implementation DocFriendModel
MJCodingImplementation;

+(DocFriendModel*)friendModelWithDict:(NSDictionary *)dict
{
    DocFriendModel *model = [[DocFriendModel alloc] init];
    [model setValuesForKeysWithDict:dict];
    return model;
}

-(void)setValuesForKeysWithDict:(NSDictionary *)dict
{
    // 顶部数据
    self.headerModel = [[DocFriendHeaderModel alloc] init];
    [self.headerModel setValuesForKeysWithDictionary:dict];
    // 点赞数据
    self.praiseArray = [NSMutableArray array];
    for (NSDictionary *praiseDic in [dict objectForKey:@"hisTopPraiseList"]) {
        DocFriendPraiseModel *praiseModel = [[DocFriendPraiseModel alloc] init];
        [praiseModel setValuesForKeysWithDictionary:praiseDic];
        [self.praiseArray addObject:praiseModel];
    }
    // 评论数据
    self.reviewArray = [NSMutableArray array];
    for (NSDictionary *reviewDic in [dict objectForKey:@"hisTopReviewList"]) {
        DocFriendReviewModel *reviewModel = [DocFriendReviewModel reviewModelWithDic:reviewDic];
        [self.reviewArray addObject:reviewModel];
    }
    
}

-(NSMutableAttributedString *)praiseAttributed
{
    if (!(_praiseArray.count > 0)) {
        return [[NSMutableAttributedString alloc] init];
    }
    NSMutableAttributedString *atributedStr = [[NSMutableAttributedString alloc] initWithString:@"      "];
    CGFloat strIndex = atributedStr.string.length;
    
    for (int i = 0 ; i < _praiseArray.count ; i ++) {
        DocFriendPraiseModel *model = _praiseArray[i];
        if ([model isKindOfClass:[DocFriendPraiseModel class]]) {
            NSString *name = model.partyName;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:name];
            NSMutableAttributedString *montage = [[NSMutableAttributedString alloc] initWithString:@","];
            if (i == _praiseArray.count - 1) {
                montage = [[NSMutableAttributedString alloc] initWithString:@" "];
            }
            [montage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 1)];
            [montage addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 1)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:14] range:NSMakeRange(0, name.length)];
//            [str addAttribute:NSForegroundColorAttributeName value:HexCOLOR(MedRefWordColorNavyBlue) range:NSMakeRange(0, name.length)];
            [atributedStr insertAttributedString:str atIndex:atributedStr.string.length];
            
            [atributedStr insertAttributedString:montage atIndex:atributedStr.string.length];
            
            strIndex = atributedStr.string.length;
        }
    }
    
    return atributedStr;

}
// range
-(NSMutableArray *)praiseRangeArray
{
    if (_praiseRangeArray == nil) {
        _praiseRangeArray = [NSMutableArray array];
    }
    [_praiseRangeArray removeAllObjects];
    
    NSMutableAttributedString *atributedStr = [[NSMutableAttributedString alloc] initWithString:@"      "];
    CGFloat strIndex = atributedStr.string.length;
    
    for (int i = 0 ; i < _praiseArray.count ; i ++) {
        DocFriendPraiseModel *model = _praiseArray[i];
        if ([model isKindOfClass:[DocFriendPraiseModel class]]) {
            NSString *name = model.partyName;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:name];
            NSMutableAttributedString *montage = [[NSMutableAttributedString alloc] initWithString:@","];
            if (i == _praiseArray.count - 1) {
                montage = [[NSMutableAttributedString alloc] initWithString:@" "];
            }
            [montage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 1)];
            [montage addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 1)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:14] range:NSMakeRange(0, name.length)];
//            [str addAttribute:NSForegroundColorAttributeName value:HexCOLOR(MedRefWordColorNavyBlue) range:NSMakeRange(0, name.length)];
            [atributedStr insertAttributedString:str atIndex:atributedStr.string.length];
            
            [atributedStr insertAttributedString:montage atIndex:atributedStr.string.length];
            
            NSRange range = NSMakeRange(strIndex, name.length + strIndex);
            [_praiseRangeArray addObject:NSStringFromRange(range)];
            strIndex = atributedStr.string.length;
        }
    }
    
    return _praiseRangeArray;

}

// 评论数组
-(NSMutableArray *)reviewArray
{
    // 有点赞 需要在评论数组最前边插入一个标记 用来减少controller中数据处理逻辑
    if (_praiseArray.count > 0) {
        if (![_reviewArray containsObject:@"这是一个标记"]) {
            [_reviewArray insertObject:@"这是一个标记" atIndex:0];
        }
    }else{
        if ([_reviewArray containsObject:@"这是一个标记"]) {
            [_reviewArray removeObject:@"这是一个标记"];
        }
    }
    return _reviewArray;
}

// cell 个数
-(NSInteger)cellCount
{
    _cellCount = self.reviewArray.count;
    return _cellCount;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
