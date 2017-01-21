//
//  ZTLunBoToModel.m
//  WifeButler
//
//  Created by ZT on 16/7/7.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTLunBoToModel.h"

@implementation ZTLunBoToModel


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.file forKey:@"file"];
    [aCoder encodeObject:self.goods_id forKey:@"goods_id"];
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.serve_id forKey:@"serve_id"];
    [aCoder encodeObject:self.sort forKey:@"sort"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.word forKey:@"word"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]){
        
        self.file = [aDecoder decodeObjectForKey:@"file"];
        self.goods_id = [aDecoder decodeObjectForKey:@"goods_id"];
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.serve_id = [aDecoder decodeObjectForKey:@"serve_id"];
        self.sort = [aDecoder decodeObjectForKey:@"sort"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.word = [aDecoder decodeObjectForKey:@"word"];

    }
    
    return self;
}


@end
