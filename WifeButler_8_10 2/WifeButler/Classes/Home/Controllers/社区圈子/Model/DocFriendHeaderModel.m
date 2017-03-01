//
//  DocFriendHeaderModel.m
//  docClient
//
//  Created by paopao on 16/8/11.
//  Copyright © 2016年 luo. All rights reserved.
//

#import "DocFriendHeaderModel.h"
#import "MJExtension.h"
@implementation DocFriendHeaderModel
MJCodingImplementation;
-(NSString *)content{
    if (_content.length == 0) {
        return @"";
    }
    return _content;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
