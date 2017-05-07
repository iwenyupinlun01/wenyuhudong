 //
//  HelpTool.h
//  EasyGo
//
//  Created by 鞠凝玮 on 15/7/8.
//  Copyright (c) 2015年 Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HelpTool : NSObject


//求文本宽高
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;
@end
