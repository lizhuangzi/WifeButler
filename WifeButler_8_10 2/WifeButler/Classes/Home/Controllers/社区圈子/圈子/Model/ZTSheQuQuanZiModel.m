//
//  ZTSheQuQuanZiModel.m
//  WifeButler
//
//  Created by ZT on 16/6/13.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTSheQuQuanZiModel.h"

@implementation ZTSheQuQuanZiModel

- (NSString *)avatar
{
    return [NSString stringWithFormat:@"%@%@", KImageUrl, _avatar];
}

// 时间戳转换
- (NSString *)time
{
    NSDate * createdDate =[NSDate dateWithTimeIntervalSince1970:[_time doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    formatter.dateFormat = @"yyyy-MM-dd";
    return  [formatter stringFromDate:createdDate];
}

//@property (nonatomic, copy) NSString * id;
//@property (nonatomic, copy) NSString * topic_id;
//@property (nonatomic, copy) NSString * uid;
//@property (nonatomic, copy) NSString * content;
//@property (nonatomic, copy) NSString * gallery;
//@property (nonatomic, copy) NSString * time;
//@property (nonatomic, copy) NSString * support_id;
//@property (nonatomic, copy) NSString * support_name;
//@property (nonatomic, copy) NSString * upid;
//@property (nonatomic, copy) NSString * nickname;
//@property (nonatomic, copy) NSString * avatar;
//@property (nonatomic, copy) NSString * count;
//@property (nonatomic, copy) NSString * myup;
//@property (nonatomic, copy) NSString * some;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.topic_id forKey:@"topic_id"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.gallery forKey:@"gallery"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.support_id forKey:@"support_id"];
    [aCoder encodeObject:self.upid forKey:@"upid"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.count forKey:@"count"];
    [aCoder encodeObject:self.myup forKey:@"myup"];
    [aCoder encodeObject:self.some forKey:@"some"];

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]){
        
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.topic_id = [aDecoder decodeObjectForKey:@"topic_id"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.gallery = [aDecoder decodeObjectForKey:@"gallery"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.support_id = [aDecoder decodeObjectForKey:@"support_id"];
        self.upid = [aDecoder decodeObjectForKey:@"upid"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.count = [aDecoder decodeObjectForKey:@"count"];
        self.myup = [aDecoder decodeObjectForKey:@"myup"];
        self.some = [aDecoder decodeObjectForKey:@"some"];
        
    }
    
    return self;
}




@end
