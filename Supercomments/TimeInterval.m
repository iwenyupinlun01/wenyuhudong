//
//  TimeInterval.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/27.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "TimeInterval.h"

@implementation TimeInterval




+(BOOL)datetime:(NSString *)datestr
{
    NSString*  format = @"YYYY-MM-dd HH:mm:ss";
    NSInteger timeinter = [datestr intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeinter];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSString *modeltimestr = confromTimespStr;
    //首先创建格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //然后创建日期对象
    NSDate *date1 = [dateFormatter dateFromString:modeltimestr];
    NSDate *date = [NSDate date];
    //计算时间间隔（单位是秒）
    NSTimeInterval time = [date1 timeIntervalSinceDate:date];
    //计算天数、时、分、秒
    int days = ((int)time)/(3600*24);
//    int hours = ((int)time)%(3600*24)/3600;
//    int minutes = ((int)time)%(3600*24)%3600/60;
//    int seconds = ((int)time)%(3600*24)%3600%60;
    
    if (days>14) {
        return NO;
    }else
    {
        return YES;
    }
    
}



@end
