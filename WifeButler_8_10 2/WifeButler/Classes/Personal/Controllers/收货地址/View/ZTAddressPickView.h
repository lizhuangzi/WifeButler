//
//  ZTAddressPickView.h
//  YouHu
//
//  Created by ZT on 16/5/7.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTAddressPickView : UIView


@property (weak, nonatomic) IBOutlet UIPickerView *ZTPickView;

@property (nonatomic, copy) void(^doneBlack)();

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
