//
//  DocFriendModel.m
//  docClient
//
//  Created by paopao on 16/8/11.
//  Copyright © 2016年 luo. All rights reserved.
//

#import "DocFriendModel.h"
#import "DocFriendPraiseModel.h"
#import "DocFriendReviewModel.h"
#import "MJExtension.h"

@implementation DocFriendModel
MJCodingImplementation;

+(DocFriendModel*)friendModelWithDict:(NSDictionary *)dict
{
    DocFriendModel *model = [DocFriendModel mj_objectWithKeyValues:dict];
    return model;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"some" : @"DocFriendPraiseModel",
              @"discuss" : @"DocFriendReviewModel",
              @"gallery":@"DocImageModel"
              };
}

- (void)mj_keyValuesDidFinishConvertingToObject
{
    NSString * str = [KImageUrl stringByAppendingString:self.avatar];
    NSString * utf8Str =  [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _iconFullPath = [NSURL URLWithString:utf8Str];
    
    // 有点赞 需要在评论数组最前边插入一个标记 用来减少controller中数据处理逻辑
    if (_some.count > 0) {
        if (![_discuss containsObject:@"这是一个标记"]) {
            [_discuss insertObject:@"这是一个标记" atIndex:0];
        }
    }else{
        if ([_discuss containsObject:@"这是一个标记"]) {
            [_discuss removeObject:@"这是一个标记"];
        }
    }
    
    for (int i = 0; i<_discuss.count; i++) {
        DocFriendReviewModel * re = _discuss[i];
        [self.reviewArray addObject:re];
        if ([re isKindOfClass:[NSString class]]) {
            continue;
        }
        for (DocFriendReviewModel * model in re.child) {
            [self.reviewArray addObject:model];
        }
    }
}


-(NSMutableAttributedString *)praiseAttributed
{
    if (!(_some.count > 0)) {
        return [[NSMutableAttributedString alloc] init];
    }
    NSMutableAttributedString *atributedStr = [[NSMutableAttributedString alloc] initWithString:@"      "];
    CGFloat strIndex = atributedStr.string.length;
    
    for (int i = 0 ; i < _some.count ; i ++) {
        DocFriendPraiseModel *model = _some[i];
        if ([model isKindOfClass:[DocFriendPraiseModel class]]) {
            NSString *name = model.nickname;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:name];
            NSMutableAttributedString *montage = [[NSMutableAttributedString alloc] initWithString:@","];
            if (i == _some.count - 1) {
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
    
    for (int i = 0 ; i < _some.count ; i ++) {
        DocFriendPraiseModel *model = _some[i];
        if ([model isKindOfClass:[DocFriendPraiseModel class]]) {
            NSString *name = model.nickname;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:name];
            NSMutableAttributedString *montage = [[NSMutableAttributedString alloc] initWithString:@","];
            if (i == _some.count - 1) {
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
    if (!_reviewArray) {
        _reviewArray = [NSMutableArray array];
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
