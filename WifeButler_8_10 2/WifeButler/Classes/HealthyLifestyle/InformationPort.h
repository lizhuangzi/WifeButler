//
//  InformationPort.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/25.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "NSURL.h"

#ifndef InformationPort_h
#define InformationPort_h

/**资讯种类*/
#define  KinformationType  [HTTP_BaseURL stringByAppendingString:@"goods/article/health"]


// map.put("cat_id", id);
//map.put("page","1");
/**资讯内容*/
#define  KinformationContent [HTTP_BaseURL stringByAppendingString:@"goods/article/health_list"]

/**资讯详情*/
#define KinformationDetial [HTTP_BaseURL stringByAppendingString:@"goods/article/health_detail?article_id=%@"]
/**阅读量+*/
#define KInformationReadCount [HTTP_BaseURL stringByAppendingString:@"goods/article/readadd"]

#endif /* InformationPort_h */
