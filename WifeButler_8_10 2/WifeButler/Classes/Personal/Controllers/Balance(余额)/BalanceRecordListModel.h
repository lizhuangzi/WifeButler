//
//  BalanceRecordListModel.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/12.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerCommonBaseModel.h"

@interface BalanceRecordListModel : WifeButlerCommonBaseModel
/**时间*/
@property (nonatomic,copy)NSString * ctime;
/**标志*/
@property (nonatomic,assign)NSInteger  flag;
/**钱*/
@property (nonatomic,copy)NSString * money;
/**内容*/
@property (nonatomic,copy)NSString * name;
@end
