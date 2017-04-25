//
//  strisNull.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/25.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "strisNull.h"

@implementation strisNull
+ (BOOL )isNullToString:(id)string
{
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"])
    {
        return YES;
        
    }else
    {
        
        return NO;
    }
}
@end
