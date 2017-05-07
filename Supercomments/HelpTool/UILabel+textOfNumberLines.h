//
//  UILabel+textOfNumberLines.h
//
//  Created by students on 16/4/17.
//  Copyright © 2016年 students. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (textOfNumberLines)
+ (NSAttributedString *)textOfNumberLines:(NSInteger )numberLines withLabel:(UILabel *)label;
@end
