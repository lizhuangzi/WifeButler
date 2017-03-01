//
//  CSActionSheet.h
//  docClient
//
//  Created by GDXL2012 on 15/8/18.
//  Copyright (c) 2015年 luo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger, CSActionSheetType){
    kCSActionSheetTypeNone,
    kCSActionSheetTypeImageLongTap,
};

@class CSActionSheet;
@protocol CSActionSheetDelegate <NSObject>

-(void)actionSheet:(CSActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@optional
-(void)actionSheet:(CSActionSheet *)actionSheet clickedArtworkButtonSelect:(BOOL)isArtwork titleBlock:(void(^)(NSString *title))block;

@end

@interface CSActionSheet : UIView
- (id)initWithTitle:(NSString *)title delegate:(id<CSActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle otherButtonTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;
/**
 * 用于actionsheet的按钮不确定时使用
 **/
- (id)initWithTitle:(NSString *)title delegate:(id<CSActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle otherTitlesArray:(NSMutableArray *)titles;

/**
 * 用于7月20改版后
 **/
- (id)initWithNewTitle:(NSString *)title delegate:(id<CSActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle otherButtonTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * 用于图片长按或其他
 **/
- (id)initWithNewTitle:(NSString *)title CSActionSheetType:(CSActionSheetType)actionType delegate:(id<CSActionSheetDelegate>)delegate inputParam:(NSDictionary *)param cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle otherButtonTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

-(void)show;
@end
