//
//  CSActionSheet.m
//  docClient
//
//  Created by GDXL2012 on 15/8/18.
//  Copyright (c) 2015年 luo. All rights reserved.
//

#import "CSActionSheet.h"
#import "CSActionSheetCell.h"
#import "Masonry.h"
#import "WifeButlerDefine.h"
/**
 * 可以计算高度，所以可以不用倒立的tableview来实现
 */
@interface CSActionSheet()<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *_titlesArray;
    NSString *_cancelTitle;
    NSString *_titleString;
    NSString *_imgLengthTitle;
    UITableView *titleTableView;
    NSInteger titlesArrayCount;
    CSActionSheetType actionSheetType;
    UIView *bgView;
    UIView *itemsBgView;
}
@property (nonatomic, assign) id<CSActionSheetDelegate> delegate;
@property (nonatomic, assign) BOOL hasDestructiveButton;
@property (nonatomic, assign) BOOL hasCancelButton;
@property (nonatomic, assign) BOOL hasTitle;
@property (nonatomic, assign) BOOL newStyle; // 是否是新样式

@property(nonatomic,assign)BOOL isOutScreen;//是否超过屏幕
@end

@implementation CSActionSheet

- (id)initWithTitle:(NSString *)title delegate:(id<CSActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle otherButtonTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION{
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    if (otherTitles) {
        va_list args;
        va_start(args, otherTitles);
        for (NSString *arg = otherTitles; arg != nil; arg = va_arg(args, NSString* ))
        {
            [titles addObject:arg];
        }
        va_end(args);
    }
    self.newStyle = NO;
    self = [self initWithTitle:title delegate:delegate cancelButtonTitle:cancelTitle destructiveButtonTitle:destructiveTitle otherTitlesArray:titles];
    return self;
}

/**
 * 用于图片长按或其他
 **/
- (id)initWithNewTitle:(NSString *)title CSActionSheetType:(CSActionSheetType)actionType delegate:(id<CSActionSheetDelegate>)delegate inputParam:(NSDictionary *)param cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle otherButtonTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    if (otherTitles) {
        va_list args;
        va_start(args, otherTitles);
        for (NSString *arg = otherTitles; arg != nil; arg = va_arg(args, NSString* ))
        {
            [titles addObject:arg];
        }
        va_end(args);
    }
    self.newStyle = YES;
    actionSheetType = actionType;
    _imgLengthTitle = [param objectForKey:@"imageLength"];
    self = [self initWithTitle:title delegate:delegate cancelButtonTitle:cancelTitle destructiveButtonTitle:destructiveTitle otherTitlesArray:titles];
    return self;
}

/**
 * 用于actionsheet的按钮不确定时使用
 **/
