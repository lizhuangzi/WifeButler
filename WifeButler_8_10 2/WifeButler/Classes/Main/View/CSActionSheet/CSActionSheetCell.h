//
//  CSActionSheetCell.h
//  docClient
//
//  Created by GDXL2012 on 15/8/18.
//  Copyright (c) 2015年 luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSActionSheetCell : UITableViewCell
// 顶部圆角cell
+(instancetype)topRoundedSquareActionSheetCell:(NSString *)reuseIdentifier isNewStyle:(BOOL)isNewStyle;

// 底部圆角cell
+(instancetype)bottomRoundedSquareActionSheetCell:(NSString *)reuseIdentifier isNewStyle:(BOOL)isNewStyle;

//正常cell
+(instancetype)normalActionSheetCell:(NSString *)reuseIdentifier isNewStyle:(BOOL)isNewStyle;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign)BOOL sepViewHidden;

@end
