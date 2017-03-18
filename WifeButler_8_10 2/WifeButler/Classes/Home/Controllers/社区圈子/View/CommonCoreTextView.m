//
//  CommonCoreTextView.m
//  docClient
//
//  Created by paopao on 16/8/2.
//  Copyright © 2016年 luo. All rights reserved.
//

#import "CommonCoreTextView.h"
#import <CoreText/CoreText.h>

@interface CommonCoreTextView ()
{
    CTFrameRef _frame;
    NSMutableAttributedString *content;
    NSArray *dataArray;
    NSRange _selectRange;
    NSString *selectText;
    BOOL isSelect; // 控制是否显示高亮背景
}

@property (nonatomic, strong) UILongPressGestureRecognizer *longTapRecognizer;

@property (nonatomic, strong) NSMutableArray *rangeArray;

@end

@implementation CommonCoreTextView

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _overrangShouldReceiveTouch = YES;
    }
    return self;
}

-(NSMutableArray *)rangeArray
{
    if (_rangeArray == nil) {
        _rangeArray = [NSMutableArray array];
    }
    return _rangeArray;
}

//-(void)addLongTapRecognizer
//{
//    if (_longTapRecognizer == nil) {
//         _longTapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapSelectTextClick:)];
//    }
//    [self addGestureRecognizer:_longTapRecognizer];
//}

//-(void)longTapSelectTextClick:(UILongPressGestureRecognizer *)recognizer
//{
//    if (recognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder]){
//        return;
//    }
//    UIMenuController *menuController = [UIMenuController sharedMenuController];
//    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(didCopyItemClick)];
//    [menuController setMenuItems:@[copyItem]];
//    UIPasteboard *pab = [UIPasteboard generalPasteboard];
//    [pab setString:selectText];
//    NSLog(@"复制..");
//}

-(BOOL)shouldReceiveTouch:(UITouch *)touch{
    //获取触摸点击当前view的坐标位置
    CGPoint location = [touch locationInView:self];
    [self touchPoint:location isBegin:YES];
    return isSelect;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取UITouch对象
    UITouch *touch = [touches anyObject];
    //获取触摸点击当前view的坐标位置
    CGPoint location = [touch locationInView:self];
    [self touchPoint:location isBegin:YES];
    if (!isSelect) {
//        [super touchesBegan:touches withEvent:event];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    //获取UITouch对象
    UITouch *touch = [touches anyObject];
    //获取触摸点击当前view的坐标位置
    CGPoint location = [touch locationInView:self];
    [self touchPoint:location isBegin:NO];
    if (isSelect) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isSelect = NO;
            [self setNeedsDisplay];
        });
    }else{
//        [super touchesEnded:touches withEvent:event];
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    isSelect = NO;
    [self setNeedsDisplay];
}

// 长按
-(void)longTapRecognizerClick:(UILongPressGestureRecognizer *)recognizer
{
    [self touchPoint:[recognizer locationInView:self] isBegin:YES];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        isSelect = NO;
        [self setNeedsDisplay];
    }
    
}


-(void)touchPoint:(CGPoint)location isBegin:(BOOL)isBegin
{
    //获取每一行
    CFArrayRef lines = CTFrameGetLines(_frame);
    CGPoint origins[CFArrayGetCount(lines)];
    //获取每行的原点坐标
    CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), origins);
    CTLineRef line = NULL;
    CGPoint lineOrigin = CGPointZero;
    for (int i= 0; i < CFArrayGetCount(lines); i++)
    {
        CGPoint origin = origins[i];
        CGPathRef path = CTFrameGetPath(_frame);
        //获取整个CTFrame的大小
        CGRect rect = CGPathGetBoundingBox(path);
        NSLog(@"origin:%@",NSStringFromCGPoint(origin));
        NSLog(@"rect:%@",NSStringFromCGRect(rect));
        //坐标转换，把每行的原点坐标转换为uiview的坐标体系
        CGFloat y = rect.origin.y + rect.size.height - origin.y;
        NSLog(@"y:%f",y);
        //判断点击的位置处于那一行范围内
        if ((location.y <= y) && (location.x >= origin.x))
        {
            line = CFArrayGetValueAtIndex(lines, i);
            lineOrigin = origin;
            break;
        }
    }
    
    location.x -= lineOrigin.x;
    //获取点击位置所处的字符位置，就是相当于点击了第几个字符
    CFIndex index = CTLineGetStringIndexForPosition(line, location);
    NSLog(@"index:%ld",index);
    if (!self.overrangShouldReceiveTouch) {
        CGFloat offset;
        CGFloat retoffset = CTLineGetOffsetForStringIndex(line, index, &offset);
        NSLog(@"CTLineGetOffsetForStringIndex location.x = %f, offset = %f", location.x, retoffset);
        //判断点击的字符是否在需要处理点击事件的字符串范围内，这里是hard code了需要触发事件的字符串范围
        if (retoffset + 10 < location.x) {// 点击位置超出文本位置
            return;
        }
    }
    NSInteger rangeIndex = 0;
    for (NSString *str in self.rangeArray) {
        NSRange range = NSRangeFromString(str);
        if (index >= range.location && index <= range.length) {
            rangeIndex = [self.rangeArray indexOfObject:str];
            if (isBegin) {
                _selectRange = range;
                isSelect = YES;
                selectText = [content.string substringWithRange:NSMakeRange(range.location, range.length - range.location)];
                [self setNeedsDisplay];
            }
            break;
        }
    }
    if (!isBegin && isSelect) { // 点击结束执行
        if (self.didHighlightTextWithIndexClick) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.didHighlightTextWithIndexClick(rangeIndex);
            });
        }
    }else if (!isBegin && !isSelect){
        if (self.didOtherTextClick) {
            self.didOtherTextClick();
        }
    }
}


