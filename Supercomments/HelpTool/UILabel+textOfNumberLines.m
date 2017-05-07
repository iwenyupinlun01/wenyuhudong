//
//  UILabel+textOfNumberLines.m
//
//  Created by students on 16/4/17.
//  Copyright © 2016年 students. All rights reserved.
//

#import "UILabel+textOfNumberLines.h"
#import <CoreText/CoreText.h>
#import "HelpTool.h"
@implementation UILabel (textOfNumberLines)
+ (NSAttributedString *)textOfNumberLines:(NSInteger )numberLines withLabel:(UILabel *)label{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    //获取到每一行数组
    for (id line in lines){
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    //处理数组中的数据
    NSMutableAttributedString *stringLast = [NSMutableAttributedString new];
    
    if (linesArray.count >= numberLines) {
        NSString *lastStr = linesArray[numberLines - 1];
        
        CGSize lastSize = [HelpTool sizeWithString:lastStr font:font maxSize:label.frame.size];
        NSString *moreStr =@"...  查看更多";
        CGSize moreSize = [HelpTool sizeWithString:moreStr font:font maxSize:label.frame.size];
        if (lastSize.width > label.frame.size.width - moreSize.width) {
            NSMutableString *mustr = [NSMutableString new];
            for (int i = 0; i < numberLines; i++) {
                NSString *str = linesArray[i];
                if (i == numberLines - 1) {
                    //
                    NSString *temp =nil;
                    CGFloat lastLength = 0;
                    for(int j =0; j < [str length]; j++){
                        temp = [str substringWithRange:NSMakeRange(j,1)];
                        CGSize size = [HelpTool sizeWithString:temp font:font maxSize:label.frame.size];
                        lastLength += size.width;
                        //获取第n行每个字的宽度 如果大于加上更多的宽度 那么截取字符串 拼接更多
                        if (lastLength > label.frame.size.width - moreSize.width) {
                            str = [linesArray[i] substringToIndex:j];
                            str = [NSString stringWithFormat:@"%@%@",str,moreStr];
                            break;
                        }
                        NSLog(@"第%d个字是:%@---length:%f",j,temp,lastLength);
                    }
                }
                [mustr appendString:str];
            }
            stringLast = [[NSMutableAttributedString alloc] initWithString:mustr];
            [stringLast addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(mustr.length - 4, 4)];
            
        }else{
            stringLast = [[NSMutableAttributedString alloc] initWithString:label.text];
        }
    }else{
        stringLast = [[NSMutableAttributedString alloc] initWithString:label.text];
    }
    
    return stringLast;
}
@end
