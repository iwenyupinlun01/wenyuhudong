//
//  UILabel+MultipleLines.m
//  UILabelDemo
//
//  Created by zhongpingjiang on 16/9/12.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import "UILabel+MultipleLines.h"
#import <objc/runtime.h>

@implementation UILabel (MultipleLines)

- (void)setLbTextSize:(CGSize)lbTextSize{
    
    objc_setAssociatedObject(self, @selector(lbTextSize), [NSValue valueWithCGSize:lbTextSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)lbTextSize{
    
    return [objc_getAssociatedObject(self, @selector(lbTextSize)) CGSizeValue];
}

//设置
- (CGSize)setText:(NSString *)text lines:(NSInteger)lines andLineSpacing:(CGFloat)lineSpacing constrainedToSize:(CGSize)cSize{
    
    self.numberOfLines = lines;  //限定行数
    if (!text || text.length ==0) {
        return CGSizeZero;
    }
    
    self.lbTextSize = [self.class sizeWithText:text lines:lines font:self.font andLineSpacing:lineSpacing constrainedToSize:cSize];
    
    if ([self p_isSingleLine:self.lbTextSize.height font:self.font]) {
        lineSpacing = 0.0f;
    }
    
    //设置文字的属性
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;//结尾部分的内容以……方式省略
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    [self setAttributedText:attributedString];
    self.bounds = CGRectMake(0, 0, self.lbTextSize.width, self.lbTextSize.height);
    return self.frame.size;
}

//根据文本占用的size
+ (CGSize)sizeWithText:(NSString *)text lines:(NSInteger)lines font:(UIFont*)font andLineSpacing:(CGFloat)lineSpacing constrainedToSize:(CGSize)cSize{
    
    if (!text || text.length ==0) {
        return CGSizeZero;
    }
    CGFloat oneLineHeight = font.lineHeight;
    CGSize textSize = [text boundingRectWithSize:cSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    CGFloat rows = textSize.height / oneLineHeight;
    CGFloat realHeight = oneLineHeight;
    // 0 不限制行数
    if (lines == 0) {
        if (rows >= 1) {
            realHeight = (rows * oneLineHeight) + (rows - 1) * lineSpacing;
        }
    }else{
        if (rows >= lines) {
            rows = lines;
        }
        realHeight = (rows * oneLineHeight) + (rows - 1) * lineSpacing;
    }
    
    return CGSizeMake(textSize.width, realHeight);
}

#pragma mark - private methods
//单行的判断
- (BOOL)p_isSingleLine:(CGFloat)height font:(UIFont*)font{
    
    BOOL isSingle = NO;;
    CGFloat oneLineHeight = self.font.lineHeight;
    if (fabs(height - oneLineHeight)  < 0.001f) {
        isSingle = YES;
    }
    return isSingle;
}

@end