-(void)binWithAttributeStr:(NSAttributedString *)attributeStr selectRangeArray:(NSArray *)selectRangeArray
{
    
    self.rangeArray = [selectRangeArray mutableCopy];
//    NSAttributedString * a = [[NSAttributedString alloc]initWithString: @"user_28304: 圈子人不多哦"];
    content = [[NSMutableAttributedString alloc] initWithAttributedString:attributeStr];
   
    //换行模式，设置段落属性
//    CTParagraphStyleSetting lineBreakMode;
//    CGFloat _linespace = 2.0f;
//    lineBreakMode.spec = kCTParagraphStyleSpecifierLineSpacing;
//    lineBreakMode.value = &_linespace;
//    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
//    CTParagraphStyleSetting settings[] = {
//        lineBreakMode
//    };
//    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(id)style forKey:(id)kCTParagraphStyleAttributeName ];
//    [content addAttributes:attributes range:NSMakeRange(0, [content length])];
    [self setNeedsDisplay];
}
#define MedRefWordColorLongRecognizerGray  @"#c7c7c5"  // 长按文字内容背景色

#define MedRefWordColorLongRecognizerBlue  @"#ccd2df"  // 长按分享内容背景色
// 绘制
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    NSLog(@"begin-------rect:%@",NSStringFromCGRect(rect));
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置context的ctm，用于适应core text的坐标体系
    CGContextSaveGState(context);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    //设置CTFramesetter
    CTFramesetterRef framesetter =  CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    //创建CTFrame
    _frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, content.length), path, NULL);
    
    if (isSelect) {
        NSArray * arrLines = (NSArray *)CTFrameGetLines(_frame);
        // 获取所有行的origin
        CGPoint lineOrigins[arrLines.count];
        CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), lineOrigins);
        for (int i = 0; i < arrLines.count ; i ++) {
            CTLineRef line = (__bridge CTLineRef)arrLines[i];
            NSArray * arrRuns = (NSArray *)CTLineGetGlyphRuns(line);
            // 当前行的origin
            CGPoint origin = lineOrigins[i];
            
            for (int j = 0 ; j < arrRuns.count; j ++) {
                CTRunRef run = (__bridge CTRunRef)arrRuns[j];
                CFRange runRange = CTRunGetStringRange(run);
                
                if ((runRange.location >= _selectRange.location && runRange.location < _selectRange.length) && (runRange.location + runRange.length <= _selectRange.length)) {
                    CGRect runBounds = CGRectZero;
                    
                    CGFloat ascent, descent, leading;
                    CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
                    runBounds.size.width = width;
                    runBounds.size.height = ascent + descent;
                    
                    // 获取x偏移量
                    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                    runBounds.origin.x = origin.x + xOffset;
                    runBounds.origin.y = origin.y - descent;
                    // 绘制背景颜色区
                    CGContextSetFillColorWithColor(context,HexCOLOR(MedRefWordColorLongRecognizerGray).CGColor);
                    CGContextFillRect(context,runBounds);
                    CGContextSetStrokeColorWithColor(context,HexCOLOR(MedRefWordColorLongRecognizerGray).CGColor);
                 
                }
            }
        }
    }
    //把文字内容绘制出来
    CTFrameDraw(_frame, context);
    CGContextRestoreGState(context);
    NSLog(@"end------");
}

// 计算高度
+(CGFloat)getArrtibutedStrHeightWith:(NSAttributedString *)attributeStr coreTextViewWidth:(CGFloat)width
{
//    NSMutableAttributedString *mutableaStr = [attributeStr mutableCopy];
//    //换行模式，设置段落属性
//    CTParagraphStyleSetting lineBreakMode;
//    CGFloat _linespace = 2.0f;
//    lineBreakMode.spec = kCTParagraphStyleSpecifierLineSpacing;
//    lineBreakMode.value = &_linespace;
//    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
//    CTParagraphStyleSetting settings[] = {
//        lineBreakMode
//    };
//    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(id)style forKey:(id)kCTParagraphStyleAttributeName ];
//    [mutableaStr addAttributes:attributes range:NSMakeRange(0, [mutableaStr length])];
    CGSize rectSize = [CommonCoreTextView getAttributedStringRectWithString:attributeStr WidthValue:width];
    if (attributeStr.string.length > 0) {
        return rectSize.height ;
    }else{
        return 0;
    }
}

// 计算绘制的区域大小
+ (CGSize)getAttributedStringRectWithString:(NSAttributedString *)string  WidthValue:(int)width
{
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 1000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 1000 - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    
    line = (__bridge CTLineRef) [linesArray objectAtIndex:0];
    CGFloat rectWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &leading); // 获取第一行的宽度
    CFRelease(textFrame);
    CGSize size = CGSizeMake(ceilf(rectWidth), total_height);
    return size;
    
}

@end