- (id)initWithTitle:(NSString *)title delegate:(id<CSActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle otherTitlesArray:(NSMutableArray *)titles{
    self = [self init];
    if (self) {
        //        self.userInteractionEnabled = YES;
        self.delegate = delegate;
        // 设置透明度
        self.backgroundColor = [UIColor clearColor];
        
        bgView = [[UIView alloc] initWithFrame:self.frame];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.0f;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        itemsBgView = [[UIView alloc] initWithFrame:CGRectZero];
        itemsBgView.backgroundColor = [UIColor clearColor];
        [self addSubview:itemsBgView];
        
        _titlesArray = [NSMutableArray array];
        if (title.length == 0) {
            _titleString = title;
            self.hasTitle = YES;
        } else {
            self.hasTitle = NO;
        }
        if (destructiveTitle.length == 0) {
            self.hasDestructiveButton = YES;
            [_titlesArray addObject:destructiveTitle];
        } else {
            self.hasDestructiveButton = NO;
        }
        
        if (cancelTitle.length == 0) {
            self.hasCancelButton = YES;
            _cancelTitle = cancelTitle;
        } else {
            self.hasCancelButton = NO;
        }
        [_titlesArray addObjectsFromArray:titles];
        titlesArrayCount = _titlesArray.count;
        if (self.newStyle) {
            [self initNewView];
        }else{
            [self initView];
        }
    }
    return self;
}

/**
 * 用于2016年7月20改版后
 **/
- (id)initWithNewTitle:(NSString *)title delegate:(id<CSActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle otherButtonTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION{
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    if (otherTitles) {
        va_list args;
        va_start(args, otherTitles);
        for (NSString *arg = otherTitles; arg != nil; arg = va_arg(args, NSString* ))
        {
            [titles addObject:arg];
        }
        va_end(args);
    }
    self.newStyle = YES;
    self = [self initWithTitle:title delegate:delegate cancelButtonTitle:cancelTitle destructiveButtonTitle:destructiveTitle otherTitlesArray:titles];
    return self;

}

-(void)initNewView
{
    // 旋转180°：如果不旋转的话不能保证列表显示在底部
    self.transform = CGAffineTransformMakeRotation(M_PI);
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [itemsBgView addSubview:cancelButton];
    cancelButton.transform = CGAffineTransformMakeRotation(-M_PI);
    
    UIButton *artworkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [artworkButton setBackgroundColor:[UIColor whiteColor]];
    [itemsBgView addSubview:artworkButton];
    artworkButton.transform = CGAffineTransformMakeRotation(-M_PI);
    
    if (actionSheetType == kCSActionSheetTypeImageLongTap) { // 需要显示原图按钮
        
        [artworkButton setTitle:_imgLengthTitle forState:UIControlStateNormal];
        artworkButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [artworkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [artworkButton setImage:[UIImage imageNamed:@"academic_cel2"] forState:UIControlStateNormal];
        [artworkButton addTarget:self action:@selector(artworkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        artworkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        artworkButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        
        [artworkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(itemsBgView.mas_top);
            make.left.mas_equalTo(itemsBgView.mas_left);
            make.right.mas_equalTo(itemsBgView.mas_right);
            make.height.mas_equalTo(50.0f);
        }];
        
        [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside
         ];
        [cancelButton setTitle:_cancelTitle forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(artworkButton.mas_bottom).offset(0.5);
            make.left.mas_equalTo(itemsBgView.mas_left);
            make.right.mas_equalTo(itemsBgView.mas_right);
            make.height.mas_equalTo(50.0f);
        }];

    }else{ // 不需要显示原图按钮
        if(self.hasCancelButton){ // 有取消按钮
            [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside
             ];
            [cancelButton setTitle:_cancelTitle forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(itemsBgView.mas_top);
                make.left.mas_equalTo(itemsBgView.mas_left);
                make.right.mas_equalTo(itemsBgView.mas_right);
                make.height.mas_equalTo(50.0f);
            }];
        } else {
            [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(itemsBgView.mas_top).offset(-50.0f);
                make.left.mas_equalTo(itemsBgView.mas_left);
                make.right.mas_equalTo(itemsBgView.mas_right);
                make.height.mas_equalTo(50.0f);
            }];
        }

    }
    

    
    
    titleTableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
    titleTableView.delegate = self;
    titleTableView.dataSource = self;
    titleTableView.showsHorizontalScrollIndicator = NO;
    titleTableView.showsVerticalScrollIndicator = NO;
    titleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    titleTableView.backgroundColor = [UIColor clearColor];
    titleTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [itemsBgView addSubview:titleTableView];
    CGFloat height = 50 * titlesArrayCount; // 计算选项高度
    if (self.hasTitle) {
        height = height + 60;
    }
    CGFloat datHeight = iphoneWidth - height - 10 * 20;
    if (self.hasCancelButton) {
        datHeight = datHeight - 50.0f;
    }
    if (datHeight < 0) { // 选项超出屏幕
        titleTableView.scrollEnabled = YES;
        self.isOutScreen = YES;
    } else {
        titleTableView.scrollEnabled = NO;
    }
    [titleTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cancelButton.mas_bottom).offset(5.0f);
        make.left.mas_equalTo(itemsBgView.mas_left);
        make.right.mas_equalTo(itemsBgView.mas_right);
        if(datHeight < 0){
            make.bottom.mas_equalTo(itemsBgView.mas_bottom).offset(0);
        } else {
            make.height.mas_equalTo(height);
        }
    }];
    
    UIView *maskView = [[UIView alloc] init];
    [itemsBgView insertSubview:maskView atIndex:0];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(itemsBgView.mas_left);
        make.right.equalTo(itemsBgView.mas_right);
        make.top.equalTo(itemsBgView.mas_top);
        make.bottom.equalTo(titleTableView.mas_bottom);
    }];
    if (MoreThaniOS8) { // 毛玻璃效果只支持到iOS8.0以上
        maskView.backgroundColor = [UIColor clearColor];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        //  毛玻璃view 视图
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //添加到要有毛玻璃特效的控件中
        [maskView addSubview:effectView];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(maskView);
        }];
    } else {
        maskView.backgroundColor = WifeButlerTableBackGaryColor;
    }
    
}

