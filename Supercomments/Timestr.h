//
//  Timestr.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/24.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timestr : NSObject
+(NSString *)datetime:(NSString *)datestr;

//获取当前系统的时间戳
+(NSString* )getNowTimestamp;
@end
