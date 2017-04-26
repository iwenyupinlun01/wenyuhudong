//
//  tokenstr.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/25.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "tokenstr.h"

@implementation tokenstr

+(NSString *)tokenstrfrom
{
    NSString *tokenstr = [[NSString alloc] init];
    NSUserDefaults *userdefat = [NSUserDefaults standardUserDefaults];
    NSString *token = [userdefat objectForKey:@"tokenuser"];
    if (token.length==0) {
        tokenstr = @"";
    }
    else
    {
        tokenstr = token;
    }
    NSLog(@"token--------%@",tokenstr);
    return tokenstr;
}

+(NSString *)nicknamestrfrom
{
    NSString *nicknamestr = [[NSString alloc] init];
    
    return nicknamestr;
}

@end