-(void)initView{
    // 旋转180°：如果不旋转的话不能保证列表显示在底部
    self.transform = CGAffineTransformMakeRotation(M_PI);
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.layer.cornerRadius = 3.0f;
    cancelButton.layer.masksToBounds = YES;
    [itemsBgView addSubview:cancelButton];
    cancelButton.transform = CGAffineTransformMakeRotation(-M_PI);
    if(self.hasCancelButton){
        [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside
         ];
        [cancelButton setTitle:_cancelTitle forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(itemsBgView.mas_top).offset(10.0f);
            make.left.mas_equalTo(itemsBgView.mas_left).offset(tableViewEdgeInsetsLeft);
            make.right.mas_equalTo(itemsBgView.mas_right).offset(-tableViewEdgeInsetsLeft);
            make.height.mas_equalTo(45.0f);
        }];
    } else {
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(itemsBgView.mas_top).offset(-45.0f);
            make.left.mas_equalTo(itemsBgView.mas_left).offset(tableViewEdgeInsetsLeft);
            make.right.mas_equalTo(itemsBgView.mas_right).offset(-tableViewEdgeInsetsLeft);
            make.height.mas_equalTo(45.0f);
        }];
    }
    
    titleTableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
    titleTableView.delegate = self;
    titleTableView.dataSource = self;
    titleTableView.layer.cornerRadius = 3.0f;
    titleTableView.layer.masksToBounds = YES;
    titleTableView.showsHorizontalScrollIndicator = NO;
    titleTableView.showsVerticalScrollIndicator = NO;
    titleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    titleTableView.backgroundColor = [UIColor clearColor];
    titleTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [itemsBgView addSubview:titleTableView];
    CGFloat height = 45 * titlesArrayCount; // 计算选项高度
    if (self.hasTitle) {
        height = height + 55;
    }
    CGFloat datHeight = iphoneWidth - height - 10 * 20;
    if (self.hasCancelButton) {
        datHeight = datHeight - 45.0f;
    }
    if (datHeight < 0) { // 选项超出屏幕
        titleTableView.scrollEnabled = YES;
    } else {
        titleTableView.scrollEnabled = NO;
    }
    [titleTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cancelButton.mas_bottom).offset(10.0f);
        make.left.mas_equalTo(itemsBgView.mas_left).offset(tableViewEdgeInsetsLeft);
        make.right.mas_equalTo(itemsBgView.mas_right).offset(-tableViewEdgeInsetsLeft);
        if(datHeight < 0){
            make.bottom.mas_equalTo(itemsBgView.mas_bottom).offset(-10);
        } else {
            make.height.mas_equalTo(height);
        }
    }];
}

-(void)dealloc{
    NSLog(@"CSActionSheet dealloc");
    _delegate = nil;
}

