                                                                                        //
//  HelpTool.m
//  EasyGo
//
//  Created by 鞠凝玮 on 15/7/8.
//  Copyright (c) 2015年 Ju. All rights reserved.
//

#import "HelpTool.h"


@implementation HelpTool

//球文本宽高
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize

{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize size = [str boundingRectWithSize:maxSize
                                    options:NSStringDrawingTruncatesLastVisibleLine |
                                            NSStringDrawingUsesLineFragmentOrigin |
                                            NSStringDrawingUsesFontLeading
                                 attributes:dict
                                    context:nil].size;
    
    return size;
}
@end
