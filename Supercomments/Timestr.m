//
//  Timestr.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/24.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "Timestr.h"

@implementation Timestr
//时间计算
+(NSString *)datetime:(NSString *)datestr
{
    NSTimeInterval time=[datestr doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    NSDate *date = [NSDate date];
    //计算时间间隔（单位是秒）
    NSTimeInterval time2 = [date timeIntervalSinceDate:detaildate];
    //计算天数、时、分、秒
    
    int days = ((int)time2)/(3600*24);
    int hours = ((int)time2)%(3600*24)/3600;
    int minutes = ((int)time2)%(3600*24)%3600/60;
    int seconds = ((int)time2)%(3600*24)%3600%60;
    
    NSString *dateContent = [[NSString alloc] initWithFormat:@"过去%i天%i小时%i分%i秒",days,hours,minutes,seconds];
    NSLog(@"datacunt=====%@",dateContent);
    
    NSString *fanhuistr = [[NSString alloc] init];
    if (days>=365) {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
        //输出格式为：2010-10-27 10:22:13
        NSLog(@"%@",currentDateStr);
        fanhuistr = currentDateStr;
    }
    else if(hours>=72&&hours<365)
    {
        //M月M日
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
        //输出格式为：2010-10-27 10:22:13
        NSLog(@"%@",currentDateStr);
        fanhuistr = currentDateStr;
    }else if (hours<72&&hours>=48)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"HH:mm"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
        //输出格式为：2010-10-27 10:22:13
        NSLog(@"%@",currentDateStr);
        
        fanhuistr = [NSString stringWithFormat:@"%@%@",@"前天",@"currentDateStr"];
        
    }else if (hours<48&&hours>=24)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"HH:mm"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
        //输出格式为：2010-10-27 10:22:13
        NSLog(@"%@",currentDateStr);
        
        fanhuistr = [NSString stringWithFormat:@"%@%@",@"昨天",@"currentDateStr"];
    }else if (hours<24&&hours>=1)
    {
        fanhuistr = [NSString stringWithFormat:@"%d%@%@",hours,@"小时",@"前"];
    }else
    {
        fanhuistr = [NSString stringWithFormat:@"%d%@%@",minutes,@"分钟",@"前"];
    }
    
    return fanhuistr;
}
@end