#pragma mark - 点击原图按钮
-(void)artworkButtonClick:(UIButton *)button
{
    if (button.selected) {
        [button setImage:[UIImage imageNamed:@"academic_cel2"] forState:UIControlStateNormal];
    }else{
        [button setImage:[UIImage imageNamed:@"academic_cel1"] forState:UIControlStateNormal];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedArtworkButtonSelect:titleBlock:)]) {
        [self.delegate actionSheet:self clickedArtworkButtonSelect:button.selected titleBlock:^(NSString *title) {
            [button setTitle:title forState:UIControlStateNormal];
        }];
    }
    button.selected = !button.selected;
}

#pragma mark - 点击取消
-(void)cancelButtonClick:(UIButton *)button{
    [self disMiss];
}

#pragma makr - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return titlesArrayCount;
    } else {
        if (self.hasTitle) {
            return 1;
        } else {
            return 0;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.newStyle) {
            return 50;
        }else{
            return 45.0f;
        }
    } else if(indexPath.section == 1){
        if (self.hasTitle) {
            return 55.0f;
        } else {
            return 0;
        }
    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        CSActionSheetCell *cell;
        if (!self.hasTitle && (indexPath.row == _titlesArray.count - 1)) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"TopActionSheetCellIdentifier"];
            if (!cell) {
                cell = [CSActionSheetCell topRoundedSquareActionSheetCell:@"TopActionSheetCellIdentifier" isNewStyle:self.newStyle];
                cell.contentView.transform = CGAffineTransformMakeRotation(-M_PI);
            }
            // 最后一条没有分割线
            cell.sepViewHidden = YES;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"NormalActionSheetCellIdentifier"];
            if (!cell) {
                cell = [CSActionSheetCell normalActionSheetCell:@"NormalActionSheetCellIdentifier" isNewStyle:self.newStyle];
                cell.contentView.transform = CGAffineTransformMakeRotation(-M_PI);
            }
            cell.sepViewHidden = NO;
        }
        cell.titleLabel.text = _titlesArray[titlesArrayCount - indexPath.row - 1];
        cell.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        if (self.hasDestructiveButton && indexPath.row == titlesArrayCount - 1) {
            cell.titleLabel.textColor = [UIColor redColor];
        } else {
            cell.titleLabel.textColor = [UIColor blackColor];
        }
        return cell;
    } else {
        CSActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopActionSheetCellIdentifier"];
        if (!cell) {
            cell = [CSActionSheetCell topRoundedSquareActionSheetCell:@"TopActionSheetCellIdentifier" isNewStyle:self.newStyle];
            cell.contentView.transform = CGAffineTransformMakeRotation(-M_PI);
        }
        cell.titleLabel.text = _titleString;
        cell.titleLabel.font = [UIFont systemFontOfSize:systembigfont];
        cell.titleLabel.textColor = [UIColor grayColor];
        cell.sepViewHidden = YES;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
            NSInteger index = _titlesArray.count - indexPath.row - 1;
            [self.delegate actionSheet:self clickedButtonAtIndex:index];
        }
        [self disMiss];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self disMiss];
}

-(void)show{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.frame = window.bounds;
    [window addSubview:self];
    
    UIViewController *vc = [self getCurrentVC];
    [vc.view endEditing:YES];
    CGRect frame = window.bounds;
    frame.origin.y = -frame.size.height;
    itemsBgView.frame = frame;
    [UIView animateWithDuration:0.3f animations:^{
        bgView.alpha = 0.2f;
        CGRect realFrame = window.bounds;
        if (self.isOutScreen == YES) {
            realFrame.size.height = realFrame.size.height - 150;
        }
        itemsBgView.frame = realFrame;
    } completion:^(BOOL finished) {
    }];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
}

-(void)disMiss{
    [UIView animateWithDuration:0.3f animations:^{
        bgView.alpha = 0.0f;
        CGRect frame = self.bounds;
        frame.origin.y = -frame.size.height;
        if (self.isOutScreen == YES) {
            frame.size.height = frame.size.height - 150;
        }
        itemsBgView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
