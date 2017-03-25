//
//  HomePageSectionModel.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/22.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>
/**首页组模型*/
@interface HomePageSectionModel : NSObject

/*置顶插图**/
@property (nonatomic,copy)NSString * banner;
/**内容列表*/
@property (nonatomic,strong) NSArray * list;
/**名字*/
@property (nonatomic,copy)NSString * title;

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,assign) NSInteger type;

+ (instancetype)SectionModelWithDictionary:(NSDictionary *)dict;

@end
